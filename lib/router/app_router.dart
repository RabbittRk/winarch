import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/features/auth/presentation/login_screen.dart';
import 'package:winarch/features/home.screen.dart';
import 'package:winarch/router/splash_screen.dart';
import 'package:windevtool/windevtool.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(authFromStorageProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      final authAsync =
          ProviderScope.containerOf(context).read(authFromStorageProvider);
      return authAsync.when(
        data: (auth) {
          final loggedIn = auth != null;
          final loc = state.matchedLocation;
          if (loc == '/splash') return loggedIn ? '/' : '/login';
          if (!loggedIn) return loc == '/login' ? null : '/login';
          return loc == '/login' ? '/' : null;
        },
        loading: () => state.matchedLocation == '/splash' ? null : '/splash',
        error: (_, __) => '/login',
      );
    },
    routes: <RouteBase>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Stack(
            children: [
              child,
              const DevApiTrackingBanner(),
            ],
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
            path: '/splash',
            name: 'splash',
            builder: (BuildContext context, GoRouterState state) =>
                const SplashScreen(),
          ),
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (BuildContext context, GoRouterState state) =>
                const LoginPage(),
          ),
          GoRoute(
            path: '/dev/api-tracking',
            name: 'devApiTracking',
            builder: (BuildContext context, GoRouterState state) =>
                const DevApiTrackingScreen(),
          ),
        ],
      ),
    ],
  );
});
