import 'dart:async';

import 'package:winarch/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';

/// Orchestrates remote login and local session; exposes auth state and token.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final _authStateController = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authState async* {
    yield await _local.getCurrentUser();
    yield* _authStateController.stream;
  }

  @override
  Future<void> signIn({
    required Map<String, dynamic> values,
  }) async {
    final username = 'emilys';
    final password = 'emilyspass';

    // final username = values['username'] as String? ?? '';
    // final password = values['password'] as String? ?? '';
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password are required');
    }

    final response =
        await _remote.login(username: username, password: password);

    response.fold(
      (failure) => throw failure,
      (response) async {
        final user = AuthUser(
          id: response.id.toString(),
          email: response.email,
        );
        await _local.saveSession(
          token: response.accessToken,
          refreshToken: response.refreshToken,
          user: user,
        );
        _authStateController.add(user);
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _local.clearSession();
    _authStateController.add(null);
  }

  @override
  Future<String?> getAccessToken() => _local.getAccessToken();

  @override
  Future<String?> getRefreshToken() => _local.getRefreshToken();
}
