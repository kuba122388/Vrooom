import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  final FlutterSecureStorage _secureStorage;

  AuthStorage(this._secureStorage);

  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';

  Future<void> saveLoginData(String token, int userId) async {
    await _secureStorage.write(key: _tokenKey, value: token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _tokenKey);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
