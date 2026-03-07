import 'dart:async';
import 'dart:convert';

import 'package:winarch/storage/secure_storage_helper.dart';

import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

const _keyAuthUser = 'auth_user';

/// Persists auth session in secure storage and exposes auth state as a stream.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required SecureStorageHelper storage})
      : _storage = storage;

  final SecureStorageHelper _storage;
  final _authStateController = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authState async* {
    yield await _readUser();
    yield* _authStateController.stream;
  }

  Future<AuthUser?> _readUser() async {
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
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final e = email.trim();
    final p = password;
    if (e.isEmpty || p.isEmpty) {
      throw ArgumentError('Email and password are required');
    }
    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: e,
    );
    await _storage.write(
      _keyAuthUser,
      jsonEncode({'id': user.id, 'email': user.email}),
    );
    _authStateController.add(user);
  }

  @override
  Future<void> signOut() async {
    await _storage.delete(_keyAuthUser);
    _authStateController.add(null);
  }
}
