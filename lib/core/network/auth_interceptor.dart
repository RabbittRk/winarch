import 'package:dio/dio.dart';

/// Interceptor that adds `Authorization: Bearer <token>` to requests.
/// Optionally handles 401 by calling [onUnauthorized].
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.getToken,
    void Function()? onUnauthorized,
  }) : _onUnauthorized = onUnauthorized;

  final Future<String?> Function() getToken;
  final void Function()? _onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
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
