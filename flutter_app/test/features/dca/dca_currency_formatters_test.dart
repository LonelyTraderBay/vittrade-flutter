import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/phone/dca_currency_formatters.dart';

void main() {
  group('formatFullVnd', () {
    test('formats positive amounts with dot thousands separators', () {
      expect(formatFullVnd(1234567), '1.234.567');
      expect(formatFullVnd(100), '100');
    });

    test('keeps the minus sign out of the digit grouping (regression)', () {
      // Historical bug: the old dca_page_part_04.dart implementation
      // counted the leading '-' as part of the digit-grouping distance,
      // producing "-.100" instead of "-100" whenever the digit count
      // (excluding the sign) was itself a multiple of 3.
      expect(formatFullVnd(-100), '-100');
      expect(formatFullVnd(-1234567), '-1.234.567');
    });
  });

  group('formatCompactVnd', () {
    test('uses K/M/B tiers with fine-grained thresholds', () {
      expect(formatCompactVnd(500000), '500K');
      expect(formatCompactVnd(35500000), '35.50M');
      expect(formatCompactVnd(1200000000), '1.20B');
      expect(formatCompactVnd(100), '100');
    });

    test('preserves the negative sign at every tier (regression)', () {
      expect(formatCompactVnd(-500000), '-500K');
      expect(formatCompactVnd(-35500000), '-35.50M');
      expect(formatCompactVnd(-1200000000), '-1.20B');
      expect(formatCompactVnd(-100), '-100');
    });
  });
}
