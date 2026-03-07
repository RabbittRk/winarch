import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/features/auth/presentation/login_screen.dart';
import 'package:winarch/features/home.screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(authRefreshListenableProvider);
  return GoRouter(
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) {
      final auth = ProviderScope.containerOf(context).read(authStateProvider);
      return auth.when(
        data: (user) {
          final isLoggedIn = user != null;
          final isLoginRoute = state.matchedLocation == '/login';
          if (!isLoggedIn && !isLoginRoute) return '/login';
          if (isLoggedIn && isLoginRoute) return '/';
          return null;
        },
        loading: () => state.matchedLocation == '/login' ? null : '/login',
        error: (_, __) => state.matchedLocation == '/login' ? null : '/login',
      );
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
    ],
  );
});
