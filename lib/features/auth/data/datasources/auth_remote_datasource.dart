import 'package:dartz/dartz.dart';
import 'package:winarch/features/auth/data/models/auth_response.dart';

/// Contract for remote auth API (e.g. login).
abstract class AuthRemoteDataSource {
  /// Signs in with [email] and [password]; returns token and user from API.
  Future<Either<String, AuthResponse>> login({
    required String username,
    required String password,
  });
}
