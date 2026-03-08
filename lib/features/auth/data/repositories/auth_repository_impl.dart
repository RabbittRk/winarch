import 'dart:async';

import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';

/// Orchestrates remote login and local session; exposes auth state and token.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
  }) : _remote = remote;

  final AuthRemoteDataSource _remote;
  final _authStateController = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authState async* {
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
        _authStateController.add(user);
      },
    );
  }

  @override
  Future<void> signOut() async {
    _authStateController.add(null);
  }
}
