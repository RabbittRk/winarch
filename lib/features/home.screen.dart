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

  static const _tabs = ['Form', 'Components', 'Settings', 'Modules'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[navigationShell.currentIndex]),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Form',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets),
            label: 'Components',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_module_outlined),
            selectedIcon: Icon(Icons.view_module),
            label: 'Modules',
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class FormTab extends StatelessWidget {
  const FormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Simple Forms',
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Form',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    prefixIcon: Icon(Icons.message_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ComponentsTab extends StatelessWidget {
  const ComponentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Components',
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        _SectionCard(
          title: 'Form Fields',
          icon: Icons.text_fields,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Text Field'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Dropdown'),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Option 1')),
                  DropdownMenuItem(value: '2', child: Text('Option 2')),
                  DropdownMenuItem(value: '3', child: Text('Option 3')),
                ],
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Toggle Switch'),
                value: true,
                onChanged: (_) {},
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Bottom Sheets',
          icon: Icons.vertical_align_bottom,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showModalBottomSheet(context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Show Modal Bottom Sheet'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showDraggableBottomSheet(context),
                  icon: const Icon(Icons.drag_handle),
                  label: const Text('Show Draggable Bottom Sheet'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Dialogs',
          icon: Icons.chat_bubble_outline,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAlertDialog(context),
                  icon: const Icon(Icons.warning_amber),
                  label: const Text('Show Alert Dialog'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showConfirmDialog(context),
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Show Confirm Dialog'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showInputDialog(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Show Input Dialog'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Modal Bottom Sheet',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('This is a simple modal bottom sheet.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDraggableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Draggable Bottom Sheet',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...List.generate(
              20,
              (index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber, size: 48),
        title: const Text('Alert'),
        content:
            const Text('This is an alert dialog with important information.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content:
            const Text('Are you sure you want to proceed with this action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Enter your name'),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = context.locale;
    final themeState = ref.watch(themeProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Settings',
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        _SectionCard(
          title: 'Theme',
          icon: Icons.palette,
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.light_mode,
                title: 'Light',
                isSelected: themeState.themeMode == ThemeMode.light,
                onTap: () => ref.read(themeProvider.notifier).setLight(),
              ),
              _SettingsTile(
                icon: Icons.dark_mode,
                title: 'Dark',
                isSelected: themeState.themeMode == ThemeMode.dark,
                onTap: () => ref.read(themeProvider.notifier).setDark(),
              ),
              _SettingsTile(
                icon: Icons.brightness_auto,
                title: 'System',
                isSelected: themeState.themeMode == ThemeMode.system,
                onTap: () => ref.read(themeProvider.notifier).setSystem(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Language',
          icon: Icons.language,
          child: Column(
            children: [
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
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Account',
          icon: Icons.account_circle,
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                ref.invalidate(authFromStorageProvider);
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: Text(LocaleKeys.actionsSignOut.tr()),
            ),
          ),
        ),
        if (kDebugMode) ...[
          const SizedBox(height: 16),
          const LocalizationAdminWidget(),
        ],
      ],
    );
  }
}

class ModulesTab extends StatelessWidget {
  const ModulesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Modules',
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        _ModuleCard(
          icon: Icons.directions_car,
          title: 'Cars Module',
          description: 'Browse and manage vehicles',
          onTap: () => context.push('/cars'),
        ),
        const SizedBox(height: 12),
        _ModuleCard(
          icon: Icons.shopping_bag,
          title: 'Shop Module',
          description: 'Coming soon...',
          isEnabled: false,
          onTap: null,
        ),
        const SizedBox(height: 12),
        _ModuleCard(
          icon: Icons.inventory_2,
          title: 'Inventory Module',
          description: 'Coming soon...',
          isEnabled: false,
          onTap: null,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

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
                Icon(icon, color: context.colors.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing:
          isSelected ? Icon(Icons.check, color: context.colors.primary) : null,
      selected: isSelected,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.description,
    this.isEnabled = true,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isEnabled
              ? context.colors.primaryContainer
              : context.colors.surfaceContainerHighest,
          child: Icon(
            icon,
            color: isEnabled
                ? context.colors.onPrimaryContainer
                : context.colors.outline,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isEnabled ? null : context.colors.outline,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: isEnabled ? null : context.colors.outline,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isEnabled ? null : context.colors.outline,
        ),
        enabled: isEnabled,
        onTap: onTap,
      ),
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
