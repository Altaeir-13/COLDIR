import 'package:shared_preferences/shared_preferences.dart';

/// Service for secure storage of sensitive data
class SecureStorageService {
  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  // Keys for stored values
  static const String _keyEmail = 'email';
  static const String _keyEmailUsuario = 'email_usuario';
  static const String _keyIdUsuario = 'id_usuario';
  static const String _keyRememberLogin = 'remember_login';
  static const String _keyRememberedEmail = 'remembered_email';
  // WARNING: Storing passwords is a security anti-pattern. This is only used for "remember me"
  // functionality and should be replaced with secure token-based authentication in production.
  // Consider implementing refresh tokens or biometric authentication instead.
  static const String _keyRememberedPassword = 'remembered_password';

  // Email storage
  static Future<void> setEmail(String email) async {
    final prefs = await _prefs();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await _prefs();
    return prefs.getString(_keyEmail);
  }

  static Future<void> setEmailUsuario(String email) async {
    final prefs = await _prefs();
    await prefs.setString(_keyEmailUsuario, email);
  }

  static Future<String?> getEmailUsuario() async {
    final prefs = await _prefs();
    return prefs.getString(_keyEmailUsuario);
  }

  // User ID storage
  static Future<void> setIdUsuario(int id) async {
    final prefs = await _prefs();
    await prefs.setInt(_keyIdUsuario, id);
  }

  static Future<int?> getIdUsuario() async {
    final prefs = await _prefs();
    return prefs.getInt(_keyIdUsuario);
  }

  // Remember login storage
  static Future<void> setRememberLogin(bool remember) async {
    final prefs = await _prefs();
    await prefs.setBool(_keyRememberLogin, remember);
  }

  static Future<bool> getRememberLogin() async {
    final prefs = await _prefs();
    return prefs.getBool(_keyRememberLogin) ?? false;
  }

  static Future<void> setRememberedEmail(String email) async {
    final prefs = await _prefs();
    await prefs.setString(_keyRememberedEmail, email);
  }

  static Future<String?> getRememberedEmail() async {
    final prefs = await _prefs();
    return prefs.getString(_keyRememberedEmail);
  }

  static Future<void> setRememberedPassword(String password) async {
    final prefs = await _prefs();
    await prefs.setString(_keyRememberedPassword, password);
  }

  static Future<String?> getRememberedPassword() async {
    final prefs = await _prefs();
    return prefs.getString(_keyRememberedPassword);
  }

  // Remove specific keys
  static Future<void> removeRememberLogin() async {
    final prefs = await _prefs();
    await prefs.remove(_keyRememberLogin);
  }

  static Future<void> removeRememberedEmail() async {
    final prefs = await _prefs();
    await prefs.remove(_keyRememberedEmail);
  }

  static Future<void> removeRememberedPassword() async {
    final prefs = await _prefs();
    await prefs.remove(_keyRememberedPassword);
  }

  // Clear all storage
  static Future<void> clearAll() async {
    final prefs = await _prefs();
    await prefs.clear();
  }
}
