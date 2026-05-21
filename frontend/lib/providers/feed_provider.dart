import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../services/secure_storage_service.dart';
import '../utils/api_constants.dart';

class FeedProvider extends ChangeNotifier {
  final String baseUrl = ApiConstants.publicacoesEndpoint;

  // ============================
  // ESTADO DO FEED
  // ============================
  List<PostModel> _posts = [];

  bool isLoading = false; // carregamento inicial / refresh
  bool isFetchingMore = false; // scroll infinito
  bool hasMore = true;

  int _page = 0;
  final int _pageSize = 10;
  final int _maxPostsInMemory = 200;

  List<PostModel> get posts => _posts;

  // ============================
  // 1. CARREGA FEED DO ZERO
  // Login, pull-to-refresh, criar post
  // ============================
  Future<void> fetchInitialPosts({String? emailUsuario}) async {
    isLoading = true;
    hasMore = true;
    _page = 0;

    notifyListeners();

    try {
      final novosPosts = await _fetchFromApi(
        page: _page,
        emailUsuario: emailUsuario,
      );

      _posts = novosPosts;
      hasMore = novosPosts.length == _pageSize;
    } catch (e) {
      debugPrint('Erro ao carregar feed inicial: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================
  // 2. SCROLL INFINITO
  // ============================
  Future<void> fetchMorePosts({String? emailUsuario}) async {
    if (isFetchingMore || !hasMore) return;

    isFetchingMore = true;
    notifyListeners();

    try {
      _page++;

      final novosPosts = await _fetchFromApi(
        page: _page,
        emailUsuario: emailUsuario,
      );

      if (novosPosts.isEmpty) {
        hasMore = false;
      } else {
        _posts.addAll(novosPosts);

        // Limite de memória
        if (_posts.length > _maxPostsInMemory) {
          _posts = _posts.sublist(_posts.length - _maxPostsInMemory);
        }
      }
    } catch (e) {
      debugPrint('Erro no scroll infinito: $e');
    } finally {
      isFetchingMore = false;
      notifyListeners();
    }
  }

  // ============================
  // 3. FETCH REUTILIZÁVEL
  // ============================
  Future<List<PostModel>> _fetchFromApi({
    required int page,
    String? emailUsuario,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.feedEndpoint}?page=$page&size=$_pageSize',
    );

    String? resolvedEmail = emailUsuario;
    if ((resolvedEmail ?? '').isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      resolvedEmail =
          prefs.getString('email') ??
          prefs.getString('email_usuario') ??
          await SecureStorageService.getEmail() ??
          await SecureStorageService.getEmailUsuario();
    }

    final response = await http.get(
      uri,
      headers: {
        if (resolvedEmail != null && resolvedEmail.isNotEmpty)
          'email': resolvedEmail,
      },
    );

    if (response.statusCode != 200) return [];

    final dynamic data = jsonDecode(utf8.decode(response.bodyBytes));

    List<dynamic> listaDePosts;
    if (data is Map<String, dynamic> && data.containsKey('content')) {
      listaDePosts = data['content'];
    } else if (data is List) {
      listaDePosts = data;
    } else {
      listaDePosts = [];
    }

    return listaDePosts.map((json) => PostModel.fromJson(json)).toList();
  }

  // ============================
  // 4. LIKE
  // ============================
  Future<void> likePost(PostModel post) async {
    try {
      final idUsuario = await SecureStorageService.getIdUsuario();

      if (idUsuario == null) {
        throw Exception('Sessão expirada. Faça login novamente.');
      }

      final url =
          '${ApiConstants.publicacoesEndpoint}/${post.id}/like?idUsuario=$idUsuario';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final bool curtiuAgora = response.body.toLowerCase() == 'true';

        post.curtiu = curtiuAgora;
        post.totalLikes += curtiuAgora ? 1 : -1;

        if (post.totalLikes < 0) {
          post.totalLikes = 0;
        }

        notifyListeners();
      } else {
        debugPrint('Erro no like: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro ao curtir: $e');
      rethrow;
    }
  }

  // ============================
  // 5. ADICIONAR POST
  // ============================
  Future<void> addPost(
    String texto, {
    String? imageUrl,
    List<String>? imageUrls,
    String? emailUsuario,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resolvedEmail =
          emailUsuario ??
          prefs.getString('email') ??
          prefs.getString('email_usuario') ??
          await SecureStorageService.getEmail() ??
          await SecureStorageService.getEmailUsuario();

      if (resolvedEmail == null || resolvedEmail.isEmpty) {
        throw Exception('Sessão expirada. Faça login novamente.');
      }

      final List<String> resolvedUrls = [
        ...?imageUrls,
        if (imageUrl != null) imageUrl,
      ];

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'email': resolvedEmail,
        },
        body: jsonEncode({
          'tipo': resolvedUrls.isNotEmpty ? 'IMAGEM' : 'TEXTO',
          'titulo': '',
          'texto': texto,
          // Envia só a primeira para não estourar limite de 255 chars em alguns bancos
          'conteudoUrl': resolvedUrls.isNotEmpty ? resolvedUrls.first : '',
          // Lista completa para backends que aceitam array
          'conteudoUrls': resolvedUrls,
          'thumbnailUrl': '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchInitialPosts(emailUsuario: resolvedEmail);
      } else {
        throw Exception('Erro ao publicar: ${response.body}');
      }
    } catch (e) {
      debugPrint('💀 Erro no FeedProvider: $e');
      rethrow;
    }
  }

  // ============================
  // 6. COMENTÁRIOS
  // ============================
  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$postId/comments'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => CommentModel.fromMap(e)).toList();
      }
    } catch (e) {
      debugPrint('Erro ao buscar comentários: $e');
    }
    return [];
  }

  // ============================
  // 7. LOGOUT
  // ============================
  void clearFeed() {
    _posts.clear();
    _page = 0;
    hasMore = true;
    notifyListeners();
  }
}
