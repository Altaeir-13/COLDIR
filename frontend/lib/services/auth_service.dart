import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import '../utils/validation_utils.dart'; 

class AuthService {
  
  // --- Metodo para Fazer Login ---
  Future<Map<String, dynamic>> login(String email, String senha) async {
    // Input validation
    if (email.isEmpty || senha.isEmpty) {
      throw Exception('Email e senha são obrigatórios');
    }
    
    // Basic email format validation
    if (!ValidationUtils.isValidEmail(email)) {
      throw Exception('Formato de email inválido');
    }
    
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Email ou senha incorretos');
    } else {
      throw Exception('Falha no login. Tente novamente mais tarde.');
    }
  }

  // --- Metodo para Fazer Cadastro ---
  Future<void> cadastrar(String nome, String email, String senha, String telefone) async {
    // Input validation
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      throw Exception('Todos os campos obrigatórios devem ser preenchidos');
    }
    
    // Email validation
    if (!ValidationUtils.isValidEmail(email)) {
      throw Exception('Formato de email inválido');
    }
    
    // Password strength validation
    if (senha.length < ValidationUtils.minPasswordLength) {
      throw Exception('A senha deve ter no mínimo ${ValidationUtils.minPasswordLength} caracteres');
    }
    
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.cadastroEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nome": nome,
          "email": email,
          "senha": senha,
          "telefone": telefone,
          "cargo": "USUARIO" // Padrão para novos cadastros
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // Sucesso!
      } else if (response.statusCode == 409) {
        throw Exception('Email já cadastrado');
      } else {
        throw Exception('Falha ao cadastrar. Tente novamente mais tarde.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    }
  }

  // Exemplo de como deve ficar no seu Service do Flutter
  Future<bool> verificarCodigo(String email, String codigo) async {
    // Input validation
    if (email.isEmpty || codigo.isEmpty) {
      throw Exception('Email e código são obrigatórios');
    }
    
    if (codigo.length != ValidationUtils.verificationCodeLength) {
      throw Exception('O código deve ter ${ValidationUtils.verificationCodeLength} dígitos');
    }
    
    final response = await http.post(
      Uri.parse(ApiConstants.verificacaoEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "codigo": codigo,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Sucesso!
    } else if (response.statusCode == 400) {
      throw Exception('Código inválido ou expirado');
    } else {
      throw Exception('Erro na verificação. Tente novamente.');
    }
  }
}