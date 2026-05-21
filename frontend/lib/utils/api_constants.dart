import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Get base URL from environment variables - fail if not configured
  static String get baseUrl {
    final url = dotenv.env['BACKEND_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('BACKEND_BASE_URL not configured in .env file');
    }
    return url;
  }

  // Endpoints de Autenticação
  static String get loginEndpoint => "$baseUrl/api/auth/login";
  static String get cadastroEndpoint => "$baseUrl/api/auth/cadastro";
  static String get verificacaoEndpoint => "$baseUrl/api/auth/verificar";

  // Endpoints de Publicações
  // Usado para CRIAR publicação (POST)
  static String get publicacoesEndpoint => "$baseUrl/api/publicacoes";

  // Usado para BUSCAR o feed (GET)
  static String get feedEndpoint => "$baseUrl/api/publicacoes/feed";

  // Adicionar locais por link
  static String get adicionarLocalLinkEndpoint => "$baseUrl/api/locais/adicionar-por-link";

  // Adicionar locais manualmente
  static String get adicionarManualEndpoint => "$baseUrl/api/locais/adicionar-manual";

  // Reuniões
  static String get reunioesEndpoint => "$baseUrl/api/reunioes";
}
