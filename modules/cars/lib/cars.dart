/// Cars module for the Winarch application.
///
/// This module provides car-related features including:
/// - Car listing and browsing
/// - Car details view
/// - Deep linking support (/cars, /cars/details/:carId)
///
/// ## Usage
///
/// Add the module routes to your GoRouter configuration:
/// ```dart
/// import 'package:cars/cars.dart';
///
/// GoRouter(
///   routes: [
///     // ... other routes
///     ...getCarsRoutes(),
///   ],
/// )
/// ```
///
/// ## Deep Linking
///
/// Supported deep link paths:
/// - `winarch://cars` - Opens the cars home screen
/// - `winarch://cars/details/123` - Opens car details for ID 123
library;

// Routes
export 'src/routes/cars_routes.dart';

// Screens (exported for direct access if needed)
export 'src/screens/cars_home_screen.dart';
export 'src/screens/car_details_screen.dart';

// Theme
export 'src/theme/cars_theme.dart';
