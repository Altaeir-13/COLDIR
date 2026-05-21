import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/reuniao_model.dart';
import '../utils/api_constants.dart';

class ReuniaoService {
  final String baseUrl = ApiConstants.reunioesEndpoint;

  // Busca a próxima reunião
  Future<ReuniaoModel?> getProximaReuniao() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/proxima'));

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        return ReuniaoModel.fromJson(json);
      }

      if (response.statusCode == 204) {
        return null;
      }

      throw Exception('Erro ao buscar próxima reunião: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro de conexão. Verifique sua internet.');
    }
  }

  // Histórico de reuniões encerradas
  Future<List<ReuniaoModel>> getHistorico() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/historico'));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => ReuniaoModel.fromJson(item)).toList();
      }

      if (response.statusCode == 404) {
        return [];
      }

      throw Exception('Erro ao carregar histórico: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro de conexão. Verifique sua internet.');
    }
  }

  // Cria uma nova reunião com cronograma
  Future<bool> criarReuniao(ReuniaoModel reuniao) async {
    try {
      final uri = Uri.parse(baseUrl); // Bate em /api/reunioes
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token', // Se tiver login no futuro, poe o token aqui
        },
        // O toJson() agora já inclui a lista de cronograma automaticamente!
        body: jsonEncode(reuniao.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true; // Sucesso
      } else {
        // Debug: Mostra o erro que veio do Java se der ruim
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  // Edita uma reunião existente
  Future<void> editarReuniao(ReuniaoModel reuniao) async {
    try {
      // Usamos o ID da reunião na URL, padrão REST: /api/reunioes/10
      final response = await http.put(
        Uri.parse('$baseUrl/${reuniao.idReuniao}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(reuniao.toJson()),
      );

      if (response.statusCode != 200) {
        final erroMsg = jsonDecode(utf8.decode(response.bodyBytes))['message'] ?? 'Erro ao editar';
        throw Exception(erroMsg);
      }
    } catch (e) {
      throw Exception('Falha ao conectar com o servidor: $e');
    }
  }
}
