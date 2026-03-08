// ignore_for_file: avoid_print

import 'dart:io';

import 'package:git_hooks/git_hooks.dart';

void main(List<String> arguments) {
  final params = <Git, UserBackFun>{
    Git.preCommit: preCommit,
    Git.commitMsg: commitMsg,
  };
  GitHooks.call(arguments, params);
}

/// Runs format, fix, format, then analyze. Returns false if any step fails.
/// Re-stages any files modified by format/fix so the commit includes those changes.
Future<bool> preCommit() async {
  const dartSteps = [
    ('dart', ['format', '.']),
    ('dart', ['fix', '--apply']),
    ('dart', ['format', '.']),
  ];

  final cwd = Directory.current.path;

  for (final step in dartSteps) {
    final result = await Process.run(step.$1, step.$2, workingDirectory: cwd);
    if (result.stdout.toString().trim().isNotEmpty) print(result.stdout);
    if (result.stderr.toString().trim().isNotEmpty) print(result.stderr);
    if (result.exitCode != 0) return false;
    // Re-stage so changes from format/fix are committed (they run after you stage).
    final addResult =
        await Process.run('git', ['add', '.'], workingDirectory: cwd);
    if (addResult.exitCode != 0) return false;
  }

  final analyzeResult = await Process.run(
    'dart',
    ['analyze', '--fatal-warnings'],
    workingDirectory: cwd,
  );
  if (analyzeResult.stdout.toString().trim().isNotEmpty) {
    print(analyzeResult.stdout);
  }
  if (analyzeResult.stderr.toString().trim().isNotEmpty) {
    print(analyzeResult.stderr);
  }
  return analyzeResult.exitCode == 0;
}

/// Validates conventional commit: type(scope): subject, header max 100 chars.
Future<bool> commitMsg() async {
  const maxHeaderLength = 100;
  const allowedTypes = [
    'feat',
    'fix',
    'docs',
    'style',
    'refactor',
    'perf',
    'test',
    'build',
    'ci',
    'chore',
  ];

  final message = Utils.getCommitEditMsg();
  final lines = message.split('\n');
  final validLines = lines
      .where((line) => line.trim().isNotEmpty && !line.startsWith('#'))
      .toList();
  final header = validLines.isEmpty ? null : validLines.first.trim();

  if (header == null || header.isEmpty) {
    print('Commit message must have a non-empty subject line.');
    return false;
  }

  if (header.length > maxHeaderLength) {
    print(
      'Commit header must be at most $maxHeaderLength characters (got ${header.length}).',
    );
    return false;
  }

  // Conventional commit: type(scope)?: subject. Optional ! for breaking.
  final pattern = RegExp(
    r'^(' + allowedTypes.join('|') + r')(\([^)]+\))?!?:\s+.+',
    caseSensitive: false,
  );

  if (!pattern.hasMatch(header)) {
    print(
      'Commit message must follow conventional commits: '
      'type(scope): subject. Allowed types: ${allowedTypes.join(", ")}. '
      'Example: feat(auth): add login',
    );
    return false;
  }

  return true;
}
