import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FirestoreAssetLoader extends AssetLoader {
  final String fallbackPath;
  final String firestoreCollection;
  final List<String> modules;
  final FirebaseFirestore _firestore;

  // In-memory cache for Firebase translations
  static final Map<String, Map<String, dynamic>> _firebaseCache = {};

  FirestoreAssetLoader({
    this.fallbackPath = 'assets/translations',
    this.firestoreCollection = 'translations',
    this.modules = const ['main', 'cars'],
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Pre-fetch all translations from Firebase (call before EasyLocalization starts)
  Future<void> preFetchTranslations(List<Locale> locales) async {
    debugPrint(
        'FirestoreAssetLoader: Pre-fetching translations for ${locales.map((l) => l.languageCode).toList()}');

    await Future.wait(
      locales.map(
          (locale) => _fetchAndCacheFirebaseTranslations(locale.languageCode)),
    );

    debugPrint(
        'FirestoreAssetLoader: Pre-fetch complete. Cache: ${_firebaseCache.keys.toList()}');
  }

  Future<void> _fetchAndCacheFirebaseTranslations(String locale) async {
    try {
      debugPrint(
          'FirestoreAssetLoader: Fetching from Firestore: $firestoreCollection/$locale');

      final doc =
          await _firestore.collection(firestoreCollection).doc(locale).get();

      if (!doc.exists) {
        debugPrint('FirestoreAssetLoader: No document found for $locale');
        return;
      }

      final data = doc.data();
      if (data == null) {
        debugPrint('FirestoreAssetLoader: Document data is null for $locale');
        return;
      }

      debugPrint(
          'FirestoreAssetLoader: Document found for $locale with keys: ${data.keys.toList()}');

      // Merge all module translations into one map
      final translations = <String, dynamic>{};
      for (final module in modules) {
        if (data.containsKey(module)) {
          final moduleData = data[module];
          if (moduleData is Map<String, dynamic>) {
            debugPrint(
                'FirestoreAssetLoader: Adding module "$module" with keys: ${moduleData.keys.toList()}');
            _deepMerge(translations, moduleData);
          }
        }
      }

      _firebaseCache[locale] = translations;
      debugPrint(
          'FirestoreAssetLoader: Cached Firebase translations for $locale: ${translations.keys.toList()}');
    } catch (e, stack) {
      debugPrint('FirestoreAssetLoader: Error fetching $locale: $e');
      debugPrint('$stack');
    }
  }

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localeCode = locale.languageCode;
    debugPrint('FirestoreAssetLoader: load() called for $localeCode');

    // Step 1: Load local translations as base/fallback
    final localTranslations = await _loadLocalTranslations(locale);
    debugPrint(
        'FirestoreAssetLoader: Local translations keys: ${localTranslations.keys.toList()}');

    // Step 2: Get Firebase translations from cache
    final firebaseTranslations = _firebaseCache[localeCode] ?? {};
    debugPrint(
        'FirestoreAssetLoader: Firebase cache keys for $localeCode: ${firebaseTranslations.keys.toList()}');

    if (firebaseTranslations.isNotEmpty) {
      // Firebase overrides local
      final merged = _deepMergeReturn(localTranslations, firebaseTranslations);
      debugPrint(
          'FirestoreAssetLoader: Merged translations keys: ${merged.keys.toList()}');
      return merged;
    }

    debugPrint(
        'FirestoreAssetLoader: Using local fallback only for $localeCode');
    return localTranslations;
  }

  Future<Map<String, dynamic>> _loadLocalTranslations(Locale locale) async {
    try {
      final jsonString = await rootBundle.loadString(
        '$fallbackPath/${locale.languageCode}.json',
      );
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('FirestoreAssetLoader: Error loading local translations: $e');
      return {};
    }
  }

  void _deepMerge(Map<String, dynamic> target, Map<String, dynamic> source) {
    for (final key in source.keys) {
      if (source[key] is Map<String, dynamic> &&
          target[key] is Map<String, dynamic>) {
        _deepMerge(
          target[key] as Map<String, dynamic>,
          source[key] as Map<String, dynamic>,
        );
      } else {
        target[key] = source[key];
      }
    }
  }

  Map<String, dynamic> _deepMergeReturn(
    Map<String, dynamic> base,
    Map<String, dynamic> overlay,
  ) {
    final result = Map<String, dynamic>.from(base);
    _deepMerge(result, overlay);
    return result;
  }
}
