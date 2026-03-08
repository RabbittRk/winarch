import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/di/get_it_provider.dart';
import 'package:winarch/features/auth/data/api/auth_api.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:winarch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';
import 'package:winarch/features/auth/domain/usecases/login_usecase.dart';
import 'package:winarch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

/// Auth API (Retrofit), feature-scoped.
final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.read(getItProvider).get<Dio>();
  return AuthApi(dio);
});

/// Auth remote datasource, feature-scoped.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(api: ref.watch(authApiProvider));
});

/// Auth repository, feature-scoped. Used by router and use cases.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.read(getItProvider).get<SecureStorageHelper>();
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    secureStorage: secureStorage,
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authState;
});

/// Listenable that notifies when auth state changes, for GoRouter refresh.
final authRefreshListenableProvider = Provider<Listenable>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, __) {
    notifier.value++;
  });
  return notifier;
});
