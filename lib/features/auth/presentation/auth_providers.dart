import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/di/get_it_provider.dart';
import 'package:winarch/features/auth/domain/auth_repository.dart';
import 'package:winarch/features/auth/domain/auth_user.dart';

/// Auth repository from GetIt, for presentation (e.g. router redirect).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ref.read(getItProvider).get<AuthRepository>();
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
