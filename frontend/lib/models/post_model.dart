import '../utils/api_constants.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String text;
  final List<String> imageUrls;
  final DateTime createdAt;

  int totalLikes;
  bool curtiu;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.text,
    required this.imageUrls,
    required this.createdAt,
    required this.totalLikes,
    required this.curtiu,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final List<String> urls = _extractUrls(json);

    return PostModel(
      id: json['id']?.toString() ?? '',
      userId: json['usuarioId']?.toString() ?? '',
      userName: json['nomeUsuario'] ?? 'Usuário',
      userAvatar: json['fotoUsuario'],
      text: json['texto'] ?? '',
      imageUrls: urls,
      createdAt:
          json['dataCriacao'] != null
              ? DateTime.parse(json['dataCriacao'])
              : DateTime.now(),

      // Vem do back end
      totalLikes: json['totalLikes'] ?? 0,
      curtiu: json['curtiu'] ?? false,
    );
  }

  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  static List<String> _extractUrls(Map<String, dynamic> json) {
    final List<String> urls = [];

    final dynamic conteudoUrls = json['conteudoUrls'];
    if (conteudoUrls is List) {
      for (final dynamic raw in conteudoUrls) {
        final normalized = _normalizeUrl(raw?.toString());
        if (normalized != null) urls.add(normalized);
      }
    }

    if (urls.isEmpty) {
      final singleRaw = json['conteudoUrl']?.toString();
      if (singleRaw != null) {
        final List<String> parts = _splitPotentialUrls(singleRaw);
        for (final part in parts) {
          final normalized = _normalizeUrl(part);
          if (normalized != null) urls.add(normalized);
        }
      }
    }

    return urls;
  }

  static List<String> _splitPotentialUrls(String raw) {
    // Supports comma, semicolon, or whitespace separated values (colon excluded to keep http://)
    final List<String> parts = raw
      .split(RegExp(r'[,;\s]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isNotEmpty) return parts;

    return [raw];
  }

  static String? _normalizeUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http')) return raw;

    final base =
        ApiConstants.baseUrl.endsWith('/')
            ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
            : ApiConstants.baseUrl;

    final path = raw.startsWith('/') ? raw : '/$raw';
    return '$base$path';
  }
}
