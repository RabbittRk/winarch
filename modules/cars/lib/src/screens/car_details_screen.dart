import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wincore/wincore.dart';

import '../localization/cars_locale_keys.dart';

class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({
    super.key,
    required this.carId,
  });

  final String carId;

  @override
  Widget build(BuildContext context) {
    final car = _getCarById(carId);

    return Scaffold(
      appBar: AppBar(
        title: Text(car?['name'] ?? CarsLocaleKeys.carsDetails.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cars'),
        ),
      ),
      body: car == null
          ? Center(
              child: Text(
                'Car not found',
                style: context.textTheme.titleLarge,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: context.colors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      size: 80,
                      color: context.colors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    car['name']!,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    car['brand']!,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(
                    context,
                    title: 'Car ID',
                    value: carId,
                    icon: Icons.tag,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    title: 'Description',
                    value: car['description'] ?? 'No description available',
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Booking ${car['name']}...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.book_online),
                      label: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.colors.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, String>? _getCarById(String id) {
  const cars = <Map<String, String>>[
    {
      'id': '1',
      'name': 'Model S',
      'brand': 'Tesla',
      'description': 'Electric luxury sedan with autopilot capabilities.',
    },
    {
      'id': '2',
      'name': 'Mustang',
      'brand': 'Ford',
      'description': 'Iconic American muscle car with powerful V8 engine.',
    },
    {
      'id': '3',
      'name': '911',
      'brand': 'Porsche',
      'description': 'Legendary sports car with rear-engine layout.',
    },
    {
      'id': '4',
      'name': 'Civic',
      'brand': 'Honda',
      'description': 'Reliable compact car with excellent fuel economy.',
    },
    {
      'id': '5',
      'name': 'Camry',
      'brand': 'Toyota',
      'description': 'Best-selling midsize sedan with proven reliability.',
    },
  ];

  try {
    return cars.firstWhere((car) => car['id'] == id);
  } catch (_) {
    return null;
  }
}
