// Guardrail: Motion Standard (docs/02_FLUTTER_MIGRATION/standards/
// Motion-Standard.md) — phase 1: tablet surface, absolute.
//
// Khóa TUYỆT ĐỐI (không baseline, không ratchet): bề mặt tablet khởi tạo ở 0
// literal motion (2026-08-23 — 2 literal 180ms cuối đã migrate sang
// AppMotion.element) và phải giữ nguyên — `duration: Duration(<literal>)`
// hay `Curves.` tay trong file tablet đều fail CI ngay; thời gian/đường cong
// lấy từ token AppMotion. Mock/network delay (`Future.delayed`) không phải
// motion và không bị bắt.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _literalDurationRe = RegExp(r'[dD]uration:\s*(?:const\s+)?Duration\s*\(');
final _literalCurveRe = RegExp(r'\bCurves\.');

void main() {
  test('tablet files contain zero literal motion (absolute lock)', () {
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final fileName = normalized.split('/').last;
      final isTabletSurface =
          normalized.contains('/tablet/') || fileName.contains('tablet');
      if (!isTabletSurface || !normalized.endsWith('.dart')) continue;
      // Token layer exemption — AppMotion is the sanctioned home.
      if (normalized.contains('/app/theme/')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        final rel = normalized.replaceFirst('lib/', '');
        if (_literalDurationRe.hasMatch(line)) {
          violations.add('$rel|${i + 1}|M1-literal-duration');
        }
        if (_literalCurveRe.hasMatch(line)) {
          violations.add('$rel|${i + 1}|M2-literal-curve');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Literal motion trong file tablet (chuẩn Motion — khóa tuyệt đối):'
          '\n${violations.join('\n')}\n\n'
          'Dùng token AppMotion.* (feedback/element/surface/scene, '
          'enter/emphasized/exit) thay cho Duration/Curves literal.',
    );
  });

  test('motion audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/motion_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/motion_audit.dart` from flutter_app/.',
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
