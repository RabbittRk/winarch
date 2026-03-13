import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:winarch/core/localization/localization_providers.dart';

class LocalizationInitializer {
  static Future<void> ensureInitialized() async {
    await EasyLocalization.ensureInitialized();
  }

  static Future<void> startBackgroundSync(WidgetRef ref) async {
    final syncManager = ref.read(localizationSyncManagerProvider);
    await syncManager.start();
  }

  static Future<void> manualSync(WidgetRef ref) async {
    final syncManager = ref.read(localizationSyncManagerProvider);
    final syncStatus = ref.read(syncStatusProvider.notifier);

    syncStatus.startSync();

    try {
      await syncManager.syncAllLocales();
      syncStatus.completeSync('all');
    } catch (e) {
      syncStatus.failSync(e.toString());
    }
  }
}

class LocalizationWrapper extends ConsumerStatefulWidget {
  const LocalizationWrapper({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  ConsumerState<LocalizationWrapper> createState() =>
      _LocalizationWrapperState();
}

class _LocalizationWrapperState extends ConsumerState<LocalizationWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeSync();
  }

  Future<void> _initializeSync() async {
    await LocalizationInitializer.startBackgroundSync(ref);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
