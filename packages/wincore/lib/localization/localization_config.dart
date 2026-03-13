import 'dart:ui';

class LocalizationConfig {
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;
  final String translationsPath;
  final String firestoreCollection;
  final Duration syncInterval;
  final List<String> modules;

  const LocalizationConfig({
    this.supportedLocales = const [Locale('en'), Locale('ta')],
    this.fallbackLocale = const Locale('en'),
    this.translationsPath = 'assets/translations',
    this.firestoreCollection = 'translations',
    this.syncInterval = const Duration(minutes: 15),
    this.modules = const ['main'],
  });

  LocalizationConfig copyWith({
    List<Locale>? supportedLocales,
    Locale? fallbackLocale,
    String? translationsPath,
    String? firestoreCollection,
    Duration? syncInterval,
    List<String>? modules,
  }) {
    return LocalizationConfig(
      supportedLocales: supportedLocales ?? this.supportedLocales,
      fallbackLocale: fallbackLocale ?? this.fallbackLocale,
      translationsPath: translationsPath ?? this.translationsPath,
      firestoreCollection: firestoreCollection ?? this.firestoreCollection,
      syncInterval: syncInterval ?? this.syncInterval,
      modules: modules ?? this.modules,
    );
  }
}
