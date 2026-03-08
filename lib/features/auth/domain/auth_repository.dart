import 'package:winarch/features/auth/domain/auth_user.dart';

/// Contract for authentication: sign in, sign out, and stream of auth state.
abstract class AuthRepository {
  /// Stream that emits the current user when signed in, or null when signed out.
  Stream<AuthUser?> get authState;

  /// Signs in with [email] and [password]. For bare minimum, validates locally
  /// and persists session; no backend call.
  Future<void> signIn({
    required Map<String, dynamic> values,
  });

  /// Clears the current session.
  Future<void> signOut();
}
