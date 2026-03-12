import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:winarch/core/devtools/dev_api_snapshot_models.dart';

final devApiSnapshotsStreamProvider =
    StreamProvider<List<DevSnapshot>>((ref) async* {
  final snapshotsQuery = FirebaseFirestore.instance
      .collection('dev_api_snapshots')
      .orderBy('latestCapturedAt', descending: true);

  yield* snapshotsQuery.snapshots().map(
        (snap) => snap.docs.map(
          (doc) {
            final data = doc.data();
            return DevSnapshot(
              id: doc.id,
              signatureKey: (data['signatureKey'] ?? '') as String,
              method: (data['method'] ?? '') as String,
              path: (data['path'] ?? '') as String,
              query: (data['query'] ?? '') as String,
              latestStatusCode: (data['latestStatusCode'] ?? 0) as int,
              latestCapturedAt:
                  (data['latestCapturedAt'] as Timestamp).toDate(),
              latestSchemaJson:
                  (data['latestSchemaJson'] as Map<String, dynamic>?) ??
                      const {},
              latestBodySample: (data['latestBodySample'] ?? '') as String,
              latestHasDiff: (data['latestHasDiff'] ?? false) as bool,
              diffVersion: (data['diffVersion'] ?? 0) as int,
              previousCapturedAt:
                  (data['previousCapturedAt'] as Timestamp?)?.toDate(),
              previousSchemaJson:
                  (data['previousSchemaJson'] as Map<String, dynamic>?) ??
                      const {},
              previousBodySample: data['previousBodySample'] as String?,
            );
          },
        ).toList(),
      );
});

final devApiMethodFilterProvider = StateProvider<String>((ref) => '');

final devApiEndpointQueryProvider = StateProvider<String>((ref) => '');

final devApiFilteredSnapshotsProvider =
    Provider<AsyncValue<List<DevSnapshot>>>((ref) {
  final snapshotsAsync = ref.watch(devApiSnapshotsStreamProvider);
  final methodFilter = ref.watch(devApiMethodFilterProvider);
  final endpointQuery = ref.watch(devApiEndpointQueryProvider).toLowerCase();

  return snapshotsAsync.whenData(
    (items) => items.where((s) {
      final matchesMethod = methodFilter.isEmpty ||
          s.method.toUpperCase() == methodFilter.toUpperCase();

      final searchTarget = '${s.path} ${s.query}'
          .toLowerCase()
          .trim()
          .replaceAll(RegExp(r'\s+'), ' ');
      final matchesQuery =
          endpointQuery.isEmpty || searchTarget.contains(endpointQuery);

      return matchesMethod && matchesQuery;
    }).toList(),
  );
});

final devApiHasActiveDiffProvider = Provider<AsyncValue<bool>>((ref) {
  final snapshotsAsync = ref.watch(devApiSnapshotsStreamProvider);
  return snapshotsAsync.whenData(
    (items) => items.any((s) => s.latestHasDiff),
  );
});

final devApiActiveDiffCountProvider = Provider<AsyncValue<int>>((ref) {
  final snapshotsAsync = ref.watch(devApiSnapshotsStreamProvider);
  return snapshotsAsync.whenData(
    (items) => items.where((s) => s.latestHasDiff).length,
  );
});

final devApiLatestDiffVersionProvider = Provider<AsyncValue<int>>((ref) {
  final snapshotsAsync = ref.watch(devApiSnapshotsStreamProvider);
  return snapshotsAsync.whenData((items) {
    if (items.isEmpty) return 0;
    return items.map((s) => s.diffVersion).fold<int>(
          0,
          (prev, v) => v > prev ? v : prev,
        );
  });
});

final devApiSnapshotEventsProvider =
    StreamProvider.family<List<DevSnapshotEvent>, String>(
        (ref, snapshotId) async* {
  final eventsQuery = FirebaseFirestore.instance
      .collection('dev_api_snapshots')
      .doc(snapshotId)
      .collection('events')
      .orderBy('capturedAt', descending: true)
      .limit(50);

  yield* eventsQuery.snapshots().map(
        (snap) => snap.docs.map(
          (doc) {
            final data = doc.data();
            return DevSnapshotEvent(
              capturedAt: (data['capturedAt'] as Timestamp).toDate(),
              statusCode: (data['statusCode'] ?? 0) as int,
              diffText: (data['diffText'] ?? '') as String,
              isBaseline: (data['isBaseline'] ?? false) as bool,
            );
          },
        ).toList(),
      );
});
