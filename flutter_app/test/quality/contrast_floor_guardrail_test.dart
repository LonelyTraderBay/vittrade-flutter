// Guardrail: WCAG contrast floor cho các cặp token chữ/nền cốt lõi
// (docs/02_FLUTTER_MIGRATION/standards/Flutter-Native-Design-Standard.md —
// mục "Contrast floor").
//
// Đọc token màu literal từ lib/app/theme/app_colors.dart, tính tỷ lệ tương
// phản WCAG 2.x (relative luminance) cho danh sách cặp fg/bg đang được ghép
// thật trong UI, và fail nếu:
//   - một cặp chuẩn rơi dưới ngưỡng 4.5:1 (chữ thường) — ai đó đã đổi giá
//     token làm chữ mất khả năng đọc; hoặc
//   - một cặp trong "deviation lock" rơi dưới sàn HIỆN TẠI — nợ tương phản
//     đã biết chỉ được GIẢM (ratchet): tốt lên thì hết khỏi danh sách nợ,
//     xấu đi thì fail ngay; hoặc
//   - một tên token trong danh sách không còn resolve được — đổi tên token
//     mà quên cập nhật danh sách sẽ làm audit tự vô hiệu lặng lẽ.
//
// Ba cặp đang dưới ngưỡng WCAG được khóa công khai kèm lý do (chi tiết trong
// chuẩn): text3/surface (chữ phụ/placeholder), navCenterIcon/primary (chữ
// trắng trên CTA vàng — ứng viên nâng cấp), textDisabled/surface (chữ control
// tắt — WCAG miễn trừ, sàn chỉ chống tệ thêm).
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

const _tokenFilePath = 'lib/app/theme/app_colors.dart';

final _colorDefRe = RegExp(
  r'static const Color (\w+) = Color\((0x[0-9A-Fa-f]{8})\)',
);

/// Cặp fg/bg với ngưỡng WCAG đích; [lockedFloor] khác null = cặp đang là nợ
/// đã biết: ratio phải ≥ lockedFloor (ratchet), ngưỡng đích chỉ để báo cáo.
class _Pair {
  const _Pair(this.fg, this.bg, this.target, {this.lockedFloor, this.note});

  final String fg;
  final String bg;
  final double target;
  final double? lockedFloor;
  final String? note;

  bool get isDeviation => lockedFloor != null;
}

const _pairs = [
  // Chữ chính — mọi bề mặt thẻ/nền.
  _Pair('text1', 'bg', 4.5),
  _Pair('text1', 'surface', 4.5),
  _Pair('text1', 'surface2', 4.5),
  _Pair('text1', 'surface3', 4.5),
  // Chữ phụ (caption, meta) — bề mặt hay dùng nhất.
  _Pair('text2', 'bg', 4.5),
  _Pair('text2', 'surface', 4.5),
  _Pair('text2', 'surface2', 4.5),
  _Pair('text2', 'surface3', 4.5),
  // Màu ngữ nghĩa dùng LÀM CHỮ (giá tăng/giảm, hành động vàng).
  _Pair('primary', 'bg', 4.5),
  _Pair('primary', 'surface', 4.5),
  _Pair('buy', 'surface', 4.5),
  _Pair('sell', 'surface', 4.5),
  // Nợ đã biết — khóa sàn hiện tại, xem chuẩn để biết đường trả nợ.
  _Pair(
    'text3',
    'surface',
    4.5,
    lockedFloor: 3.6,
    note: 'chữ phụ cấp 3/placeholder — nâng text3 sáng hơn để đạt 4.5',
  ),
  _Pair(
    'navCenterIcon',
    'primary',
    4.5,
    lockedFloor: 2.6,
    note:
        'chữ trắng trên CTA vàng (onAccent/primary) — ứng viên trả nợ: '
        'chữ tối trên vàng hoặc vàng đậm hơn',
  ),
  _Pair(
    'textDisabled',
    'surface',
    4.5,
    lockedFloor: 2.85,
    note:
        'chữ control TẮT — WCAG miễn trừ cho inactive UI; sàn chỉ chống '
        'tệ thêm im lặng',
  ),
];

void main() {
  test('WCAG math matches published reference ratios', () {
    // Bộ giá trị tham chiếu của WCAG/cộng đồng, không phải số tự chế.
    void expectClose(double actual, double expected) {
      expect(
        (actual - expected).abs(),
        lessThan(0.02),
        reason: 'expected $expected, got $actual',
      );
    }

    expectClose(_contrast(0xFFFFFFFF, 0xFF000000), 21.0);
    expectClose(_contrast(0xFF767676, 0xFFFFFFFF), 4.54);
    expectClose(_contrast(0xFF767676, 0xFF000000), 4.62);
    expectClose(_contrast(0xFF888888, 0xFFFFFFFF), 3.54);
    expectClose(_contrast(0xFF10141B, 0xFF10141B), 1.0);
  });

  test('every listed pair resolves to a literal token', () {
    final tokens = _parseTokens();
    for (final pair in _pairs) {
      expect(
        tokens.containsKey(pair.fg),
        isTrue,
        reason:
            'Token "${pair.fg}" không còn là literal trong $_tokenFilePath — '
            'đổi tên/alias thì cập nhật danh sách cặp trong guardrail này '
            '(đừng để audit chết lặng).',
      );
      expect(
        tokens.containsKey(pair.bg),
        isTrue,
        reason: 'Token nền "${pair.bg}".',
      );
    }
  });

  test('core text/background token pairs meet the WCAG contrast floor', () {
    final tokens = _parseTokens();
    final failures = <String>[];
    final report = <String>[];

    for (final pair in _pairs) {
      final ratio = _contrast(tokens[pair.fg]!, tokens[pair.bg]!);
      final floor = pair.isDeviation ? pair.lockedFloor! : pair.target;
      final status = ratio >= pair.target
          ? 'ĐẠT'
          : (pair.isDeviation
                ? 'nợ (khóa sàn ${pair.lockedFloor})'
                : 'THẤT BẠI');
      report.add(
        '${pair.fg} trên ${pair.bg}: ${ratio.toStringAsFixed(2)} — '
        '$status (đích ${pair.target})'
        '${pair.note == null ? '' : ' — ${pair.note}'}',
      );
      if (ratio < floor) {
        failures.add(
          '${pair.fg} trên ${pair.bg}: ${ratio.toStringAsFixed(2)} < sàn '
          '$floor (đích WCAG ${pair.target})'
          '${pair.note == null ? '' : ' — ${pair.note}'}',
        );
      }
    }

    expect(
      failures,
      isEmpty,
      reason:
          'Tỷ lệ tương phản WCAG rơi dưới sàn (chuẩn Contrast floor — '
          'Flutter-Native-Design-Standard):\n${failures.join('\n')}\n\n'
          'Bảng đầy đủ:\n${report.join('\n')}\n\n'
          'Cặp chuẩn = đổi lại giá token cho đủ 4.5:1; cặp nợ = chỉ được '
          'sáng hơn (ratchet), không được tệ thêm.',
    );
  });
}

/// Map tên token → giá trị ARGB literal (0xAARRGGBB). Token alias
/// (`onAccent = navCenterIcon`) không match — danh sách cặp phải gọi tên
/// token literal, và test resolve sẽ bắt alias hoá.
Map<String, int> _parseTokens() {
  final file = File(_tokenFilePath);
  expect(
    file.existsSync(),
    isTrue,
    reason: 'Chạy từ flutter_app/ — không tìm thấy $_tokenFilePath.',
  );
  final tokens = <String, int>{};
  for (final match in _colorDefRe.allMatches(file.readAsStringSync())) {
    tokens[match.group(1)!] = int.parse(match.group(2)!);
  }
  return tokens;
}

double _contrast(int argbFg, int argbBg) {
  final fg = _blendOver(argbFg, argbBg);
  final l1 = _luminance(fg);
  final l2 = _luminance(argbBg);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Hòa fg lên bg theo alpha (WCAG không định nghĩa alpha; blend là cách
/// đúng ngữ nghĩa — mọi cặp hiện tại đều đục nên đây là phòng xa).
int _blendOver(int fg, int bg) {
  final fgAlpha = (fg >> 24) & 0xFF;
  if (fgAlpha == 0xFF) return fg;
  final inv = 1 - fgAlpha / 255;
  int blend(int fgChannel, int bgChannel) =>
      ((fgChannel * fgAlpha / 255) + bgChannel * inv).round();
  return 0xFF000000 |
      (blend((fg >> 16) & 0xFF, (bg >> 16) & 0xFF) << 16) |
      (blend((fg >> 8) & 0xFF, (bg >> 8) & 0xFF) << 8) |
      blend(fg & 0xFF, bg & 0xFF);
}

/// WCAG 2.x relative luminance — kênh sRGB qua hàm tuyến tính hoá 2.2-engine.
double _luminance(int argb) {
  double channel(int v) {
    final c = v / 255;
    return c <= 0.03928 ? c / 12.92 : _linearize(c);
  }

  return 0.2126 * channel((argb >> 16) & 0xFF) +
      0.7152 * channel((argb >> 8) & 0xFF) +
      0.0722 * channel(argb & 0xFF);
}

double _linearize(double c) => math.pow((c + 0.055) / 1.055, 2.4).toDouble();
