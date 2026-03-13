import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization_config.dart';

class LocalizationService {
  final FirebaseFirestore _firestore;
  final LocalizationConfig config;

  static const String _versionKeyPrefix = 'localization_version_';
  static const String _lastSyncKeyPrefix = 'localization_last_sync_';

  LocalizationService({
    FirebaseFirestore? firestore,
    this.config = const LocalizationConfig(),
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchTranslationsFromFirestore(
    String locale,
  ) async {
    try {
      final doc = await _firestore
          .collection(config.firestoreCollection)
          .doc(locale)
          .get();

      if (!doc.exists) {
        debugPrint('LocalizationService: No translations found for $locale');
        return null;
      }

      final data = doc.data();
      if (data == null) return null;

      final translations = <String, dynamic>{};

      for (final module in config.modules) {
        if (data.containsKey(module)) {
          final moduleData = data[module];
          if (moduleData is Map<String, dynamic>) {
            translations.addAll(moduleData);
          }
        }
      }

      return {
        'version': data['version'] ?? 1,
        'updatedAt': data['updatedAt'],
        'translations': translations,
      };
    } catch (e) {
      debugPrint('LocalizationService: Error fetching translations: $e');
      return null;
    }
  }

  Future<int> getCachedVersion(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_versionKeyPrefix$locale') ?? 0;
  }

  Future<void> setCachedVersion(String locale, int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_versionKeyPrefix$locale', version);
  }

  Future<DateTime?> getLastSyncTime(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('$_lastSyncKeyPrefix$locale');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> setLastSyncTime(String locale, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '$_lastSyncKeyPrefix$locale',
      time.millisecondsSinceEpoch,
    );
  }

  Future<String> get _cacheDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${dir.path}/translations_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir.path;
  }

  Future<File> _getCacheFile(String locale) async {
    final dir = await _cacheDirectory;
    return File('$dir/$locale.json');
  }

  Future<Map<String, dynamic>?> loadCachedTranslations(String locale) async {
    try {
      final file = await _getCacheFile(locale);
      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return json.decode(contents) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('LocalizationService: Error loading cached translations: $e');
      return null;
    }
  }

  Future<void> cacheTranslations(
    String locale,
    Map<String, dynamic> translations,
  ) async {
    try {
      final file = await _getCacheFile(locale);
      await file.writeAsString(json.encode(translations));
    } catch (e) {
      debugPrint('LocalizationService: Error caching translations: $e');
    }
  }

  Future<bool> shouldSync(String locale) async {
    final lastSync = await getLastSyncTime(locale);
    if (lastSync == null) return true;

    final now = DateTime.now();
    return now.difference(lastSync) > config.syncInterval;
  }

  Future<SyncResult> syncTranslations(String locale) async {
    try {
      final cachedVersion = await getCachedVersion(locale);
      final firestoreData = await fetchTranslationsFromFirestore(locale);

      if (firestoreData == null) {
        return SyncResult(
          success: false,
          message: 'No translations found in Firestore',
        );
      }

      final remoteVersion = firestoreData['version'] as int? ?? 1;

      if (remoteVersion > cachedVersion) {
        final translations =
            firestoreData['translations'] as Map<String, dynamic>;
        await cacheTranslations(locale, translations);
        await setCachedVersion(locale, remoteVersion);
        await setLastSyncTime(locale, DateTime.now());

        return SyncResult(
          success: true,
          updated: true,
          message: 'Updated from version $cachedVersion to $remoteVersion',
          newVersion: remoteVersion,
        );
      }

      await setLastSyncTime(locale, DateTime.now());
      return SyncResult(
        success: true,
        updated: false,
        message: 'Already up to date (version $cachedVersion)',
      );
    } catch (e) {
      debugPrint('LocalizationService: Sync error: $e');
      return SyncResult(
        success: false,
        message: 'Sync failed: $e',
      );
    }
  }

  Future<Map<String, dynamic>> getTranslations(String locale) async {
    final cached = await loadCachedTranslations(locale);
    if (cached != null) {
      return cached;
    }
    return {};
  }
}

class SyncResult {
  final bool success;
  final bool updated;
  final String message;
  final int? newVersion;

  const SyncResult({
    required this.success,
    this.updated = false,
    required this.message,
    this.newVersion,
  });

  @override
  String toString() =>
      'SyncResult(success: $success, updated: $updated, message: $message)';
}
