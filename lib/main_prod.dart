import 'package:winarch/env/prod.env.dart';
import 'package:winarch/main.dart' as app;

void main() {
  app.main(environment: ProdEnvironment());
}
