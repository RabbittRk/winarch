import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/cars_home_screen.dart';
import '../screens/car_details_screen.dart';

/// Returns the list of routes for the Cars module.
///
/// These routes can be spread into the host app's GoRouter configuration:
/// ```dart
/// GoRouter(
///   routes: [
///     ...getCarsRoutes(),
///   ],
/// )
/// ```
List<RouteBase> getCarsRoutes() {
  return [
    GoRoute(
      path: '/cars',
      name: 'cars',
      builder: (BuildContext context, GoRouterState state) =>
          const CarsHomeScreen(),
      routes: [
        GoRoute(
          path: 'details/:carId',
          name: 'carDetails',
          builder: (BuildContext context, GoRouterState state) {
            final carId = state.pathParameters['carId']!;
            return CarDetailsScreen(carId: carId);
          },
        ),
      ],
    ),
  ];
}
