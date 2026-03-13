import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/localization/firebase/translation_seeder.dart';
import 'package:winarch/core/localization/localization_providers.dart';
import 'package:wincore/wincore.dart';

class LocalizationAdminWidget extends ConsumerStatefulWidget {
  const LocalizationAdminWidget({super.key});

  @override
  ConsumerState<LocalizationAdminWidget> createState() =>
      _LocalizationAdminWidgetState();
}

class _LocalizationAdminWidgetState
    extends ConsumerState<LocalizationAdminWidget> {
  bool _isSeeding = false;
  bool _isSyncing = false;
  String? _message;

  Future<void> _seedTranslations() async {
    setState(() {
      _isSeeding = true;
      _message = null;
    });

    try {
      final seeder = TranslationSeeder();
      await seeder.seedAllTranslations();
      setState(() {
        _message = 'Translations seeded successfully!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error seeding: $e';
      });
    } finally {
      setState(() {
        _isSeeding = false;
      });
    }
  }

  Future<void> _syncTranslations() async {
    setState(() {
      _isSyncing = true;
      _message = null;
    });

    try {
      final syncManager = ref.read(localizationSyncManagerProvider);
      final results = await syncManager.syncAllLocalesWithResults();

      final messages =
          results.entries.map((e) => '${e.key}: ${e.value.message}').join('\n');

      setState(() {
        _message = 'Sync complete:\n$messages';
      });
    } catch (e) {
      setState(() {
        _message = 'Error syncing: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Localization Admin',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSeeding ? null : _seedTranslations,
                    icon: _isSeeding
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload),
                    label: const Text('Seed Firebase'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isSyncing ? null : _syncTranslations,
                    icon: _isSyncing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.sync),
                    label: const Text('Sync Now'),
                  ),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message!,
                  style: context.textTheme.bodySmall,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Seed: Upload local translations to Firebase\n'
              'Sync: Download Firebase translations to app',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
