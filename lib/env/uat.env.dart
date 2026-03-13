import 'package:firebase_core/firebase_core.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/uat_firebase_options.dart';

class UatEnvironment extends AppEnvironment {
  UatEnvironment() : super.public();

  @override
  AppEnvType get appEnvType => AppEnvType.uat;

  @override
  String get baseUrl => 'https://uat-api.skndan.com';

  @override
  FirebaseOptions get firebaseOptions => UatFirebaseOptions.currentPlatform;
}
