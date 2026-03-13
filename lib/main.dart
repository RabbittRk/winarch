import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/di/injection.dart';
import 'package:winarch/core/localization/localization_initializer.dart';
import 'package:winarch/env/app.env.dart';
import 'package:winarch/env/dev.env.dart';
import 'package:winarch/router/app_router.dart';
import 'package:winarch/theme/theme.dart';
import 'package:wincore/wincore.dart';
// import 'package:windevtool/windevtool.dart';

Future<void> main({AppEnvironment? environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  environment ??= DevEnvironment();

  await Firebase.initializeApp(
    options: environment.firebaseOptions,
  );

  await LocalizationInitializer.ensureInitialized();

  // Create the asset loader that fetches from Firebase
  final assetLoader = FirestoreAssetLoader(
    modules: ['main', 'cars'],
  );

  // Pre-fetch Firebase translations BEFORE EasyLocalization starts
  // This ensures no delay when app loads
  await assetLoader.preFetchTranslations([
    const Locale('en'),
    const Locale('ta'),
  ]);

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
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ta')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: assetLoader,
        child: const ProviderScope(child: MyApp()),
      ),
    );
  }, (error, stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeBackgroundSync();
  }

  Future<void> _initializeBackgroundSync() async {
    await LocalizationInitializer.startBackgroundSync(ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'Winarch',
      theme: themeState.theme,
      darkTheme: themeState.darkTheme,
      themeMode: themeState.themeMode,
      routerConfig: ref.watch(goRouterProvider),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
