import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/di/get_it_provider.dart';
import 'package:winarch/features/auth/data/api/auth_api.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:winarch/features/auth/data/models/auth_response.dart';
import 'package:winarch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/usecases/login_usecase.dart';
import 'package:winarch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:winarch/storage/secure_storage_provider.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

/// Auth API (Retrofit), feature-scoped.
final authApiProvider = Provider.autoDispose<AuthApi>((ref) {
  final dio = ref.read(getItProvider).get<Dio>();
  return AuthApi(dio);
});

/// Auth remote datasource, feature-scoped.
final authRemoteDataSourceProvider =
    Provider.autoDispose<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(api: ref.watch(authApiProvider));
});

/// Auth repository, feature-scoped. Used by router and use cases.
final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final secureStorage = ref.read(getItProvider).get<SecureStorageHelper>();
  return AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    secureStorage: secureStorage,
  );
});

final loginUseCaseProvider = Provider.autoDispose<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider.autoDispose<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

/// Auth from secure storage (no stream). Read once; invalidate after login/signOut to refresh.
final authFromStorageProvider =
    FutureProvider.autoDispose<AuthResponse?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  return storage.getAuthResponse();
});
