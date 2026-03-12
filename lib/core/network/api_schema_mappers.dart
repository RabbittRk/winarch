import 'package:winarch/core/devtools/api_schema_diff.dart';

Map<String, dynamic> apiSchemaNodeToJson(ApiSchemaNode node) {
  return {
    'kind': _kindToString(node.kind),
    'children': node.children.map(
      (k, v) => MapEntry(k, apiSchemaNodeToJson(v)),
    ),
    if (node.element != null) 'element': apiSchemaNodeToJson(node.element!),
  };
}

ApiSchemaNode apiSchemaNodeFromJson(Map<String, dynamic> json) {
  final kind = _kindFromString(json['kind'] as String);
  final childrenJson = (json['children'] as Map<String, dynamic>? ?? const {});
  final children = <String, ApiSchemaNode>{};
  for (final entry in childrenJson.entries) {
    children[entry.key] = apiSchemaNodeFromJson(
      entry.value as Map<String, dynamic>,
    );
  }
  final elementJson = json['element'] as Map<String, dynamic>?;
  return ApiSchemaNode(
    kind: kind,
    children: children,
    element: elementJson == null ? null : apiSchemaNodeFromJson(elementJson),
  );
}

String _kindToString(ApiValueKind kind) {
  switch (kind) {
    case ApiValueKind.integer:
      return 'int';
    case ApiValueKind.floating:
      return 'double';
    case ApiValueKind.string:
      return 'String';
    case ApiValueKind.boolean:
      return 'bool';
    case ApiValueKind.object:
      return 'object';
    case ApiValueKind.array:
      return 'array';
    case ApiValueKind.nullValue:
      return 'null';
    case ApiValueKind.unknown:
      return 'unknown';
  }
}

ApiValueKind _kindFromString(String value) {
  switch (value) {
    case 'int':
      return ApiValueKind.integer;
    case 'double':
      return ApiValueKind.floating;
    case 'String':
      return ApiValueKind.string;
    case 'bool':
      return ApiValueKind.boolean;
    case 'object':
      return ApiValueKind.object;
    case 'array':
      return ApiValueKind.array;
    case 'null':
      return ApiValueKind.nullValue;
    case 'unknown':
    default:
      return ApiValueKind.unknown;
  }
}
