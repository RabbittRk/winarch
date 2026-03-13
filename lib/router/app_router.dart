import 'package:cars/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/features/auth/presentation/login_screen.dart';
import 'package:winarch/features/home.screen.dart';
import 'package:winarch/router/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorFormKey = GlobalKey<NavigatorState>(debugLabel: 'form');
final _shellNavigatorComponentsKey =
    GlobalKey<NavigatorState>(debugLabel: 'components');
final _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'settings');
final _shellNavigatorModulesKey =
    GlobalKey<NavigatorState>(debugLabel: 'modules');

final goRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(authFromStorageProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
      // Shell route with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Form tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFormKey,
            routes: [
              GoRoute(
                path: '/',
                name: 'form',
                builder: (context, state) => const FormTab(),
              ),
            ],
          ),
          // Components tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorComponentsKey,
            routes: [
              GoRoute(
                path: '/components',
                name: 'components',
                builder: (context, state) => const ComponentsTab(),
              ),
            ],
          ),
          // Settings tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsTab(),
              ),
            ],
          ),
          // Modules tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorModulesKey,
            routes: [
              GoRoute(
                path: '/modules',
                name: 'modules',
                builder: (context, state) => const ModulesTab(),
              ),
            ],
          ),
        ],
      ),

      // Auth routes (outside shell)
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

      // Module routes (outside shell - full screen)
      ...getCarsRoutes(),
    ],
  );
});
