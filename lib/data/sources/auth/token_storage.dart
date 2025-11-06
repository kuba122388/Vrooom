import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _tokenStorage;

  TokenStorage(this._tokenStorage);

  static const String _tokenKey = 'jwt_token';

  Future<void> saveToken(String token) async {
    await _tokenStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _tokenStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    return await _tokenStorage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
