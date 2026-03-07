import 'material.dart';
import 'typography.dart';

/// App theme object for use in [MaterialApp].
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: appTheme.light(),
///   darkTheme: appTheme.dark(),
///   ...
/// )
/// ```
final appTheme = MaterialTheme(TextTypoGraphy.instance!.textTheme);
