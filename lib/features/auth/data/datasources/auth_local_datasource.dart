import 'package:winarch/features/auth/domain/auth_user.dart';

/// Contract for persisting auth session (token + user) locally.
abstract class AuthLocalDataSource {
  Future<void> saveSession({
    required String token,
    required String refreshToken,
    required AuthUser user,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<AuthUser?> getCurrentUser();

  Future<void> clearSession();
}
