import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:winarch/core/connectivity/connectivity_service.dart';
import 'package:winarch/core/connectivity/connectivity_service_impl.dart';
import 'package:winarch/core/network/dio_factory.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/storage/secure_storage_helper.dart';

final getIt = GetIt.instance;

/// Registers core/infra only. Feature dependencies (e.g. auth) are built in Riverpod.
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
}
