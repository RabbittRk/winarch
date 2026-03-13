import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wincore/wincore.dart';

class CarsHomeScreen extends StatelessWidget {
  const CarsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sampleCars.length,
        itemBuilder: (context, index) {
          final car = _sampleCars[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: context.colors.primaryContainer,
                child: Icon(
                  Icons.directions_car,
                  color: context.colors.onPrimaryContainer,
                ),
              ),
              title: Text(
                car['name']!,
                style: context.textTheme.titleMedium,
              ),
              subtitle: Text(
                car['brand']!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: context.colors.onSurfaceVariant,
              ),
              onTap: () => context.go('/cars/details/${car['id']}'),
            ),
          );
        },
      ),
    );
  }
}

const List<Map<String, String>> _sampleCars = [
  {'id': '1', 'name': 'Model S', 'brand': 'Tesla'},
  {'id': '2', 'name': 'Mustang', 'brand': 'Ford'},
  {'id': '3', 'name': '911', 'brand': 'Porsche'},
  {'id': '4', 'name': 'Civic', 'brand': 'Honda'},
  {'id': '5', 'name': 'Camry', 'brand': 'Toyota'},
];
