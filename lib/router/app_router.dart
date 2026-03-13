import 'package:cars/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/features/auth/presentation/login_screen.dart';
import 'package:winarch/features/home.screen.dart';
import 'package:winarch/router/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorExploreKey =
    GlobalKey<NavigatorState>(debugLabel: 'explore');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

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
          // Home tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeTab(),
              ),
            ],
          ),
          // Explore tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExploreKey,
            routes: [
              GoRoute(
                path: '/explore',
                name: 'explore',
                builder: (context, state) => const ExploreTab(),
              ),
            ],
          ),
          // Profile tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileTab(),
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
