import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:winarch/core/devtools/api_schema_diff.dart';
import 'package:winarch/core/devtools/dev_api_snapshot_repository.dart';
import 'package:winarch/core/logger/app_logger.dart';
import 'package:winarch/core/network/api_request_signature.dart';
import 'package:winarch/core/network/api_schema_mappers.dart';
import 'package:winarch/env/app.env.dart';

class ApiTrackingInterceptor extends Interceptor {
  ApiTrackingInterceptor({
    required this.repository,
  });

  final DevApiSnapshotRepository repository;

  bool get _isEnabled => AppEnvironment().appEnvType == AppEnvType.dev;

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

      final previousSnapshot = await repository.loadSnapshot(signatureId);

      if (previousSnapshot == null) {
        await repository.saveBaseline(
          id: signatureId,
          signatureKey: signature.asKey,
          method: signature.method,
          path: signature.path,
          query: signature.query,
          statusCode: response.statusCode ?? 0,
          schemaJson: currentSchemaJson,
          bodySample: _bodySample(bodyMap),
        );
        AppLogger.log('API baseline captured for ${signature.asKey}');
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

      await repository.appendChange(
        id: signatureId,
        statusCode: response.statusCode ?? 0,
        schemaJson: currentSchemaJson,
        bodySample: _bodySample(bodyMap),
        diffText: diffText,
      );

      _logDiff(signature.asKey, diffText);
    } catch (e, st) {
      AppLogger.log('ApiTrackingInterceptor error: $e\n$st');
    }

    handler.next(response);
  }

  // Optional: record failures only
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_isEnabled) {
      handler.next(err);
      return;
    }

    // You can optionally push a failure event here if you want
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
    AppLogger.log(buffer.toString());
  }
}
