// LUẬT 13dp (user chốt 2026-08-31, mở rộng chiều cùng ngày): mọi khoảng
// trống DỌC VÀ NGANG trên toàn bộ surface tablet đều là 13dp — KHÔNG
// NGOẠI LỆ, KHÔNG baseline. "Khoảng trống" = mọi SizedBox KHÔNG có child
// (đứng giữa các phần tử làm khe). SizedBox CÓ child là kích thước của
// phần tử (metric), không thuộc luật. Inset padding, extent hàng dữ
// liệu, kích thước control/icon/viền không thuộc luật (không phải khe
// giữa các phần tử).
//
// Giá trị hợp lệ: 13 (AppSpacing.x4 / cardGap / sectionGapCompact /
// token module bị lock giá trị 13) — cộng các số không phải khoảng trắng
// (0, hairline, border) và double.infinity.
//
// Buộc theo 2 lớp: guardrail này (nguồn, zero-tolerance) + layout-lock
// RenderBox đo khoảng thật trên từng trang (bản mẫu
// test/features/trade/trade_terminal_gap_13_lock_test.dart).
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

const _scannedDirs = ['lib/app/shell/tablet', 'lib/features'];

/// Biểu thức `height:`/`width:` hợp lệ của một SizedBox-khe.
final _allowedGapExpr = RegExp(
  r'^(AppSpacing\.x4|AppSpacing\.cardGap|AppSpacing\.sectionGapCompact'
  r'|AppSpacing\.zero|double\.infinity|AppSpacing\.dividerHairline'
  r'|AppSpacing\.hairlineStroke|AppSpacing\.borderWidth'
  r'|TradeSpacingTokens\.tradeTerminalGutter'
  // Token role giá trị đúng 13 (không phải khe mới, chỉ cách gọi tên).
  r'|AppSpacing\.pageRhythmStandardSectionGap'
  r'|AppSpacing\.pageRhythmRelaxedInnerGap'
  r'|TabletDashboardWidths\.columnGutter'
  r'|TabletDashboardWidths\.blockVerticalGap)$',
);

final _sizedBoxStart = RegExp(r'SizedBox\s*\(');

bool _isTabletPresentationPath(String path) {
  final p = path.replaceAll('\\', '/');
  if (p.startsWith('lib/app/shell/tablet/')) return true;
  if (!p.startsWith('lib/features/')) return false;
  return p.contains('/presentation/tablet/') ||
      p.contains('/presentation/widgets/tablet/');
}

/// Trả về span `SizedBox(...)` cân bằng ngoặc kèm cờ không-child.
List<(String, bool)> _sizedBoxSpans(String src) {
  final spans = <(String, bool)>[];
  for (final m in _sizedBoxStart.allMatches(src)) {
    var depth = 0;
    var end = -1;
    for (var i = m.end - 1; i < src.length; i++) {
      if (src[i] == '(') depth++;
      if (src[i] == ')') {
        depth--;
        if (depth == 0) {
          end = i + 1;
          break;
        }
      }
    }
    if (end < 0) continue;
    final span = src.substring(m.start, end);
    spans.add((span, !span.contains('child')));
  }
  return spans;
}

/// Danh sách vi phạm: "file:dòng — trục expr".
List<String> _scanCurrent() {
  final violations = <String>[];
  for (final root in _scannedDirs) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll('\\', '/');
      if (!_isTabletPresentationPath(path)) continue;
      final src = File(entity.path).readAsStringSync();
      for (final (span, childless) in _sizedBoxSpans(src)) {
        if (!childless) continue;
        for (final axis in ['height', 'width']) {
          final am = RegExp(axis + r':\s*([^,)]+)').firstMatch(span);
          if (am == null) continue;
          final expr = am.group(1)!.trim();
          final literal = double.tryParse(expr);
          final ok = literal != null
              ? (literal == 0 || literal == 13)
              : _allowedGapExpr.hasMatch(expr);
          if (!ok) {
            violations.add(
              '$path — SizedBox khe $axis: $expr (phải là 13: '
              'AppSpacing.x4 / cardGap)',
            );
          }
        }
      }
    }
  }
  return violations;
}

void main() {
  test('Luật 13dp (dọc + ngang): ZERO khe SizedBox ≠ 13 trong tablet', () {
    final violations = _scanCurrent();
    expect(violations, isEmpty, reason: violations.take(10).join('\n'));
  });

  test('Luật 13dp: self-test', () {
    expect(_allowedGapExpr.hasMatch('AppSpacing.x4'), isTrue);
    expect(_allowedGapExpr.hasMatch('AppSpacing.cardGap'), isTrue);
    expect(_allowedGapExpr.hasMatch('AppSpacing.x2'), isFalse);
    expect(
      _allowedGapExpr.hasMatch('VitDensity.compact.verticalSpace'),
      isFalse,
    );
    expect(_allowedGapExpr.hasMatch('8'), isFalse);
    // Literal số đi qua nhánh double.tryParse — regex không cần match.
    expect(_allowedGapExpr.hasMatch('13'), isFalse);

    final spans = _sizedBoxSpans(
      'const SizedBox(height: AppSpacing.x1), '
      'SizedBox(width: 5, child: T()), '
      'SizedBox(width: AppSpacing.x4)',
    );
    expect(spans.length, 3);
    expect(spans[0].$2, isTrue); // childless
    expect(spans[1].$2, isFalse); // has child
    expect(spans[2].$2, isTrue);

    expect(
      _isTabletPresentationPath(
        'lib/features/trade/presentation/widgets/tablet/x.dart',
      ),
      isTrue,
    );
    expect(
      _isTabletPresentationPath('lib/features/trade/presentation/phone/x.dart'),
      isFalse,
    );
  });
}
