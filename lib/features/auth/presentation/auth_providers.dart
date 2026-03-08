import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/network/dio_base_provider.dart';
import 'package:winarch/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:winarch/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:winarch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';
import 'package:winarch/storage/secure_storage_provider.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioBaseProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(storage: storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remote: remote, local: local);
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
