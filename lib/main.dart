import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/di/injection.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/env/dev.env.dart';
import 'package:winarch/router/app_router.dart';
import 'package:winarch/theme/theme.dart';
// import 'package:windevtool/windevtool.dart';

Future<void> main({AppEnvironment? environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  environment ??= DevEnvironment();

  await Firebase.initializeApp(
    options: environment.firebaseOptions,
  );

  // Initialize devtool with env and firebase from the app
  // WinDevTool.initialize(
  //   DefaultWinDevToolConfig(
  //     envType: environment.appEnvType == AppEnvType.dev
  //         ? 'dev'
  //         : environment.appEnvType == AppEnvType.uat
  //             ? 'uat'
  //             : 'prod',
  //     firebaseOptions: environment.firebaseOptions,
  //   ),
  // );

  configureDependencies(getIt, environment);

  runZonedGuarded(() {
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'Winarch',
      theme: themeState.theme,
      darkTheme: themeState.darkTheme,
      themeMode: themeState.themeMode,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
