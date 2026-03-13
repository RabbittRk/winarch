import 'dart:async';

import 'package:flutter/foundation.dart';

import 'localization_config.dart';
import 'localization_service.dart';

typedef OnTranslationsUpdated = void Function(String locale);

class LocalizationSyncManager {
  final LocalizationService _service;
  final LocalizationConfig config;
  final OnTranslationsUpdated? onTranslationsUpdated;

  Timer? _syncTimer;
  bool _isRunning = false;
  final Set<String> _syncingLocales = {};

  LocalizationSyncManager({
    required LocalizationService service,
    this.config = const LocalizationConfig(),
    this.onTranslationsUpdated,
  }) : _service = service;

  bool get isRunning => _isRunning;

  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    debugPrint('LocalizationSyncManager: Starting background sync');

    await _performInitialSync();

    _syncTimer = Timer.periodic(config.syncInterval, (_) => _performSync());
  }

  void stop() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _isRunning = false;
    debugPrint('LocalizationSyncManager: Stopped background sync');
  }

  Future<void> _performInitialSync() async {
    debugPrint('LocalizationSyncManager: Performing initial sync');
    await _performSync();
  }

  Future<void> _performSync() async {
    if (!_isRunning) return;

    for (final locale in config.supportedLocales) {
      await syncLocale(locale.languageCode);
    }
  }

  Future<SyncResult> syncLocale(String locale) async {
    if (_syncingLocales.contains(locale)) {
      return const SyncResult(
        success: false,
        message: 'Already syncing this locale',
      );
    }

    _syncingLocales.add(locale);

    try {
      debugPrint('LocalizationSyncManager: Syncing $locale');
      final result = await _service.syncTranslations(locale);

      if (result.success && result.updated) {
        debugPrint(
            'LocalizationSyncManager: $locale updated to v${result.newVersion}');
        onTranslationsUpdated?.call(locale);
      }

      return result;
    } finally {
      _syncingLocales.remove(locale);
    }
  }

  Future<void> syncAllLocales() async {
    debugPrint('LocalizationSyncManager: Manual sync requested');
    await _performSync();
  }

  Future<Map<String, SyncResult>> syncAllLocalesWithResults() async {
    final results = <String, SyncResult>{};

    for (final locale in config.supportedLocales) {
      results[locale.languageCode] = await syncLocale(locale.languageCode);
    }

    return results;
  }

  void dispose() {
    stop();
  }
}
