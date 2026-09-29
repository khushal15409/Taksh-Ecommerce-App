import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Modular secure storage helper for sensitive data (auth tokens, etc.)
abstract class SecureStore {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  Future<void> saveGuestToken(String token);
  Future<String?> getGuestToken();
  Future<void> clearGuestToken();
}

class SecureStoreImpl implements SecureStore {
  static const _tokenKey = 'auth_token';
  static const _guestTokenKey = 'guest_cart_token';
  final FlutterSecureStorage _storage;

  SecureStoreImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> saveGuestToken(String token) =>
      _storage.write(key: _guestTokenKey, value: token);

  @override
  Future<String?> getGuestToken() => _storage.read(key: _guestTokenKey);

  @override
  Future<void> clearGuestToken() async {
    await _storage.delete(key: _guestTokenKey);
  }
}
