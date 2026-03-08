import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Logger that only outputs in debug mode. Use for development-only logs (e.g. HTTP).
/// Uses [developer.log] so output appears in the IDE Debug Console.
class AppLogger {
  AppLogger._();

  static void log(Object? message) {
    // if (kDebugMode) {
    final s = message?.toString() ?? '';
    developer.log(s);
    debugPrint(s);
    // }
  }
}
