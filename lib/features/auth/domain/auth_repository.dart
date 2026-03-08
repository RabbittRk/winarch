/// Contract for authentication: sign in, sign out, and stream of auth state.
abstract class AuthRepository {
  /// Signs in with [email] and [password]. For bare minimum, validates locally
  /// and persists session; no backend call.
  Future<void> signIn({
    required Map<String, dynamic> values,
  });

  /// Clears the current session.
  Future<void> signOut();
}
