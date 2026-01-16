import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // 🔐 Keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // =========================
  // TOKEN (existing – unchanged)
  // =========================

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // =========================
  // USER ID (new)
  // =========================

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<void> deleteUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // =========================
  // SESSION HELPERS (recommended)
  // =========================

  static Future<void> saveSession({
    required String token,
    required String userId,
  }) async {
    await saveToken(token);
    await saveUserId(userId);
  }

  static Future<bool> hasSession() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && userId != null;
  }

  static Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
