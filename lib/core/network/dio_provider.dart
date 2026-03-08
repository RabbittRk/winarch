import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/network/auth_interceptor.dart';
import 'package:winarch/core/network/dio_base_provider.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';

/// Authenticated Dio with bearer token interceptor. Use for all authenticated API calls.
final dioAuthProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  Future<String?> getToken() =>
      ref.read(authRepositoryProvider).getAccessToken();
  Future<void> onUnauthorized() => ref.read(authRepositoryProvider).signOut();

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(getToken: getToken, onUnauthorized: onUnauthorized),
  );
  return dio;
});
