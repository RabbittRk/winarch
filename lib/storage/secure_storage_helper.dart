import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:winarch/features/auth/data/models/auth_response.dart';

/// Thin wrapper around [FlutterSecureStorage] for app-wide use.
/// Use [secureStorageProvider] to obtain a singleton instance.
///
/// Supports generic [readObject]/[writeObject] for any JSON-serializable type,
/// and auth-specific [getAuthResponse]/[setAuthResponse] for session persistence.
class SecureStorageHelper {
  SecureStorageHelper({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _keyAuth = 'auth';

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

  /// Reads a JSON object for [key] and decodes it with [fromJson], or null if absent.
  Future<T?> readObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final raw = await _storage.read(key: key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Encodes [value] with [toJson] and writes it for [key].
  Future<void> writeObject<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    await _storage.write(key: key, value: jsonEncode(toJson(value)));
  }

  /// Reads the stored [AuthResponse], or null if not logged in.
  Future<AuthResponse?> getAuthResponse() =>
      readObject(_keyAuth, AuthResponse.fromJson);

  /// Persists [value] (or removes if null). Use after login; clear on sign out.
  Future<void> setAuthResponse(AuthResponse? value) async {
    if (value == null) {
      await _storage.delete(key: _keyAuth);
    } else {
      await writeObject(_keyAuth, value, (v) => v.toJson());
    }
  }

  /// Access token from stored [AuthResponse], or null.
  Future<String?> getToken() async {
    final auth = await getAuthResponse();
    return auth?.accessToken;
  }

  /// Refresh token from stored [AuthResponse], or null.
  Future<String?> getRefreshToken() async {
    final auth = await getAuthResponse();
    return auth?.refreshToken;
  }

  Future<void> deleteToken() => delete(_keyAuth);

  /// Deletes stored auth (e.g. on sign out).
  Future<void> clearAuthTokens() => _storage.delete(key: _keyAuth);

  /// Updates stored [AuthResponse] with new tokens (e.g. after refresh).
  /// If no auth is stored, does nothing.
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    final auth = await getAuthResponse();
    if (auth == null) return;
    await setAuthResponse(
      auth.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken ?? auth.refreshToken,
      ),
    );
  }
}
