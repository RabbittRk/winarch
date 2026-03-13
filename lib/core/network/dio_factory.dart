import 'package:dio/dio.dart';
import 'package:winarch/core/connectivity/connectivity_service.dart';
import 'package:winarch/core/logger/app_logger.dart';
import 'package:winarch/core/network/auth_interceptor.dart';
import 'package:winarch/core/network/connectivity_interceptor.dart';
import 'package:winarch/storage/secure_storage_helper.dart';
// import 'package:windevtool/windevtool.dart';

/// Creates a configured [Dio] instance with connectivity, auth, and logging interceptors.
Dio createDio({
  required String baseUrl,
  required SecureStorageHelper secureStorage,
  required ConnectivityService connectivity,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.addAll(
    [
      ConnectivityInterceptor(connectivity: connectivity),
      AuthInterceptor(
        getToken: secureStorage.getToken,
        getRefreshToken: secureStorage.getRefreshToken,
        saveTokens: secureStorage.saveTokens,
        refreshBaseUrl: baseUrl,
        refreshPath: '/auth/refresh',
        onUnauthorized: secureStorage.deleteToken,
      ),
    ],
  );

  // Dev-only API schema tracking to Firestore (from windevtool package)
  // if (WinDevTool.isInitialized && WinDevTool.config.isEnabled) {
  //   dio.interceptors.add(ApiTrackingInterceptor());
  // }

  dio.interceptors.add(
    LogInterceptor(
      logPrint: (Object o) => AppLogger.log(o),
      responseBody: true,
      requestBody: true,
    ),
  );
  return dio;
}
