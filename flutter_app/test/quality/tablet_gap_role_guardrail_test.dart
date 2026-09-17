// Guardrail: Tablet-Spacing-Gutter-Standard — ROLE của khoảng cách
// (Rule 1 + Rule 6), scanner tool/tablet_gap_role_audit.dart.
//
// Khóa 6 lớp lỗi role mà tablet_gap_12_guardrail (chỉ whitelist token)
// không phủ: R1 card-sibling phải 12, R2 hero padding 24, R3 Wrap micro 4,
// R4 label→control 8, R5 gap giữa 2 Expanded ≥ 8, R6 Column trần chứa ≥2
// khối kề nhau không SizedBox/VitPageSection (dính 0dp — bug SC-218
// 2026-09-18).
//
// Ratchet path|rule|count qua test/quality/tablet_gap_role_baseline.txt
// (CHỈ ĐƯỢC GIẢM — nợ module ngoài predictions trả dần). Module
// predictions là chuẩn mực: 0 vi phạm, khóa tuyệt đối.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Gap-Role-Audit.csv';

void main() {
  test('tablet gap role artifact is current and baseline holds', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/tablet_gap_role_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/tablet_gap_role_audit.dart` from flutter_app/ '
          'và commit artifact + baseline cùng code.',
    );
  });

  test('predictions tablet giữ 0 vi phạm gap-role (chuẩn mực module)', () {
    final artifact = File(_artifactPath);
    expect(
      artifact.existsSync(),
      isTrue,
      reason: 'Chạy audit để sinh artifact.',
    );
    final offending = artifact
        .readAsLinesSync()
        .where(
          (line) => line.contains('features/predictions/') && line.isNotEmpty,
        )
        .toList();
    expect(
      offending,
      isEmpty,
      reason:
          'Module predictions là chuẩn mực gap-role (sweep 2026-09-16 = 0). '
          'Mỗi vi phạm mới phải sửa theo role, không được đưa vào baseline:\n'
          '${offending.join('\n')}',
    );
  });
}

String _dartExecutable() {
  final executable = Platform.resolvedExecutable.replaceAll('\\', '/');
  if (normalizedEndsWith(executable, '/dart.exe') ||
      normalizedEndsWith(executable, '/dart')) {
    return executable;
  }

  const cacheMarker = '/flutter/bin/cache/';
  final cacheIndex = executable.indexOf(cacheMarker);
  if (cacheIndex >= 0) {
    final cacheRoot = executable.substring(0, cacheIndex + cacheMarker.length);
    return '${cacheRoot}dart-sdk/bin/'
        '${Platform.isWindows ? 'dart.exe' : 'dart'}';
  }

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    return '$flutterRoot/bin/cache/dart-sdk/bin/dart';
  }
  return 'dart';
}

bool normalizedEndsWith(String value, String suffix) => value.endsWith(suffix);
