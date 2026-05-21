import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../utils/api_constants.dart';
import '../utils/validation_utils.dart';

class PublicacaoService {
  // =========================
  // GET FEED
  // =========================
  static Future<List<PostModel>> buscarFeed(String email) async {
    // Input validation
    if (!ValidationUtils.isValidEmail(email)) {
      throw Exception('Email válido é obrigatório para buscar feed');
    }
    
    final uri = Uri.parse('${ApiConstants.feedEndpoint}?page=0&size=10');

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'email': email},
      );

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(body);

        final List lista = data['content'];

        return lista.map((e) => PostModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        return []; // Empty feed
      } else {
        throw Exception('Erro ao carregar feed. Tente novamente.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    }
  }
}
