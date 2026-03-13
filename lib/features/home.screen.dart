import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/theme/theme.dart';
import 'package:wincore/wincore.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
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
      body: Center(
        child: Column(
          children: [
            Text('Home').p(16),
            TextButton(
              onPressed: () {
                context.push('/cars');
              },
              child: Text('Cars'),
            ),
            TextFormField(),
            FilledButton(
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1), () {});
              },
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(themeProvider.notifier).toggle();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
