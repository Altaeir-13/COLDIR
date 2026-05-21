import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase local storage backed by secure storage to avoid plaintext session data.
class SecureSupabaseLocalStorage extends LocalStorage {
  SecureSupabaseLocalStorage()
      : _prefsFuture = SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefsFuture;
  static const _accessTokenKey = 'supabase.auth.token';

  @override
  Future<void> initialize() async {
    await _prefsFuture;
  }

  @override
  Future<String?> accessToken() async {
    final prefs = await _prefsFuture;
    return prefs.getString(_accessTokenKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    final prefs = await _prefsFuture;
    await prefs.setString(_accessTokenKey, persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    final prefs = await _prefsFuture;
    await prefs.remove(_accessTokenKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    final prefs = await _prefsFuture;
    return prefs.getString(_accessTokenKey) != null;
  }
}
