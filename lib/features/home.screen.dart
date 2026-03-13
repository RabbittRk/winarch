import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              ref.invalidate(authFromStorageProvider);
              if (context.mounted) context.go('/login');
            },
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Explore';
      case 2:
        return 'Profile';
      default:
        return 'Home';
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
            'Welcome Home',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/cars'),
            icon: const Icon(Icons.directions_car),
            label: const Text('Browse Cars'),
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
            'Explore',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/cars'),
            icon: const Icon(Icons.directions_car),
            label: const Text('Browse Cars'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64,
            color: context.colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Profile',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/cars'),
            icon: const Icon(Icons.directions_car),
            label: const Text('Browse Cars'),
          ),
        ],
      ),
    );
  }
}
