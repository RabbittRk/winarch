import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winarch/core/devtools/dev_api_snapshot_models.dart';

const _snapshotsCollection = 'dev_api_snapshots';
const _eventsSubcollection = 'events';

class DevApiSnapshotRepository {
  DevApiSnapshotRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _snapshotsRef =>
      _firestore.collection(_snapshotsCollection);

  DocumentReference<Map<String, dynamic>> _snapshotDoc(String id) =>
      _snapshotsRef.doc(id);

  CollectionReference<Map<String, dynamic>> _eventsRef(String id) =>
      _snapshotDoc(id).collection(_eventsSubcollection);

  Future<DevSnapshot?> loadSnapshot(String id) async {
    final doc = await _snapshotDoc(id).get();
    if (!doc.exists) return null;
    final d = doc.data()!;
    return DevSnapshot(
      id: doc.id,
      signatureKey: d['signatureKey'] as String,
      method: d['method'] as String,
      path: d['path'] as String,
      query: (d['query'] ?? '') as String,
      latestStatusCode: (d['latestStatusCode'] ?? 0) as int,
      latestCapturedAt: (d['latestCapturedAt'] as Timestamp).toDate(),
      latestSchemaJson:
          (d['latestSchemaJson'] as Map<String, dynamic>?) ?? const {},
      latestBodySample: (d['latestBodySample'] ?? '') as String,
      latestHasDiff: (d['latestHasDiff'] ?? false) as bool,
      previousCapturedAt: (d['previousCapturedAt'] as Timestamp?)?.toDate(),
      previousSchemaJson:
          (d['previousSchemaJson'] as Map<String, dynamic>?) ?? const {},
      previousBodySample: d['previousBodySample'] as String?,
    );
  }

  Future<void> saveBaseline({
    required String id,
    required String signatureKey,
    required String method,
    required String path,
    required String query,
    required int statusCode,
    required Map<String, dynamic> schemaJson,
    required String bodySample,
  }) async {
    final now = DateTime.now();
    await _snapshotDoc(id).set({
      'signatureKey': signatureKey,
      'method': method,
      'path': path,
      'query': query,
      'latestStatusCode': statusCode,
      'latestCapturedAt': Timestamp.fromDate(now),
      'latestSchemaJson': schemaJson,
      'latestBodySample': bodySample,
      'latestHasDiff': false,
      'previousCapturedAt': null,
      'previousSchemaJson': null,
      'previousBodySample': null,
    });
    await _eventsRef(id).add({
      'capturedAt': Timestamp.fromDate(now),
      'statusCode': statusCode,
      'diffText': 'No schema changes',
      'isBaseline': true,
      'schemaJson': schemaJson,
      'previousSchemaJson': null,
      'bodySample': bodySample,
      'previousBodySample': null,
    });
  }

  Future<void> appendChange({
    required String id,
    required int statusCode,
    required Map<String, dynamic> schemaJson,
    required String bodySample,
    required String diffText,
    required Map<String, dynamic> previousSchemaJson,
    required String previousBodySample,
    required DateTime previousCapturedAt,
  }) async {
    final now = DateTime.now();
    await _snapshotDoc(id).update({
      'latestStatusCode': statusCode,
      'latestCapturedAt': Timestamp.fromDate(now),
      'latestSchemaJson': schemaJson,
      'latestBodySample': bodySample,
      'latestHasDiff': true,
      'previousCapturedAt': Timestamp.fromDate(previousCapturedAt),
      'previousSchemaJson': previousSchemaJson,
      'previousBodySample': previousBodySample,
    });
    await _eventsRef(id).add({
      'capturedAt': Timestamp.fromDate(now),
      'statusCode': statusCode,
      'diffText': diffText,
      'isBaseline': false,
      'schemaJson': schemaJson,
      'previousSchemaJson': previousSchemaJson,
      'bodySample': bodySample,
      'previousBodySample': previousBodySample,
    });
  }
}
