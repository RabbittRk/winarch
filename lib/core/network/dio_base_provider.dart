import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/env/app.env.dart';

final appConfigProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment();
});

/// Base Dio (no auth). Use for login and other unauthenticated calls.
final dioBaseProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  return dio;
});
