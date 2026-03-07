import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/features/home.screen.dart';

final GoRouter appRouter = GoRouter(
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
          const Placeholder(),
    ),
  ],
);
