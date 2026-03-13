import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/core/localization/firebase/localization_admin_widget.dart';
import 'package:winarch/core/localization/locale_keys.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/theme/theme.dart';
import 'package:wincore/wincore.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(navigationShell.currentIndex)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
            tooltip: LocaleKeys.actionsToggleTheme.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              ref.invalidate(authFromStorageProvider);
              if (context.mounted) context.go('/login');
            },
            tooltip: LocaleKeys.actionsSignOut.tr(),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: LocaleKeys.navHome.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: LocaleKeys.navExplore.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: LocaleKeys.navProfile.tr(),
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.navHome.tr();
      case 1:
        return LocaleKeys.navExplore.tr();
      case 2:
        return LocaleKeys.navProfile.tr();
      default:
        return LocaleKeys.navHome.tr();
    }
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 64,
            color: context.colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.homeWelcome.tr(),
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/cars'),
            icon: const Icon(Icons.directions_car),
            label: Text(LocaleKeys.homeBrowseCars.tr()),
          ),
        ],
      ),
    );
  }
}

class ExploreTab extends ConsumerWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore,
            size: 64,
            color: context.colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.navExplore.tr(),
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/cars'),
            icon: const Icon(Icons.directions_car),
            label: Text(LocaleKeys.homeBrowseCars.tr()),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = context.locale;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 24),
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: context.colors.primaryContainer,
            child: Icon(
              Icons.person,
              size: 48,
              color: context.colors.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            LocaleKeys.navProfile.tr(),
            style: context.textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      LocaleKeys.settingsLanguage.tr(),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _LanguageOption(
                  locale: const Locale('en'),
                  label: LocaleKeys.settingsEnglish.tr(),
                  flag: '🇺🇸',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () => context.setLocale(const Locale('en')),
                ),
                const SizedBox(height: 8),
                _LanguageOption(
                  locale: const Locale('ta'),
                  label: LocaleKeys.settingsTamil.tr(),
                  flag: '🇮🇳',
                  isSelected: currentLocale.languageCode == 'ta',
                  onTap: () => context.setLocale(const Locale('ta')),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => context.push('/cars'),
          icon: const Icon(Icons.directions_car),
          label: Text(LocaleKeys.homeBrowseCars.tr()),
        ),
        if (kDebugMode) ...[
          const SizedBox(height: 24),
          const LocalizationAdminWidget(),
        ],
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  final Locale locale;
  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primaryContainer
              : context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: context.colors.primary, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? context.colors.onPrimaryContainer
                      : context.colors.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.colors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
