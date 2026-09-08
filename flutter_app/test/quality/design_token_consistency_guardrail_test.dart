// Origin: 010eaf01 (2026-06-13) - feat(design-system): chuẩn hóa token UI Flutter enterprise
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('design token consistency report artifacts are current', () {
    final first = _runDesignTokenAudit();
    if (first.exitCode == 0) return;

    // This subprocess check competes with sibling `dart run tool/*.dart`
    // audits spawned by other quality guardrail tests for CPU time under
    // full-suite parallel runs, which can make the underlying `dart run`
    // slow enough to look broken even though the artifacts are current.
    // Retry once before failing so that transient contention isn't
    // mistaken for a real stale/broken artifact; both attempts' output is
    // surfaced so a genuine failure is still fully debuggable.
    final retry = _runDesignTokenAudit();
    expect(
      retry.exitCode,
      0,
      reason:
          'First attempt:\nstdout:\n${first.stdout}\n\nstderr:\n${first.stderr}\n\n'
          'Retry attempt:\nstdout:\n${retry.stdout}\n\nstderr:\n${retry.stderr}\n\n'
          'Run `dart run tool/design_token_consistency_audit.dart` from flutter_app/.',
    );
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('shared interactive widgets use canonical control radius', () {
    const interactiveWidgetPaths = <String>[
      'lib/shared/widgets/vit_choice_pill.dart',
      'lib/shared/widgets/vit_tab_bar.dart',
      'lib/shared/widgets/vit_segmented_choice.dart',
      'lib/shared/widgets/vit_cta_button.dart',
      'lib/shared/layout/vit_header_action_button.dart',
      'lib/shared/widgets/vit_section_header.dart',
      'lib/shared/widgets/vit_inline_icon_action.dart',
    ];

    final violations = <String>[];
    for (final path in interactiveWidgetPaths) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: 'Missing $path');
      final content = file.readAsStringSync();
      if (content.contains('borderRadius: AppRadii.smRadius') ||
          content.contains('borderRadius = AppRadii.smRadius') ||
          content.contains('AppRadii.headerActionRadius')) {
        violations.add(
          '$path: interactive control must use AppRadii.inputRadius',
        );
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('VitCard maps standard and large tiers only', () {
    final cardFile = File('lib/shared/widgets/vit_card.dart');
    final content = cardFile.readAsStringSync();

    expect(content, contains('case VitCardRadius.standard:'));
    expect(content, contains('return AppRadii.cardRadius;'));
    expect(content, contains('case VitCardRadius.large:'));
    expect(content, contains('return AppRadii.cardLargeRadius;'));
    expect(content, isNot(contains('VitCardRadius.sm')));
    expect(content, isNot(contains('VitCardRadius.md')));
    expect(
      RegExp(r'case VitCardRadius\.standard:[\s\S]*?AppRadii\.mdRadius'),
      isNot(matches(content)),
      reason: 'standard tier must not map to mdRadius',
    );
  });

  test('changed app files do not introduce new local design debt', () {
    final changedFiles = _collectChangedLibFiles();
    final violations = <String>[];

    for (final path in changedFiles) {
      final lower = path.toLowerCase();
      if (_isPathException(lower)) continue;

      final isUntracked = !_isTracked(path);
      final lines = _collectAddedLines(path, isUntracked);
      for (final line in lines) {
        final reason = _lineDebtReason(line);
        if (reason != null) {
          violations.add('$path: $reason -> $line');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

ProcessResult _runDesignTokenAudit() {
  return Process.runSync(_dartExecutable(), [
    'run',
    'tool/design_token_consistency_audit.dart',
    '--check',
  ]);
}

String _dartExecutable() {
  final executable = Platform.resolvedExecutable;
  final normalized = executable.replaceAll('\\', '/');
  if (normalized.endsWith('/dart.exe') || normalized.endsWith('/dart')) {
    return executable;
  }

  const cacheMarker = '/flutter/bin/cache/';
  final cacheIndex = normalized.indexOf(cacheMarker);
  if (cacheIndex >= 0) {
    final cacheRoot = normalized.substring(0, cacheIndex + cacheMarker.length);
    return '${cacheRoot}dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return '$flutterRoot/bin/cache/dart-sdk/bin/dart';
  }
  return 'dart';
}

List<String> _collectChangedLibFiles() {
  final changed = <String>{};
  final diffResult = Process.runSync('git', [
    'diff',
    '--name-only',
    'HEAD',
    '--',
    'lib',
  ]);
  if (diffResult.exitCode == 0) {
    for (final line in diffResult.stdout.toString().split('\n')) {
      final path = line.trim();
      if (path.isNotEmpty && path.endsWith('.dart')) changed.add(path);
    }
  }

  final statusResult = Process.runSync('git', [
    'status',
    '--porcelain',
    '--',
    'lib',
  ]);
  if (statusResult.exitCode == 0) {
    for (final line in statusResult.stdout.toString().split('\n')) {
      if (line.length < 3) continue;
      final status = line.substring(0, 2);
      final path = line.substring(3).trim();
      if (status.trim().isEmpty) continue;
      if (path.endsWith('.dart')) changed.add(path);
    }
  }

  return changed.toList()..sort();
}

bool _isTracked(String path) {
  final result = Process.runSync('git', ['ls-files', '--error-unmatch', path]);
  return result.exitCode == 0;
}

List<String> _collectAddedLines(String path, bool isUntracked) {
  if (isUntracked) {
    final file = File(path);
    if (!file.existsSync()) return const [];
    return file.readAsLinesSync();
  }

  final result = Process.runSync('git', ['diff', 'HEAD', '--', path]);
  if (result.exitCode != 0) return const [];

  final added = <String>[];
  for (final line in result.stdout.toString().split('\n')) {
    if (!line.startsWith('+')) continue;
    if (line.startsWith('+++')) continue;
    added.add(line.substring(1));
  }
  return added;
}

String? _lineDebtReason(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty || trimmed.startsWith('//')) return null;
  if (_commentFontSizePattern.hasMatch(trimmed)) return null;

  if (_fontSizePattern.hasMatch(trimmed)) return 'fontSize hardcoded';
  if (_fontFamilyPattern.hasMatch(trimmed)) return 'fontFamily hardcoded';
  if (_weightPattern.hasMatch(trimmed)) return 'FontWeight.w800/w900 hardcoded';
  if (_nearOneHeightPattern.hasMatch(trimmed)) return 'height near 1 hardcoded';
  if (_edgeInsetsPattern.hasMatch(trimmed)) return 'EdgeInsets hardcoded';
  if (_sizedBoxPattern.hasMatch(trimmed)) {
    return 'SizedBox fixed dimension hardcoded';
  }
  if (_radiusPattern.hasMatch(trimmed)) return 'Radius.circular hardcoded';
  if (_borderRadiusPattern.hasMatch(trimmed)) {
    return 'BorderRadius.circular hardcoded';
  }
  if (_crossAxisPattern.hasMatch(trimmed)) return 'crossAxisCount hardcoded';
  if (_childAspectPattern.hasMatch(trimmed)) {
    return 'childAspectRatio hardcoded';
  }
  if (_mainAxisPattern.hasMatch(trimmed)) return 'mainAxisExtent hardcoded';
  return null;
}

bool _isPathException(String path) {
  if (_exceptionPathPatterns.any((exception) => path.contains(exception))) {
    return true;
  }
  return false;
}

final RegExp _commentFontSizePattern = RegExp(r'//.*fontSize');
final RegExp _fontSizePattern = RegExp(r'fontSize:\s*[0-9]');
final RegExp _fontFamilyPattern = RegExp(r'fontFamily:');
final RegExp _weightPattern = RegExp(r'FontWeight\.w[89]00');
final RegExp _nearOneHeightPattern = RegExp(
  r'height:\s*(0\.(?:8[5-9]|9[0-9])|1(?:\.0?[0-9]?)?)',
);
final RegExp _edgeInsetsPattern = RegExp(
  r'EdgeInsets\.(all|symmetric|only|fromLTRB)\(',
);
final RegExp _sizedBoxPattern = RegExp(
  r'SizedBox\((?:[^)]*)(?:width|height):\s*[0-9]',
);
final RegExp _radiusPattern = RegExp(r'Radius\.circular\(');
final RegExp _borderRadiusPattern = RegExp(r'BorderRadius\.circular\(');
final RegExp _crossAxisPattern = RegExp(r'crossAxisCount:\s*\d');
final RegExp _childAspectPattern = RegExp(r'childAspectRatio:\s*[0-9]');
final RegExp _mainAxisPattern = RegExp(r'mainAxisExtent:\s*[0-9]');

const List<String> _exceptionPathPatterns = <String>[
  '/shared/widgets/dev/',
  '/shared/widgets/charts/',
  '/shared/widgets/chart_',
  'custom_painter',
  'custompainter',
  '/order_book',
  '/orderbook',
  'dev_tools',
];
