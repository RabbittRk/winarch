import 'dart:async';

import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

/// Orchestrates remote login and local session; exposes auth state and token.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required SecureStorageHelper secureStorage,
  })  : _remote = remote,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remote;
  final SecureStorageHelper _secureStorage;

  @override
  Future<void> signIn({
    required Map<String, dynamic> values,
  }) async {
    final username = values['username'] as String? ?? '';
    final password = values['password'] as String? ?? '';
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password are required');
    }

    final response =
        await _remote.login(username: username, password: password);

    final authResponse = response.fold(
      (failure) => throw failure,
      (r) => r,
    );
    await _secureStorage.setAuthResponse(authResponse);
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.clearAuthTokens();
  }
}
