import 'dart:convert';

import 'package:winarch/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

const _keyAuthToken = 'auth_token';
const _keyAuthRefreshToken = 'auth_refresh_token';
const _keyAuthUser = 'auth_user';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required SecureStorageHelper storage})
      : _storage = storage;

  final SecureStorageHelper _storage;

  @override
  Future<void> saveSession({
    required String token,
    required String refreshToken,
    required AuthUser user,
  }) async {
    await _storage.write(_keyAuthToken, token);
    await _storage.write(_keyAuthRefreshToken, refreshToken);
    await _storage.write(
      _keyAuthUser,
      jsonEncode({'id': user.id, 'email': user.email}),
    );
  }

  @override
  Future<String?> getAccessToken() => _storage.read(_keyAuthToken);

  @override
  Future<AuthUser?> getCurrentUser() async {
    final json = await _storage.read(_keyAuthUser);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AuthUser(
        id: map['id'] as String,
        email: map['email'] as String,
      );
    } catch (_) {
      await _storage.delete(_keyAuthUser);
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(_keyAuthToken);
    await _storage.delete(_keyAuthUser);
  }

  @override
  Future<String?> getRefreshToken() => _storage.read(_keyAuthRefreshToken);
}
