import 'package:firebase_core/firebase_core.dart';
import 'package:winarch/dev_firebase_options.dart';
import 'package:winarch/env/app.env.dart';

class DevEnvironment extends AppEnvironment {
  DevEnvironment() : super.public();

  @override
  AppEnvType get appEnvType => AppEnvType.dev;

  @override
  String get baseUrl => 'https://skndan.free.beeceptor.com';

  @override
  FirebaseOptions get firebaseOptions => DevFirebaseOptions.currentPlatform;
}
