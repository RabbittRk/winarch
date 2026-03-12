import 'dart:convert';

enum ApiValueKind {
  integer,
  floating,
  string,
  boolean,
  object,
  array,
  nullValue,
  unknown,
}

class ApiSchemaNode {
  const ApiSchemaNode({
    required this.kind,
    this.children = const {},
    this.element,
  });

  final ApiValueKind kind;
  final Map<String, ApiSchemaNode> children;
  final ApiSchemaNode? element;
}

enum ApiSchemaDiffType {
  added,
  removed,
  changed,
}

class ApiSchemaDiffEntry {
  const ApiSchemaDiffEntry.added(this.path, this.newKind)
      : oldKind = null,
        type = ApiSchemaDiffType.added;

  const ApiSchemaDiffEntry.removed(this.path, this.oldKind)
      : newKind = null,
        type = ApiSchemaDiffType.removed;

  const ApiSchemaDiffEntry.changed(
    this.path, {
    required this.oldKind,
    required this.newKind,
  }) : type = ApiSchemaDiffType.changed;

  final String path;
  final ApiSchemaDiffType type;
  final ApiValueKind? oldKind;
  final ApiValueKind? newKind;
}

ApiSchemaNode buildSchema(Object? value) {
  if (value == null) {
    return const ApiSchemaNode(kind: ApiValueKind.nullValue);
  }

  if (value is bool) {
    return const ApiSchemaNode(kind: ApiValueKind.boolean);
  }

  if (value is int) {
    return const ApiSchemaNode(kind: ApiValueKind.integer);
  }

  if (value is double) {
    return const ApiSchemaNode(kind: ApiValueKind.floating);
  }

  if (value is String) {
    return const ApiSchemaNode(kind: ApiValueKind.string);
  }

  if (value is List) {
    final elementSchema =
        value.isEmpty ? null : buildSchema(value.first as Object?);
    return ApiSchemaNode(
      kind: ApiValueKind.array,
      element: elementSchema,
    );
  }

  if (value is Map<String, Object?>) {
    final children = <String, ApiSchemaNode>{};
    for (final entry in value.entries) {
      children[entry.key] = buildSchema(entry.value);
    }
    return ApiSchemaNode(
      kind: ApiValueKind.object,
      children: children,
    );
  }

  return const ApiSchemaNode(kind: ApiValueKind.unknown);
}

List<ApiSchemaDiffEntry> diffSchemas(
  ApiSchemaNode previous,
  ApiSchemaNode current, {
  String prefix = r'$',
}) {
  final diffs = <ApiSchemaDiffEntry>[];

  if (previous.kind != current.kind) {
    diffs.add(
      ApiSchemaDiffEntry.changed(
        prefix,
        oldKind: previous.kind,
        newKind: current.kind,
      ),
    );
    return diffs;
  }

  if (previous.kind == ApiValueKind.object) {
    final prevKeys = previous.children.keys.toSet();
    final currKeys = current.children.keys.toSet();

    for (final key in prevKeys.difference(currKeys)) {
      final node = previous.children[key]!;
      diffs.add(
        ApiSchemaDiffEntry.removed(
          '$prefix.$key',
          node.kind,
        ),
      );
    }

    for (final key in currKeys.difference(prevKeys)) {
      final node = current.children[key]!;
      diffs.add(
        ApiSchemaDiffEntry.added(
          '$prefix.$key',
          node.kind,
        ),
      );
    }

    for (final key in prevKeys.intersection(currKeys)) {
      final prevChild = previous.children[key]!;
      final currChild = current.children[key]!;
      diffs.addAll(
        diffSchemas(
          prevChild,
          currChild,
          prefix: '$prefix.$key',
        ),
      );
    }
  } else if (previous.kind == ApiValueKind.array &&
      previous.element != null &&
      current.element != null) {
    diffs.addAll(
      diffSchemas(
        previous.element!,
        current.element!,
        prefix: '$prefix[]',
      ),
    );
  }

  return diffs;
}

String renderDiffLines(List<ApiSchemaDiffEntry> entries) {
  final buffer = StringBuffer();
  for (final entry in entries) {
    switch (entry.type) {
      case ApiSchemaDiffType.added:
        buffer.writeln(
          '+ ${entry.path}: ${_kindToString(entry.newKind!)}',
        );
      case ApiSchemaDiffType.removed:
        buffer.writeln(
          '- ${entry.path}: ${_kindToString(entry.oldKind!)}',
        );
      case ApiSchemaDiffType.changed:
        buffer.writeln(
          '- ${entry.path}: ${_kindToString(entry.oldKind!)}',
        );
        buffer.writeln(
          '+ ${entry.path}: ${_kindToString(entry.newKind!)}',
        );
    }
  }
  return buffer.toString();
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

/// Helper to normalize a JSON body into a `Map<String, Object?>` for schema.
Map<String, Object?> decodeJsonBody(Object? data) {
  if (data is Map<String, Object?>) {
    return data;
  }

  if (data is String) {
    final decoded = jsonDecode(data);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
  }

  return <String, Object?>{};
}
