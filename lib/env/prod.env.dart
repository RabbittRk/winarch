import 'package:firebase_core/firebase_core.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/firebase_options.dart';

class ProdEnvironment extends AppEnvironment {
  ProdEnvironment() : super.public();

  @override
  AppEnvType get appEnvType => AppEnvType.prod;

  @override
  String get baseUrl => 'https://dummyjson.com';

  @override
  FirebaseOptions get firebaseOptions => DefaultFirebaseOptions.currentPlatform;
}
