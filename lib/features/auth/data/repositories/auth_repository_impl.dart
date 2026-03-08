import 'dart:async';

import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';
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
  final _authStateController = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authState async* {
    yield* _authStateController.stream;
  }

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

    response.fold(
      (failure) => throw failure,
      (authResponse) async {
        await _secureStorage.saveTokens(
          authResponse.accessToken,
          authResponse.refreshToken,
        );
        final user = AuthUser(
          id: authResponse.id.toString(),
          email: authResponse.email,
        );
        _authStateController.add(user);
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.clearAuthTokens();
    _authStateController.add(null);
  }
}
