import 'package:flutter/material.dart';
import '/models/usuario_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  int? idUsuario;
  String? name;
  String? cargo; // Este é o campo que você quer
  String? profilePicturePath;
  String? _email;
  String? _phoneNumber;

  // =============================
  // GETTERS SEGUROS
  // =============================

  String get userName => name ?? "Usuário";

  // Retorna o cargo ou um valor padrão caso esteja nulo
  String get userCargo => cargo ?? "Cargo não definido";

  bool get isLoggedIn => _email != null && _email!.isNotEmpty;

  String get email {
    return _email ?? '';
  }

  String? get phoneNumber => _phoneNumber;

  UsuarioModel? get user {
    if (!isLoggedIn || name == null || idUsuario == null) return null;

    return UsuarioModel(
      idUsuario: idUsuario!,
      nome: name!,
      email: _email!,
      cargo: cargo, 
      fotoPerfil: profilePicturePath,
    );
  }

  // =============================
  // LOGIN
  // =============================
  Future<void> login({
    required String name,
    required String cargo, 
    required String email,
    required int id,
    String? photoUrl,
    String? phone,
    String? supabasePassword,
  }) async {
    this.name = name;
    this.cargo = cargo; 
    _email = email.trim();
    idUsuario = id;
    _phoneNumber = phone;
    profilePicturePath = photoUrl;

    notifyListeners();

    // Loga no Supabase (opcional se tiver senha)
    if (supabasePassword != null) {
      try {
        await loginSupabase(email, supabasePassword);
      } catch (e) {
        debugPrint("Erro Supabase: $e");
        // O login principal continua mesmo se o Supabase falhar
      }
    }
  }

  // =============================
  // LOGIN NO SUPABASE
  // =============================
  Future<void> loginSupabase(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      throw Exception("Falha ao logar no Supabase");
    }
  }

  // =============================
  // UPDATE
  // =============================
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? cargo, 
  }) {
    if (name != null) this.name = name;
    if (email != null) _email = email.trim();
    if (phone != null) _phoneNumber = phone;
    if (photoUrl != null) profilePicturePath = photoUrl;
    if (cargo != null) this.cargo = cargo;

    notifyListeners();
  }

  // =============================
  // LOGOUT
  // =============================
  void logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}

    idUsuario = null;
    name = null;
    cargo = null;
    _email = null;
    _phoneNumber = null;
    profilePicturePath = null;

    notifyListeners();
  }
}