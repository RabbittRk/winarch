class DevSnapshot {
  DevSnapshot({
    required this.id,
    required this.signatureKey,
    required this.method,
    required this.path,
    required this.query,
    required this.latestStatusCode,
    required this.latestCapturedAt,
    required this.latestSchemaJson,
    required this.latestBodySample,
    required this.latestHasDiff,
    this.previousCapturedAt,
    this.previousSchemaJson,
    this.previousBodySample,
  });

  final String id;
  final String signatureKey;
  final String method;
  final String path;
  final String query;
  final int latestStatusCode;
  final DateTime latestCapturedAt;
  final Map<String, dynamic> latestSchemaJson;
  final String latestBodySample;
  final bool latestHasDiff;
  final DateTime? previousCapturedAt;
  final Map<String, dynamic>? previousSchemaJson;
  final String? previousBodySample;
}

class DevSnapshotEvent {
  DevSnapshotEvent({
    required this.capturedAt,
    required this.statusCode,
    required this.diffText,
    required this.isBaseline,
  });

  final DateTime capturedAt;
  final int statusCode;
  final String diffText;
  final bool isBaseline;
}
