import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper around [FlutterSecureStorage] for app-wide use.
/// Use [secureStorageProvider] to obtain a singleton instance.
class SecureStorageHelper {
  SecureStorageHelper({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Reads the value for [key], or null if absent.
  Future<String?> read(String key) => _storage.read(key: key);

  /// Writes [value] for [key].
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// Deletes the value for [key].
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Deletes all keys and values.
  Future<void> clear() => _storage.deleteAll();

  Future<String?> getToken() => _storage.read(key: 'token');

  Future<String?> getRefreshToken() => _storage.read(key: 'refreshToken');

  Future<void> deleteToken() => _storage.delete(key: 'token');

  /// Writes access token and optionally refresh token (e.g. after refresh).
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    await _storage.write(key: 'token', value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: 'refreshToken', value: refreshToken);
    }
  }
}
