import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/features/auth/data/auth_repository_impl.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
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
