import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/logger/app_logger.dart';
import 'package:winarch/core/network/auth_interceptor.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/storage/secure_storage_provider.dart';

final appConfigProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment();
});

/// Single Dio instance for the app. Overridden in main to add [AuthInterceptor].
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  Future<String?> getToken() => secureStorage.getToken();
  Future<String?> getRefreshToken() => secureStorage.getRefreshToken();
  Future<void> onUnauthorized() => secureStorage.deleteToken();
  Future<void> saveTokens(String accessToken, String? refreshToken) =>
      secureStorage.saveTokens(accessToken, refreshToken);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(
      getToken: getToken,
      getRefreshToken: getRefreshToken,
      saveTokens: saveTokens,
      refreshBaseUrl: config.baseUrl,
      refreshPath: '/auth/refresh',
      onUnauthorized: onUnauthorized,
    ),
    LogInterceptor(
      logPrint: (Object o) => AppLogger.log(o),
      responseBody: true,
      requestBody: true,
    ),
  ]);
  return dio;
});
