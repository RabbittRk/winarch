import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wincore/wincore.dart';

final localizationConfigProvider = Provider<LocalizationConfig>((ref) {
  return const LocalizationConfig(
    modules: ['main', 'cars'],
  );
});

final localizationServiceProvider = Provider<LocalizationService>((ref) {
  final config = ref.watch(localizationConfigProvider);
  return LocalizationService(
    firestore: FirebaseFirestore.instance,
    config: config,
  );
});

final localizationSyncManagerProvider =
    Provider<LocalizationSyncManager>((ref) {
  final service = ref.watch(localizationServiceProvider);
  final config = ref.watch(localizationConfigProvider);

  final manager = LocalizationSyncManager(
    service: service,
    config: config,
    onTranslationsUpdated: (locale) {
      debugPrint('Translations updated for $locale');
    },
  );

  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});

final firestoreAssetLoaderProvider = Provider<FirestoreAssetLoader>((ref) {
  return FirestoreAssetLoader();
});

final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, SyncStatus>((ref) {
  return SyncStatusNotifier();
});

class SyncStatus {
  const SyncStatus({
    this.isSyncing = false,
    this.lastSyncedLocale,
    this.lastSyncTime,
    this.errorMessage,
  });
  final bool isSyncing;
  final String? lastSyncedLocale;
  final DateTime? lastSyncTime;
  final String? errorMessage;

  SyncStatus copyWith({
    bool? isSyncing,
    String? lastSyncedLocale,
    DateTime? lastSyncTime,
    String? errorMessage,
  }) {
    return SyncStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedLocale: lastSyncedLocale ?? this.lastSyncedLocale,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage,
    );
  }
}

class SyncStatusNotifier extends StateNotifier<SyncStatus> {
  SyncStatusNotifier() : super(const SyncStatus());

  void startSync() {
    state = state.copyWith(isSyncing: true);
  }

  void completeSync(String locale) {
    state = state.copyWith(
      isSyncing: false,
      lastSyncedLocale: locale,
      lastSyncTime: DateTime.now(),
    );
  }

  void failSync(String error) {
    state = state.copyWith(
      isSyncing: false,
      errorMessage: error,
    );
  }
}
