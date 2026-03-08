import 'package:winarch/features/auth/domain/auth_repository.dart';

/// Single-responsibility use case: sign out and clear session.
class SignOutUseCase {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> execute() => _repository.signOut();
}
