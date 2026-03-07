import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ),
      body: Center(
        child: Column(
          children: [
            Text('Home').p(16),
            FilledButton(
              onPressed: () async {

                await Future.delayed(const Duration(seconds: 1),(){
                  print('sdfasdf');
                });
                // ref.read(themeProvider.notifier).toggle();
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
