import 'package:winarch/features/auth/domain/auth_repository.dart';

/// Single-responsibility use case: sign in with credentials.
/// Throws on failure (e.g. network error, invalid credentials).
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> execute(Map<String, dynamic> values) =>
      _repository.signIn(values: values);
}
