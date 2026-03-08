import 'package:winarch/env/app.env.dart';

class ProdEnvironment extends AppEnvironment {
  ProdEnvironment() : super.public();

  @override
  AppEnvType get appEnvType => AppEnvType.prod;

  @override
  String get baseUrl => '';

  // @override
  // FirebaseOptions get firebaseOptions => DevFirebaseOptions.currentPlatform;
}
