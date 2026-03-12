import 'package:dio/dio.dart';

class ApiRequestSignature {
  const ApiRequestSignature({
    required this.method,
    required this.path,
    required this.query,
  });

  final String method;
  final String path;
  final String query;

  String get asKey {
    if (query.isEmpty) {
      return '$method $path';
    }
    return '$method $path?$query';
  }
}

ApiRequestSignature buildSignature(RequestOptions request) {
  final uri = request.uri;
  return ApiRequestSignature(
    method: request.method.toUpperCase(),
    path: uri.path,
    query: uri.query,
  );
}

String safeIdFromSignature(ApiRequestSignature signature) {
  final raw = signature.asKey;
  final sanitized = raw.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
  return sanitized;
}
