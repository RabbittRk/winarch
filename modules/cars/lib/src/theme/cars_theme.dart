import 'package:flutter/material.dart';

/// Optional theme extensions for the Cars module.
///
/// This class provides module-specific theme customizations that can be used
/// to override the parent app's theme when needed.
///
/// Usage:
/// ```dart
/// Theme(
///   data: CarsTheme.applyOverrides(context.theme),
///   child: const CarsHomeScreen(),
/// )
/// ```
class CarsTheme {
  CarsTheme._();

  /// Apply Cars module-specific theme overrides.
  ///
  /// By default, this returns the parent theme unchanged.
  /// Override specific properties as needed for this module.
  static ThemeData applyOverrides(ThemeData parentTheme) {
    return parentTheme.copyWith(
        // Example: Override card theme for this module
        // cardTheme: parentTheme.cardTheme.copyWith(
        //   elevation: 2,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
        );
  }

  /// Apply a custom color scheme for the Cars module.
  ///
  /// Use this when the module needs a distinct color identity while
  /// maintaining the overall theme structure.
  static ThemeData withCustomColors(
    ThemeData parentTheme, {
    Color? primary,
    Color? secondary,
  }) {
    return parentTheme.copyWith(
      colorScheme: parentTheme.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
      ),
    );
  }
}
