// Guardrail: Tablet Spacing & Gutter Standard (docs/02_FLUTTER_MIGRATION/
// standards/Tablet-Spacing-Gutter-Standard.md).
//
// Khóa TUYỆT ĐỐI (không baseline, không ratchet): bề mặt tablet đã đạt 0
// literal spacing (2026-08-22) và phải giữ nguyên — mọi `SizedBox` gap,
// `EdgeInsets` inset hay `thickness`/`Divider(height:)` bằng SỐ literal mới
// trong file tablet đều fail CI ngay; dùng token AppSpacing/module spacing.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _literalGapRe = RegExp(r'SizedBox\(\s*(height|width):\s*\d');
final _literalInsetRe = RegExp(
  r'EdgeInsets(?:Directional)?\.\w+\([^)]*\b\d+\.?\d*\b[^)]*\)',
);
final _literalStrokeRe = RegExp(r'thickness:\s*\d');

void main() {
  test('tablet files contain zero literal spacing (absolute lock)', () {
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final fileName = normalized.split('/').last;
      final isTabletSurface =
          normalized.contains('/tablet/') ||
          fileName.contains('tablet') ||
          normalized == 'lib/shared/layout/vit_navigation_rail.dart';
      if (!isTabletSurface || !normalized.endsWith('.dart')) continue;
      // Token files là nơi số liệu được phép sống (kể cả
      // tablet_spacing_tokens tách 2026-09-01) — scanner khóa literal
      // tại call-site, không khóa định nghĩa token.
      if (normalized.contains('/app/theme/spacing/') ||
          normalized.endsWith('/app_spacing.dart')) {
        continue;
      }

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        final rel = normalized.replaceFirst('lib/', '');
        if (_literalGapRe.hasMatch(line)) {
          violations.add('$rel|${i + 1}|S1-literal-gap');
        }
        if (_literalInsetRe.hasMatch(line)) {
          violations.add('$rel|${i + 1}|S2-literal-inset');
        }
        if (_literalStrokeRe.hasMatch(line) ||
            (line.contains('Divider(') &&
                RegExp(r'height:\s*\d').hasMatch(line))) {
          violations.add('$rel|${i + 1}|S3-literal-stroke');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Literal spacing trong file tablet (chuẩn Tablet-Spacing-Gutter '
          '— khóa tuyệt đối):\n${violations.join('\n')}\n\n'
          'Dùng token AppSpacing.* / module spacing token thay cho số literal.',
    );
  });

  test('tablet spacing audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/tablet_spacing_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/tablet_spacing_audit.dart` from flutter_app/.',
    );
  });
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
