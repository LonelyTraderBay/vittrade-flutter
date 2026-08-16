// Origin: 573c8664 (2026-06-01) - refactor: hoàn thiện tái cấu trúc Flutter enterprise hậu E900
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter_test/flutter_test.dart';

import 'product_copy_guardrail_test_utils.dart';

void main() {
  group('product copy guardrails - Trade', () {
    test('Trade copy high-risk flow keeps suitability review roles', () {
      final source = asciiFold(
        [
          'lib/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart',
          'lib/features/trade_copy/presentation/widgets/phone/copy_trading_hero.dart',
          'lib/features/trade_copy/presentation/widgets/phone/copy_trading_list.dart',
          'lib/features/trade_copy/presentation/widgets/phone/copy_trading_metrics_common.dart',
          'lib/features/trade_copy/presentation/phone/pages/flow/copy_confirmation_page.dart',
          'lib/features/trade_copy/presentation/widgets/flow/copy_confirmation_page_sections.dart',
          'lib/features/trade_copy/presentation/widgets/flow/copy_confirmation_page_common.dart',
          'lib/features/trade_terminal/presentation/controllers/trade_controller_models.dart',
        ].map(readSource).join('\n'),
      );

      final unsafe = RegExp(
        r'casino|jackpot|risk-free|guaranteed profit|no risk',
        caseSensitive: false,
      );
      expect(unsafe.allMatches(source), isEmpty);

      final roles = {
        'risk': [RegExp(r'\brisk\b|rui ro', caseSensitive: false)],
        'suitability': [
          RegExp(r'suitability|risk tolerance|phu hop', caseSensitive: false),
        ],
        'amount': [
          RegExp(r'copyCapital|copy amount|so von', caseSensitive: false),
        ],
        'limit': [RegExp(r'limit|20%|gioi han', caseSensitive: false)],
        'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
        'confirm': [RegExp(r'confirm|consent|xac nhan', caseSensitive: false)],
      };

      for (final entry in roles.entries) {
        final hasRole = entry.value.any((pattern) => pattern.hasMatch(source));
        expect(
          hasRole,
          isTrue,
          reason: 'Trade copy high-risk flow is missing ${entry.key} copy.',
        );
      }
    });

    test('Futures and margin flows keep leverage safety roles', () {
      final targets = [
        HighRiskCopyTarget(
          path:
              'lib/features/trade/presentation/phone/pages/futures/futures_page.dart',
          paths: [
            'lib/features/trade/presentation/phone/pages/futures/futures_page.dart',
            'lib/features/trade/presentation/widgets/futures/futures_page_state.dart',
            'lib/features/trade/presentation/widgets/futures/futures_page_form_controls.dart',
          ],
          roles: {
            'risk': [RegExp(r'\brisk\b|rui ro', caseSensitive: false)],
            'margin': [RegExp(r'\bmargin\b|ky quy', caseSensitive: false)],
            'leverage': [
              RegExp(r'\bleverage\b|don bay|[0-9]+x', caseSensitive: false),
            ],
            'liquidation': [
              RegExp(r'liquidation|liquid|thanh ly', caseSensitive: false),
            ],
            'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
            'preview': [RegExp(r'\bpreview\b|review', caseSensitive: false)],
            'confirm': [
              RegExp(r'confirm|receipt|submit', caseSensitive: false),
            ],
          },
        ),
        HighRiskCopyTarget(
          path:
              'lib/features/trade/presentation/phone/pages/margin/margin_trading_page.dart',
          paths: [
            'lib/features/trade/presentation/phone/pages/margin/margin_trading_page.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_simple_form.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_common.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_reserved.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_shared_helpers.dart',
            'lib/features/trade/presentation/phone/pages/margin/margin_trading_hub_page.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_hub_widgets.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_hub_hero_nav.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_hub_cards.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_order_summary.dart',
            'lib/features/trade/presentation/widgets/margin/margin_trading_positions_orders.dart',
          ],
          roles: {
            'risk': [RegExp(r'\brisk\b|rui ro', caseSensitive: false)],
            'limit': [RegExp(r'\blimit\b|gioi han', caseSensitive: false)],
            'margin': [RegExp(r'\bmargin\b|ky quy', caseSensitive: false)],
            'leverage': [
              RegExp(r'\bleverage\b|don bay|[0-9]+x', caseSensitive: false),
            ],
            'liquidation': [
              RegExp(r'liquidation|liquid|thanh ly', caseSensitive: false),
            ],
            'fee': [RegExp(r'\bfee\b|phi', caseSensitive: false)],
            'preview': [RegExp(r'\bpreview\b|review', caseSensitive: false)],
          },
        ),
      ];

      final unsafe = RegExp(
        r'casino|jackpot|risk-free|guaranteed profit|no risk',
        caseSensitive: false,
      );

      for (final target in targets) {
        final source = asciiFold(target.sourcePaths.map(readSource).join('\n'));
        expect(unsafe.allMatches(source), isEmpty, reason: target.path);
        for (final entry in target.roles.entries) {
          final hasRole = entry.value.any(
            (pattern) => pattern.hasMatch(source),
          );
          expect(
            hasRole,
            isTrue,
            reason: '${target.path} is missing ${entry.key} safety copy.',
          );
        }
      }
    });
  });
}
