import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:winarch/core/connectivity/connectivity_service.dart';
import 'package:winarch/core/connectivity/connectivity_service_impl.dart';
import 'package:winarch/core/network/dio_factory.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/features/auth/data/api/auth_api.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:winarch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/usecases/login_usecase.dart';
import 'package:winarch/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

final getIt = GetIt.instance;

/// Registers all core and feature dependencies. Call once from [main] before [runApp].
void configureDependencies(GetIt sl, AppEnvironment env) {
  sl.registerSingleton<AppEnvironment>(env);
  sl.registerSingleton<SecureStorageHelper>(SecureStorageHelper());
  sl.registerSingleton<ConnectivityService>(ConnectivityServiceImpl());
  sl.registerSingleton<Dio>(
    createDio(
      baseUrl: sl<AppEnvironment>().baseUrl,
      secureStorage: sl<SecureStorageHelper>(),
      connectivity: sl<ConnectivityService>(),
    ),
  );

  // Auth
  sl.registerSingleton<AuthApi>(AuthApi(sl<Dio>()));
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(api: sl<AuthApi>()),
  );
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remote: sl<AuthRemoteDataSource>(),
      secureStorage: sl<SecureStorageHelper>(),
    ),
  );
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl<AuthRepository>()));
}
