// LUẬT 13dp (user chốt 2026-08-31, áp toàn dự án Tablet): mọi khoảng
// trắng DỌC thêm MỚI trong code tablet phải là 13dp (AppSpacing.x4 /
// cardGap / sectionGapCompact / token module hợp lệ — vd
// TradeSpacingTokens.tradeTerminalGutter). Guardrail ratchet: nợ cũ của
// các module port trước khi luật sinh ra được ghi trong baseline
// `baselines/tablet_vertical_gap_13_baseline.txt` (file → số chỗ); cấm
// TĂNG ở mọi file và cấm file mới mang nợ. Trả nợ khi chạm file thì cập
// nhật baseline giảm theo (giống workflow i18n vi-only).
//
// Phạm vi luật: khoảng trắng DỌC (SizedBox height dạng separator/gap).
// Không thuộc luật: inset ngang, extent hàng dữ liệu, kích thước control
// (inputHeight, buttonHeight...), border/hairline, chiều cao canvas —
// những metric đó không phải khoảng trắng giữa các khối.
//
// Buộc theo 2 lớp: guardrail này (nguồn) + layout-lock RenderBox đo
// khoảng thật trên từng trang (xem ví dụ
// test/features/trade/trade_terminal_gap_13_lock_test.dart) — module nào
// port sang luật 13 phải có test lock tương ứng.
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

const _baselinePath =
    'test/quality/baselines/tablet_vertical_gap_13_baseline.txt';

const _scannedDirs = ['lib/app/shell/tablet', 'lib/features'];

/// Biểu thức `SizedBox(height: …)` hợp lệ luật 13dp (hoặc metric không
/// phải khoảng trắng).
final _allowedHeightExpr = RegExp(
  r'^(AppSpacing\.x4|AppSpacing\.cardGap|AppSpacing\.sectionGapCompact'
  r'|TradeSpacingTokens\.\w+|AppSpacing\.pageRhythm\w+'
  r'|AppSpacing\.dividerHairline'
  r'|double\.infinity|AppSpacing\.hairlineStroke|AppSpacing\.borderWidth'
  r'|AppSpacing\.minTapTarget|AppSpacing\.rowPy|AppSpacing\.inputHeight'
  r'|AppSpacing\.ctaHeight|AppSpacing\.iconSm|AppSpacing\.iconMd'
  r'|AppSpacing\.iconLg'
  r'|AppSpacing\.buttonCompact|AppSpacing\.buttonStandard'
  r'|AppSpacing\.buttonHero'
  r'|AppSpacing\.contentPad|AppSpacing\.zero'
  r'|MediaQuery\.of\(context\)\.size\.height)$',
);

final _sizedBoxHeight = RegExp(r'SizedBox\s*\(\s*height:\s*([^,)]+)');

bool _isTabletPresentationPath(String path) {
  final p = path.replaceAll('\\', '/');
  if (p.startsWith('lib/app/shell/tablet/')) return true;
  if (!p.startsWith('lib/features/')) return false;
  return p.contains('/presentation/tablet/') ||
      p.contains('/presentation/widgets/tablet/');
}

Map<String, int> _scanCurrent() {
  final bad = <String, int>{};
  for (final root in _scannedDirs) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll('\\', '/');
      if (!_isTabletPresentationPath(path)) continue;
      final src = File(entity.path).readAsStringSync();
      var count = 0;
      for (final match in _sizedBoxHeight.allMatches(src)) {
        final expr = match.group(1)!.trim();
        final literal = double.tryParse(expr);
        if (literal != null) {
          if (literal == 0 ||
              literal == 1 ||
              literal == 1.5 ||
              literal == 2 ||
              literal == 13) {
            continue;
          }
          count++;
        } else if (!_allowedHeightExpr.hasMatch(expr)) {
          count++;
        }
      }
      if (count > 0) bad[path] = count;
    }
  }
  return bad;
}

Map<String, int> _readBaseline() {
  final map = <String, int>{};
  final file = File(_baselinePath);
  if (!file.existsSync()) return map;
  for (final line in file.readAsLinesSync()) {
    final parts = line.split('\t');
    if (parts.length == 2) map[parts[0]] = int.parse(parts[1]);
  }
  return map;
}

void main() {
  test('Luật 13dp: nợ SizedBox height ≠ 13 trong tablet không tăng', () {
    final current = _scanCurrent();
    final baseline = _readBaseline();
    final failures = <String>[];

    for (final entry in current.entries) {
      final allowed = baseline[entry.key] ?? 0;
      if (entry.value > allowed) {
        failures.add(
          '${entry.key}: ${entry.value} chỗ > baseline $allowed — mọi khoảng '
          'trắng dọc MỚI phải là 13dp (AppSpacing.x4 / cardGap / token '
          'module hợp lệ), xem Tablet-Spacing-Gutter-Standard.md',
        );
      }
    }

    expect(failures, isEmpty, reason: failures.take(8).join('\n'));
  });

  test('Luật 13dp: self-test regex whitelist', () {
    expect(_allowedHeightExpr.hasMatch('AppSpacing.x4'), isTrue);
    expect(_allowedHeightExpr.hasMatch('AppSpacing.cardGap'), isTrue);
    expect(
      _allowedHeightExpr.hasMatch('TradeSpacingTokens.tradeTerminalGutter'),
      isTrue,
    );
    expect(_allowedHeightExpr.hasMatch('AppSpacing.x2'), isFalse);
    expect(
      _allowedHeightExpr.hasMatch('VitDensity.compact.verticalSpace'),
      isFalse,
    );
    expect(_allowedHeightExpr.hasMatch('8'), isFalse);
    // Literal số (kể cả 13) đi qua nhánh double.tryParse, không qua regex.
    expect(_allowedHeightExpr.hasMatch('13'), isFalse);
    expect(_allowedHeightExpr.hasMatch('double.infinity'), isTrue);
    expect(
      _isTabletPresentationPath(
        'lib/features/trade/presentation/widgets/tablet/trade_terminal_book_panel.dart',
      ),
      isTrue,
    );
    expect(
      _isTabletPresentationPath(
        'lib/features/trade/presentation/phone/pages/x.dart',
      ),
      isFalse,
    );
  });
}
