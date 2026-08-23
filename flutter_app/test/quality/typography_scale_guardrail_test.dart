// Guardrail: Typography Standard (docs/02_FLUTTER_MIGRATION/standards/
// Typography-Standard.md) — Rule 2.
//
// Khóa bất biến của thang chữ trong lib/app/theme/app_text_styles.dart:
// mọi style nhóm Money/figures (amount*/numeric*) PHẢI chứa
// FontFeature.tabularFigures — cột số tài chỉnh từng tick không được rung
// ngang. Style mới thuộc nhóm này mà quên tabularFigures fail CI ngay.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _tokenFile = 'lib/app/theme/app_text_styles.dart';
final _styleDeclRe = RegExp(
  r'static const TextStyle (amount\w*|numeric\w*) = TextStyle\(',
);

void main() {
  test('mọi style amount*/numeric* đều render tabular figures', () {
    final source = File(_tokenFile).readAsStringSync();
    expect(source, isNotEmpty, reason: 'Không tìm thấy $_tokenFile');

    final failures = <String>[];
    var checked = 0;
    for (final match in _styleDeclRe.allMatches(source)) {
      checked++;
      // Block = từ tên style đến đóng `);` đầu tiên sau đó.
      final blockEnd = source.indexOf(');', match.end);
      final block = source.substring(match.end, blockEnd);
      if (!block.contains('tabularFigures')) {
        failures.add(match.group(1)!);
      }
    }

    // Scale phải còn nguyên nhóm numeric — không ai xóa nhầm cả nhóm.
    expect(
      checked,
      greaterThan(14),
      reason: 'Nhóm numeric style quá ít — thang chữ có thể bị xóa nhầm.',
    );

    expect(
      failures,
      isEmpty,
      reason:
          'Style tài chính thiếu tabularFigures (chuẩn Typography Rule 2):\n'
          '${failures.join(', ')}\n\n'
          'Mọi cột giá/số dư/PnL phải dùng figure cố định — thêm '
          '`fontFeatures: tabularFigures` vào style trong app_text_styles.dart.',
    );
  });
}
