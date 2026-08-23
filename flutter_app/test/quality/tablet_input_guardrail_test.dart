// Guardrail: Tablet Input Modality Standard (docs/02_FLUTTER_MIGRATION/
// standards/Tablet-Input-Standard.md).
//
// Khóa TUYỆT ĐỐI (không baseline, không ratchet): bề mặt tablet khởi tạo ở 0
// raw hover/focus code (2026-08-23) và phải giữ nguyên — MouseRegion/onHover
// tay, hoverColor/focusColor ngoài token AppInputStates, hay skipTraversal
// đúng trong file tablet đều fail CI ngay; trạng thái pointer/focus đến từ
// shared widgets + token AppInputStates.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _rawHoverRe = RegExp(r'\bMouseRegion\s*\(|\bonHover\s*:');
final _inputStateColorRe = RegExp(r'\b(hover|focus)Color\s*:');
final _skipTraversalRe = RegExp(r'skipTraversal\s*:\s*true');

void main() {
  test('tablet files contain zero raw input-state code (absolute lock)', () {
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      final fileName = normalized.split('/').last;
      final isTabletSurface =
          normalized.contains('/tablet/') || fileName.contains('tablet');
      if (!isTabletSurface || !normalized.endsWith('.dart')) continue;

      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        final rel = normalized.replaceFirst('lib/', '');
        if (_rawHoverRe.hasMatch(line)) {
          violations.add('$rel|${i + 1}|I1-raw-hover');
        }
        if (_inputStateColorRe.hasMatch(line) &&
            !line.contains('AppInputStates.')) {
          violations.add('$rel|${i + 1}|I2-adhoc-input-state');
        }
        if (_skipTraversalRe.hasMatch(line)) {
          violations.add('$rel|${i + 1}|I3-skip-traversal');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Raw input-state code trong file tablet (chuẩn Tablet-Input '
          '— khóa tuyệt đối):\n${violations.join('\n')}\n\n'
          'Dùng shared widgets + token AppInputStates.* thay cho '
          'MouseRegion/hoverColor/focusColor tự chế; không skipTraversal.',
    );
  });

  test('tablet input audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/tablet_input_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/tablet_input_audit.dart` from flutter_app/.',
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
