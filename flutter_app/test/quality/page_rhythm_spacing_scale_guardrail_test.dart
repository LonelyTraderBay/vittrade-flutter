// Origin: 9abb7118 (2026-07-18) - feat(gd3-d): golden 4 module + tach 2 guardrail lon + tool duplicate-widget — dong Cum D GD3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation files do not use legacy x5-x7 vertical spacing', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final content = entity.readAsStringSync();
      final lines = content.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (_legacyVerticalScaleHeight.hasMatch(line) &&
            !line.contains('pageRhythm')) {
          violations.add('${entity.path}:${i + 1}: $line');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Replace legacy x5–x7 SizedBox heights with pageRhythm tokens:\n'
          '${violations.join('\n')}',
    );
  });

  test('presentation files do not use raw x3/x4 vertical spacing', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      // Luật 13dp (user chốt 2026-08-31): AppSpacing.x4 (13dp) raw là GIÁ
      // TRỊ PHÁP ĐỊNH cho mọi khe dọc trên tablet presentation — được
      // phép ở đó (khóa bởi tablet_gap_13_guardrail_test); phone/web vẫn
      // phải dùng token pageRhythm*.
      final law13Tablet =
          normalized.contains('/presentation/tablet/') ||
          normalized.contains('/presentation/widgets/tablet/');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (law13Tablet && line.contains('AppSpacing.x4')) continue;
        if (_legacyX34PlainHeight.hasMatch(line) &&
            !line.contains('+') &&
            !line.contains('-')) {
          violations.add('${entity.path}:${i + 1}: $line');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use pageRhythm*InnerGap, pageRhythm*SectionGap, or rowGap '
          'instead of raw x3/x4:\n${violations.join('\n')}',
    );
  });

  test('presentation files do not use raw customGap Fibonacci scale', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_legacyCustomGapRawScale.hasMatch(lines[i])) {
          violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use VitPageRhythm tiers or pageRhythm*SectionGap instead of '
          'customGap: AppSpacing.x*:\n${violations.join('\n')}',
    );
  });

  test(
    'presentation files do not use compound x3/x4 rhythm SizedBox heights',
    () {
      final violations = <String>[];
      final libDir = Directory('lib/features');
      if (!libDir.existsSync()) {
        fail('lib/features not found — run from flutter_app/');
      }

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normalized = entity.path.replaceAll('\\', '/');
        if (!normalized.contains('/presentation/')) continue;
        if (normalized.contains('/dev/')) continue;

        final lines = entity.readAsStringSync().split('\n');
        for (var i = 0; i < lines.length; i++) {
          if (_legacyCompoundX34Height.hasMatch(lines[i]) &&
              !lines[i].contains('pageRhythm')) {
            violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Replace compound x3/x4 SizedBox heights with pageRhythm* tokens:\n'
            '${violations.join('\n')}',
      );
    },
  );

  test('presentation files do not use magic literal rhythm spacing', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_magicNumberRhythmSizedBox.hasMatch(lines[i])) {
          violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Replace AppSpacing.x* + digit rhythm spacing with semantic tokens:\n'
          '${violations.join('\n')}',
    );
  });

  test('presentation files do not use raw x2 vertical spacing in columns', () {
    final violations = <String>[];
    final libDir = Directory('lib/features');
    if (!libDir.existsSync()) {
      fail('lib/features not found — run from flutter_app/');
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/presentation/')) continue;
      if (normalized.contains('/dev/')) continue;

      final lines = entity.readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_legacyX2PlainHeight.hasMatch(lines[i]) &&
            !lines[i].contains('pageRhythm')) {
          violations.add('${entity.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use pageRhythmCompactInnerGap instead of raw x2 vertical spacing:\n'
          '${violations.join('\n')}',
    );
  });
}

final _legacyVerticalScaleHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*[^)]*AppSpacing\.(?:x[5-7])',
);

final _legacyX34PlainHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.(?:x3|x4)\b',
);

final _legacyCustomGapRawScale = RegExp(r'customGap:\s*AppSpacing\.(x[1-7])\b');

final _legacyCompoundX34Height = RegExp(
  r'SizedBox\s*\(\s*height:\s*[^)]*AppSpacing\.(?:x3|x4)[^)]*[+\-][^)]*\)',
);

final _magicNumberRhythmSizedBox = RegExp(
  r'SizedBox\s*\(\s*(?:height|width):\s*[^)]*AppSpacing\.x[0-7]\s*\+\s*[0-9]',
);

final _legacyX2PlainHeight = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.x2\b',
);
