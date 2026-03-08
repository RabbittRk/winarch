import 'package:winarch/env/app.env.dart';

class DevEnvironment extends AppEnvironment {
  DevEnvironment() : super.public();

  @override
  AppEnvType get appEnvType => AppEnvType.dev;

  @override
  String get baseUrl => 'https://dummyjson.com';

  // @override
  // FirebaseOptions get firebaseOptions => DevFirebaseOptions.currentPlatform;
}
