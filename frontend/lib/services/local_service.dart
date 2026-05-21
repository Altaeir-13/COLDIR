import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import '../utils/validation_utils.dart';

class LocalService {
  
  // Adicionar por Link
  Future<Map<String, dynamic>> adicionarViaLink(String url) async {
    // Input validation
    if (url.isEmpty) {
      throw Exception('URL é obrigatória');
    }
    
    // URL format validation
    if (!ValidationUtils.isValidUrl(url)) {
      throw Exception('Formato de URL inválido');
    }
    
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.adicionarLocalLinkEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"url": url}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  // --- CORREÇÃO AQUI: Definindo os parâmetros nomeados corretamente ---
  Future<Map<String, dynamic>> adicionarManual({
    required String nome,
    required String descricao,
    required String endereco,
    required String cidade,
    required String imagem,
  }) async {
    try {
      final url = ApiConstants.adicionarManualEndpoint; 

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": nome,
          "descricao": descricao,
          "endereco_texto": endereco, // Mapeia para o backend Java
          "cidade_texto": cidade,     // Mapeia para o backend Java
          "imagem_url": imagem,       // Mapeia para o backend Java (snake_case ou camelCase, verifique o Java)
        }),
      );

      if (response.statusCode == 200) {
        // Sucesso: retorna os dados do local salvo
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Erro: ${response.body}');
      }
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }
}