import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/devtools/dev_api_tracking_providers.dart';

class DevApiTrackingScreen extends ConsumerWidget {
  const DevApiTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotsAsync = ref.watch(devApiFilteredSnapshotsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Tracking'),
      ),
      body: Column(
        children: [
          const _FiltersRow(),
          Expanded(
            child: snapshotsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
              data: (snapshots) {
                if (snapshots.isEmpty) {
                  return const Center(
                    child: Text('No API snapshots captured yet.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshots.length,
                  itemBuilder: (context, index) {
                    final snapshot = snapshots[index];
                    final method = snapshot.method;
                    final path = snapshot.path;
                    final query = snapshot.query;
                    final latestStatusCode = snapshot.latestStatusCode;
                    final latestCapturedAt = snapshot.latestCapturedAt;
                    final bodySample = snapshot.latestBodySample;

                    final tile = ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: Text('$method $path'),
                      subtitle: Text(
                        [
                          if (query.isNotEmpty) '?$query',
                          'Status $latestStatusCode',
                          latestCapturedAt.toLocal().toIso8601String(),
                        ].where((e) => e.isNotEmpty).join(' • '),
                      ),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Latest response body:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SelectableText(
                              _prettyPrintJson(bodySample),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _EventsSection(snapshotId: snapshot.id),
                        const SizedBox(height: 8),
                      ],
                    );

                    return tile;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersRow extends ConsumerWidget {
  const _FiltersRow();

  static const _methods = <String>[
    '',
    'GET',
    'POST',
    'PUT',
    'PATCH',
    'DELETE',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(devApiMethodFilterProvider);
    final query = ref.watch(devApiEndpointQueryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedMethod,
            hint: const Text('Method'),
            onChanged: (value) {
              ref.read(devApiMethodFilterProvider.notifier).state = value ?? '';
            },
            items: _methods
                .map(
                  (m) => DropdownMenuItem<String>(
                    value: m,
                    child: Text(m.isEmpty ? 'All' : m),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search endpoint',
                hintText: '/users, id=, ?page=',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) =>
                  ref.read(devApiEndpointQueryProvider.notifier).state = value,
              controller: TextEditingController(text: query)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: query.length),
                ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsSection extends StatelessWidget {
  const _EventsSection({required this.snapshotId});

  final String snapshotId;

  @override
  Widget build(BuildContext context) {
    final eventsQuery = FirebaseFirestore.instance
        .collection('dev_api_snapshots')
        .doc(snapshotId)
        .collection('events')
        .orderBy('capturedAt', descending: true)
        .limit(10);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: eventsQuery.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent schema events:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            ...docs.map((doc) {
              final data = doc.data();
              final capturedAt = (data['capturedAt'] as Timestamp?)?.toDate();
              final statusCode = data['statusCode'] as int? ?? 0;
              final diffText = data['diffText'] as String? ?? '';
              final isBaseline = data['isBaseline'] as bool? ?? false;

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isBaseline
                      ? Icons.flag_outlined
                      : Icons.change_circle_outlined,
                  color: isBaseline
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                title: Text(
                  isBaseline ? 'Baseline captured' : 'Schema change detected',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                subtitle: Text(
                  [
                    'Status $statusCode',
                    if (capturedAt != null)
                      capturedAt.toLocal().toIso8601String(),
                  ].join(' • '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: diffText.isEmpty
                    ? null
                    : Tooltip(
                        message: diffText,
                        child: const Icon(
                          Icons.description_outlined,
                          size: 18,
                        ),
                      ),
              );
            }),
          ],
        );
      },
    );
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({super.key, required this.child});

  final Widget child;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _offset = Tween<double>(begin: -4, end: 4)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offset.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

String _prettyPrintJson(String bodySample) {
  if (bodySample.isEmpty) return '(empty body)';
  try {
    final decoded = jsonDecode(bodySample);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(decoded);
  } catch (_) {
    return bodySample;
  }
}
