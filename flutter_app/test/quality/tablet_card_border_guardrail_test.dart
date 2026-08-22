// Guardrail: Tablet Card & Border Standard (docs/02_FLUTTER_MIGRATION/
// standards/Tablet-Card-Border-Standard.md).
//
// Ratchet giống idiom i18n baseline: các vị trí vi phạm hiện hữu được ghim
// trong `tablet_card_border_baseline.txt` (khóa `path|line|rule`); test chỉ
// fail khi xuất hiện vi phạm MỚI ngoài baseline (UI tablet mới phải theo
// chuẩn ngay từ đầu), và khi baseline còn entry đã biến mất (đã sửa/xóa →
// dọn baseline để nợ chỉ được giảm).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _baselinePath = 'test/quality/tablet_card_border_baseline.txt';

/// Sanctioned tint steps — see the standard (subtle .12 / standard .22 /
/// strong .34).
const _sanctionedTints = <String>{'.12', '.22', '.34', '0.12', '0.22', '0.34'};

final _rawBorderRe = RegExp(r'Border\.all\(|\bBorderSide\s*\(');
final _borderColorTintRe = RegExp(
  r'borderColor:\s*[^\n]+?\.withValues\(\s*alpha:\s*(\d*\.?\d+)\s*\)',
);
final _literalRadiusRe = RegExp(
  r'BorderRadius\.circular\(|\bRadius\.circular\(',
);

void main() {
  test('tablet card border debt only shrinks (ratchet vs baseline)', () {
    final current = _scanViolations();
    final baseline = _loadBaseline();

    final newViolations = current.difference(baseline).toList()..sort();
    expect(
      newViolations,
      isEmpty,
      reason:
          'Vi phạm MỚI ngoài baseline Tablet Card & Border Standard:\n'
          '${newViolations.join('\n')}\n\n'
          'UI tablet mới phải dùng VitCard + token chuẩn (xem '
          'Tablet-Card-Border-Standard.md). KHÔNG thêm entry vào baseline.',
    );

    final staleEntries = baseline.difference(current).toList()..sort();
    expect(
      staleEntries,
      isEmpty,
      reason:
          'Baseline còn entry đã biến mất (nợ đã trả):\n'
          '${staleEntries.join('\n')}\n\n'
          'Chạy `dart run tool/tablet_card_border_audit.dart '
          '--regen-baseline` để dọn.',
    );
  });

  test('tablet card border audit artifact is current', () {
    final result = Process.runSync(_dartExecutable(), [
      'run',
      'tool/tablet_card_border_audit.dart',
      '--check',
    ]);
    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/tablet_card_border_audit.dart` from flutter_app/.',
    );
  });
}

Set<String> _scanViolations() {
  final violations = <String>{};
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
      if (_rawBorderRe.hasMatch(line)) {
        violations.add('$rel|${i + 1}|R1-raw-border');
        continue;
      }
      final tint = _borderColorTintRe.firstMatch(line);
      if (tint != null) {
        if (!_sanctionedTints.contains(tint.group(1)!.trimLeft())) {
          violations.add('$rel|${i + 1}|R2-adhoc-tint(${tint.group(1)})');
        }
        continue;
      }
      if (_literalRadiusRe.hasMatch(line)) {
        violations.add('$rel|${i + 1}|R3-literal-radius');
      }
    }
  }
  return violations;
}

Set<String> _loadBaseline() {
  final file = File(_baselinePath);
  expect(file.existsSync(), isTrue, reason: 'Missing $_baselinePath');
  return file
      .readAsLinesSync()
      .where((line) => line.isNotEmpty && !line.startsWith('#'))
      .toSet();
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
