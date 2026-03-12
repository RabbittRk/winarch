import 'package:firebase_core/firebase_core.dart';

enum AppEnvType {
  dev,
  uat,
  prod,
}

abstract class AppEnvironment {
  factory AppEnvironment() {
    if (_instance == null) {
      throw 'Environment not initialized';
    }

    return _instance!;
  }

  AppEnvironment.public() {
    if (_instance != null) {
      throw 'Environment already set';
    }

    _instance = this;
  }

  static AppEnvironment? _instance;

  AppEnvType get appEnvType;

  String get baseUrl => _baseUrl ?? '';

  String? _baseUrl;

  set baseUrl(value) => _baseUrl = value;

  FirebaseOptions get firebaseOptions;
}
