import 'dart:io';

/// Finds `.dart` files under `lib/` that appear to be unused (their filename
/// does not show up anywhere under `lib/`) and optionally deletes them.
///
/// Usage:
///   dart run tool/find_unused_dart_files.dart
///   dart run tool/find_unused_dart_files.dart --delete
///
/// With `--delete`, the script will prompt once for confirmation and then
/// delete all reported files.
Future<void> main(List<String> args) async {
  final shouldDelete = args.contains('--delete');

  final projectRoot = Directory.current;
  final libDir = Directory('${projectRoot.path}${Platform.pathSeparator}lib');

  if (!await libDir.exists()) {
    stderr.writeln('lib/ directory not found at: ${libDir.path}');
    exitCode = 1;
    return;
  }

  final dartFiles = await _listDartFiles(libDir);

  if (dartFiles.isEmpty) {
    stdout.writeln('No .dart files found under lib/.');
    return;
  }

  final allLibContent = <String>[];

  // Read all lib files into memory once so we can do filename checks quickly.
  for (final file in dartFiles) {
    final content = await File(file).readAsString();
    allLibContent.add(content);
  }

  final unused = <String>[];

  for (final file in dartFiles) {
    final name = file.split(Platform.pathSeparator).last;

    final isReferenced = allLibContent.any((content) => content.contains(name));

    if (!isReferenced) {
      unused.add(file);
    }
  }

  if (unused.isEmpty) {
    stdout.writeln('No unused .dart files detected under lib/.');
    return;
  }

  stdout.writeln(
    'Unused .dart files (filename not referenced anywhere in lib/):',
  );
  for (final file in unused) {
    stdout.writeln('  $file');
  }

  if (!shouldDelete) {
    stdout.writeln(
      '\nRun with `--delete` to remove these files, or delete them manually.',
    );
    return;
  }

  stdout.write(
    '\nDelete ALL of the above files? Type "yes" to confirm: ',
  );
  final confirmation = stdin.readLineSync();

  if (confirmation?.toLowerCase() != 'yes') {
    stdout.writeln('Aborted. No files were deleted.');
    return;
  }

  var deleted = 0;
  var failed = 0;

  for (final path in unused) {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        deleted++;
      }
    } catch (e) {
      failed++;
      stderr.writeln('Failed to delete $path: $e');
    }
  }

  stdout.writeln(
    'Done. Deleted $deleted file(s).${failed > 0 ? ' Failed to delete $failed file(s).' : ''}',
  );
}

Future<List<String>> _listDartFiles(Directory root) async {
  final result = <String>[];

  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      result.add(entity.path);
    }
  }

  return result;
}
