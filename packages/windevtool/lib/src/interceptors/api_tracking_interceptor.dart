import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/windevtool_config.dart';
import '../repositories/dev_api_snapshot_repository.dart';
import '../utils/api_request_signature.dart';
import '../utils/api_schema_diff.dart';
import '../utils/api_schema_mappers.dart';

class ApiTrackingInterceptor extends Interceptor {
  ApiTrackingInterceptor({
    DevApiSnapshotRepository? repository,
  }) : _repository = repository ?? DevApiSnapshotRepository();

  final DevApiSnapshotRepository _repository;

  bool get _isEnabled =>
      WinDevTool.isInitialized && WinDevTool.config.isEnabled;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (!_isEnabled) {
      handler.next(response);
      return;
    }

    try {
      final request = response.requestOptions;
      final signature = buildSignature(request);
      final signatureId = safeIdFromSignature(signature);

      final bodyMap = decodeJsonBody(response.data);
      if (bodyMap.isEmpty) {
        handler.next(response);
        return;
      }

      final currentSchema = buildSchema(bodyMap);
      final currentSchemaJson = apiSchemaNodeToJson(currentSchema);

      final previousSnapshot = await _repository.loadSnapshot(signatureId);

      if (previousSnapshot == null) {
        await _repository.saveBaseline(
          id: signatureId,
          signatureKey: signature.asKey,
          method: signature.method,
          path: signature.path,
          query: signature.query,
          statusCode: response.statusCode ?? 0,
          schemaJson: currentSchemaJson,
          bodySample: _bodySample(bodyMap),
        );
        WinDevTool.config.log('API baseline captured for ${signature.asKey}');
        handler.next(response);
        return;
      }

      final previousSchema =
          apiSchemaNodeFromJson(previousSnapshot.latestSchemaJson);
      final diffs = diffSchemas(previousSchema, currentSchema);

      if (diffs.isEmpty) {
        handler.next(response);
        return;
      }

      final diffText = renderDiffLines(diffs);
      final bodySample = _bodySample(bodyMap);

      await _repository.appendChange(
        id: signatureId,
        statusCode: response.statusCode ?? 0,
        schemaJson: currentSchemaJson,
        bodySample: bodySample,
        diffText: diffText,
        previousSchemaJson: previousSnapshot.latestSchemaJson,
        previousBodySample: previousSnapshot.latestBodySample,
        previousCapturedAt: previousSnapshot.latestCapturedAt,
      );

      _logDiff(signature.asKey, diffText);
    } catch (e, st) {
      WinDevTool.config.log('ApiTrackingInterceptor error: $e\n$st');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }

  String _bodySample(Map<String, Object?> body) {
    try {
      final json = jsonEncode(body);
      if (json.length <= 2000) return json;
      return json.substring(0, 2000);
    } catch (_) {
      return body.toString();
    }
  }

  void _logDiff(String key, String diffText) {
    final header = 'API schema change detected for $key';
    final buffer = StringBuffer()..writeln(header);
    buffer.writeln(diffText);
    WinDevTool.config.log(buffer.toString());
  }
}
