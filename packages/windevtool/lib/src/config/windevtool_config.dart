import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Logger function type for devtool logging
typedef DevToolLogger = void Function(Object message);

/// Configuration interface that must be implemented by the host app
/// to inject environment and Firebase dependencies.
abstract class WinDevToolConfig {
  /// The current environment type as string ('dev', 'uat', 'prod')
  String get envType;

  /// Whether the devtool should be enabled (typically kDebugMode && envType == 'dev')
  bool get isEnabled;

  /// Firebase Firestore instance to use for storing API snapshots
  FirebaseFirestore get firestore;

  /// Route path for the API tracking screen
  String get apiTrackingRoute;

  /// Logger function for devtool logging
  void log(Object message);
}

/// Default configuration that accepts environment and Firebase options from the host app.
///
/// Usage:
/// ```dart
/// WinDevTool.initialize(DefaultWinDevToolConfig(
///   envType: 'dev', // 'dev', 'uat', or 'prod'
///   firebaseOptions: DefaultFirebaseOptions.currentPlatform,
/// ));
/// ```
class DefaultWinDevToolConfig implements WinDevToolConfig {
  DefaultWinDevToolConfig({
    required this.envType,
    this.firebaseOptions,
    FirebaseFirestore? firestore,
    this.apiTrackingRoute = '/dev/api-tracking',
    DevToolLogger? logger,
  })  : _firestore = firestore,
        _logger = logger;

  @override
  final String envType;

  /// Firebase options from the host app (same as used in Firebase.initializeApp)
  final FirebaseOptions? firebaseOptions;

  final FirebaseFirestore? _firestore;

  @override
  final String apiTrackingRoute;

  final DevToolLogger? _logger;

  @override
  bool get isEnabled => kDebugMode && envType == 'dev';

  @override
  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  @override
  void log(Object message) {
    if (_logger != null) {
      _logger(message);
    } else {
      debugPrint('[WinDevTool] $message');
    }
  }
}

/// Singleton holder for the devtool configuration.
/// Must be initialized before using any devtool features.
class WinDevTool {
  WinDevTool._();

  static WinDevToolConfig? _config;

  /// Initialize the devtool with the provided configuration.
  /// Should be called after Firebase.initializeApp() and before runApp().
  ///
  /// Example:
  /// ```dart
  /// await Firebase.initializeApp(options: firebaseOptions);
  /// WinDevTool.initialize(DefaultWinDevToolConfig(
  ///   envType: 'dev',
  ///   firebaseOptions: firebaseOptions,
  /// ));
  /// ```
  static void initialize(WinDevToolConfig config) {
    if (_config != null) {
      throw StateError('WinDevTool is already initialized');
    }
    _config = config;
  }

  /// Get the current configuration.
  /// Throws if not initialized.
  static WinDevToolConfig get config {
    if (_config == null) {
      throw StateError(
        'WinDevTool not initialized. Call WinDevTool.initialize() first.',
      );
    }
    return _config!;
  }

  /// Check if the devtool has been initialized.
  static bool get isInitialized => _config != null;

  /// Reset the configuration (useful for testing).
  static void reset() {
    _config = null;
  }
}
