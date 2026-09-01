// LUẬT BASE-8-DERIVED/12DP TABLET (user chốt 2026-09-01): gap khối
// DỌC VÀ NGANG trên surface tablet là 12dp — KHÔNG baseline. Khe
// micro/item 4/8dp vẫn hợp lệ theo Role Scale và được phân biệt bằng token
// role. "Khoảng trống" = mọi SizedBox KHÔNG có child (đứng giữa các phần tử
// làm khe). SizedBox CÓ child là kích thước của phần tử (metric), không
// thuộc luật. Inset padding, extent hàng dữ liệu, kích thước control/icon/
// viền không thuộc luật (không phải khe giữa các phần tử).
//
// Gap khối hợp lệ: 12 (TabletSpacingTokens.x4 / cardGap /
// pageRhythmStandardSectionGap / token module bị lock giá trị 12) — cộng các
// số không phải khoảng trắng (0, hairline, border) và double.infinity.
// Compact/item/micro gap là role khác (8/4), được phép qua token role tương
// ứng nhưng không được dùng thay gap khối.
//
// Buộc theo 2 lớp: guardrail này (nguồn, zero-tolerance) + layout-lock
// RenderBox đo khoảng thật trên từng trang (bản mẫu
// test/features/trade/trade_terminal_gap_12_lock_test.dart).
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

const _scannedDirs = ['lib/app/shell/tablet', 'lib/features'];

/// Biểu thức `height:`/`width:` hợp lệ của một SizedBox-khe.
/// Từ 2026-09-01 file tablet đọc `TabletSpacingTokens` (namespace tách
/// riêng) — whitelist nhận cả hai namespace với cùng bộ tên.
final _allowedGapExpr = RegExp(
  r'^(TabletSpacingTokens\.x1|TabletSpacingTokens\.x2|TabletSpacingTokens\.x3|TabletSpacingTokens\.x4'
  r'|TabletSpacingTokens\.cardGap'
  r'|(?:AppSpacing|TabletSpacingTokens)\.zero|double\.infinity'
  r'|(?:AppSpacing|TabletSpacingTokens)\.dividerHairline'
  r'|(?:AppSpacing|TabletSpacingTokens)\.hairlineStroke'
  r'|(?:AppSpacing|TabletSpacingTokens)\.borderWidth'
  r'|TradeSpacingTokens\.tradeTerminalGutter'
  r'|TabletSpacingTokens\.pageRhythmStandardSectionGap'
  r'|TabletSpacingTokens\.pageRhythmFormSectionGap'
  r'|TabletDashboardWidths\.columnGutter'
  r'|TabletDashboardWidths\.blockVerticalGap)$',
);

final _sizedBoxStart = RegExp(r'SizedBox\s*\(');

bool _isTabletPresentationPath(String path) {
  final p = path.replaceAll('\\', '/');
  if (p.startsWith('lib/app/shell/tablet/')) return true;
  if (p == 'lib/shared/layout/vit_navigation_rail.dart') return true;
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
          // dart format có co dấu dòng giữa tên namespace và member —
          // chuẩn hoá bỏ mọi khoảng trắng trước khi so khớp whitelist.
          final expr = am.group(1)!.replaceAll(RegExp(r'\s+'), '');
          final literal = double.tryParse(expr);
          final ok = literal != null
              ? (literal == 0 || literal == 4 || literal == 8 || literal == 12)
              : _allowedGapExpr.hasMatch(expr);
          if (!ok) {
            violations.add(
              '$path — SizedBox khe $axis: $expr (phải là 12: '
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
  test(
    'Luật Role Scale (block12/item8/micro4): ZERO khe ngoài scale trong tablet',
    () {
      final violations = _scanCurrent();
      expect(violations, isEmpty, reason: violations.take(10).join('\n'));
    },
  );

  test('Luật 12dp: self-test', () {
    expect(_allowedGapExpr.hasMatch('TabletSpacingTokens.x4'), isTrue);
    expect(_allowedGapExpr.hasMatch('TabletSpacingTokens.cardGap'), isTrue);
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

  test('Luật 12dp: section tablet (label/title) tự khai innerGap = 12', () {
    final violations = <String>[];
    for (final root in _scannedDirs) {
      final dir = Directory(root);
      if (!dir.existsSync()) continue;
      for (final entity in dir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll('\\', '/');
        if (!_isTabletPresentationPath(path)) continue;
        final src = File(entity.path).readAsStringSync();
        for (final m in RegExp(
          r'\b(?:VitPageSection|VitTradeSection)\s*\(',
        ).allMatches(src)) {
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
          // label:/title: phải là tham số TRỰC TIẾP của section (depth 1)
          // — title: của card con không tính.
          final openParen = span.indexOf('(');
          var argDepth = 0;
          final argChars = StringBuffer();
          for (var i = openParen; i < span.length; i++) {
            final c = span[i];
            if (c == '(') {
              argDepth++;
              if (argDepth == 1) continue;
            } else if (c == ')') {
              argDepth--;
              if (argDepth == 0) break;
            }
            if (argDepth == 1) argChars.write(c == '\n' ? ' ' : c);
          }
          final topLevelArgs = argChars.toString();
          final ownsLabel = RegExp(
            r'(?:^|,)\s*(?:label|title):\s*',
          ).hasMatch(topLevelArgs);
          if (!ownsLabel) continue;
          if (!span.contains('innerGap: TabletSpacingTokens.x4')) {
            violations.add(
              '$path — ${src.substring(m.start, m.start + 40)}… thiếu '
              'innerGap 12 (khoảng nhãn → nội dung tablet = 12)',
            );
          }
        }
        // bottomGap trực tiếp (label → nội dung) cũng phải 12.
        for (final m in RegExp(r'bottomGap:\s*([^,)]+)').allMatches(src)) {
          final expr = m.group(1)!.replaceAll(RegExp(r'\s+'), '');
          final literal = double.tryParse(expr);
          final ok = literal != null
              ? literal == 12
              : (expr == 'TabletSpacingTokens.x4' ||
                    expr == 'TabletSpacingTokens.cardGap' ||
                    expr ==
                        'TabletSpacingTokens.pageRhythmStandardSectionGap' ||
                    expr == 'TabletSpacingTokens.pageRhythmFormSectionGap');
          if (!ok) {
            violations.add('$path — bottomGap: $expr phải là 12');
          }
        }
      }
    }
    expect(violations, isEmpty, reason: violations.take(8).join('\n'));
  });
}
