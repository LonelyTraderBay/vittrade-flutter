// Guardrail: Motion Standard (docs/02_FLUTTER_MIGRATION/standards/
// Motion-Standard.md).
//
// Hai scope:
// - Tablet: khóa TUYỆT ĐỐI — bề mặt tablet sinh ra ở 0 literal motion
//   (2026-08-23) và phải giữ nguyên; vi phạm fail CI ngay.
// - Phone (phase 2, 2026-08-24): RATCHET — nợ hiện hữu pin trong
//   motion_phone_baseline.txt (55 entries lúc sinh), chỉ được GIẢM khi file
//   được chạm và migrate sang AppMotion; entry mới ngoài baseline fail CI.
// Mock/network delay (`Future.delayed`) không phải motion và không bị bắt.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _literalDurationRe = RegExp(r'[dD]uration:\s*(?:const\s+)?Duration\s*\(');
final _literalCurveRe = RegExp(r'\bCurves\.');

bool _isTabletSurface(String normalized) {
  final fileName = normalized.split('/').last;
  return normalized.contains('/tablet/') || fileName.contains('tablet');
}

void main() {
  test('tablet files contain zero literal motion (absolute lock)', () {
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.endsWith('.dart')) continue;
      if (!_isTabletSurface(normalized)) continue;

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

  test('phone motion debt only shrinks (ratchet vs baseline)', () {
    final baseline = File('test/quality/motion_phone_baseline.txt');
    expect(
      baseline.existsSync(),
      isTrue,
      reason:
          'Thiếu motion_phone_baseline.txt — chạy '
          '`dart run tool/motion_audit.dart --regen-baseline` từ flutter_app/.',
    );
    final pinned = baseline
        .readAsLinesSync()
        .where((line) => line.isNotEmpty && !line.startsWith('#'))
        .toSet();

    final current = <String>{};
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.endsWith('.dart')) continue;
      if (_isTabletSurface(normalized)) continue;
      // Token layer exemption — AppMotion is the sanctioned home.
      if (normalized.contains('/app/theme/')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        final rel = normalized.replaceFirst('lib/', '');
        if (_literalDurationRe.hasMatch(line)) {
          current.add('$rel|${i + 1}|M1-literal-duration');
        }
        if (_literalCurveRe.hasMatch(line)) {
          current.add('$rel|${i + 1}|M2-literal-curve');
        }
      }
    }

    final newDebt = current.difference(pinned).toList()..sort();
    expect(
      newDebt,
      isEmpty,
      reason:
          'Literal motion MỚI ngoài ratchet baseline (chuẩn Motion phase 2):\n'
          '${newDebt.join('\n')}\n\n'
          'Dùng token AppMotion.* — không bao giờ thêm nợ mới vào baseline '
          'bằng tay; nợ cũ trả khi chạm file.',
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
