import 'dart:convert';

import 'package:dio/dio.dart';

/// Parses a JWT payload and returns the `exp` claim (seconds since epoch), or null if missing/invalid.
int? _jwtExpirationSeconds(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final String payload = parts[1];
    final padded = payload.length % 4 == 0
        ? payload
        : payload + ('=' * (4 - payload.length % 4));
    final decoded = utf8.decode(base64Url.decode(padded));
    final map = jsonDecode(decoded) as Map<String, dynamic>;
    final exp = map['exp'];
    if (exp == null) return null;
    return exp is int ? exp : (exp as num).toInt();
  } catch (_) {
    return null;
  }
}

/// Returns true if the JWT is expired (or within [bufferSeconds] of expiry).
bool _isJwtExpired(String token, {int bufferSeconds = 30}) {
  final exp = _jwtExpirationSeconds(token);
  if (exp == null) return true;
  final nowSeconds = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  return (exp - bufferSeconds) <= nowSeconds;
}

/// Interceptor that adds `Authorization: Bearer <token>` to requests.
/// If the access token is a JWT and expired, uses [refreshToken] with a standalone Dio
/// to get new tokens, saves them via [saveTokens], then continues with the new token.
/// On 401 or refresh failure, calls [onUnauthorized].
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.getToken,
    required this.getRefreshToken,
    required this.saveTokens,
    required this.refreshBaseUrl,
    required this.refreshPath,
    void Function()? onUnauthorized,
  }) : _onUnauthorized = onUnauthorized;

  final Future<String?> Function() getToken;
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(String accessToken, String? refreshToken)
      saveTokens;
  final String refreshBaseUrl;
  final String refreshPath;
  final void Function()? _onUnauthorized;

  /// Standalone Dio used only for refresh (no auth/logging interceptors).
  Dio get _refreshDio => _refreshDioImpl ??= Dio(
        BaseOptions(
          baseUrl: refreshBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
  Dio? _refreshDioImpl;

  /// Ensures only one refresh runs at a time; others wait for the same result.
  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await getToken();

    if (token == null || token.isEmpty) {
      handler.next(options);
      return;
    }

    if (!_isJwtExpired(token)) {
      options.headers['Authorization'] = 'Bearer $token';
      handler.next(options);
      return;
    }

    // Token expired: refresh
    final newToken = await _refreshToken();
    if (newToken == null || newToken.isEmpty) {
      _onUnauthorized?.call();
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Token expired and refresh failed or no refresh token',
        ),
      );
      return;
    }

    options.headers['Authorization'] = 'Bearer $newToken';
    handler.next(options);
  }

  Future<String?> _refreshToken() async {
    if (_refreshFuture != null) return _refreshFuture;

    _refreshFuture = _doRefresh();
    try {
      return await _refreshFuture!;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        refreshPath,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data;
      if (data == null) return null;

      final accessToken = data['accessToken'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) return null;

      await saveTokens(accessToken, newRefreshToken);
      return accessToken;
    } on DioException catch (_) {
      return null;
    }
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (err.response?.statusCode == 401) {
      _onUnauthorized?.call();
    }
    handler.next(err);
  }
}
