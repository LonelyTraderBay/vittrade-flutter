// Origin: 573c8664 (2026-06-01) - refactor: hoàn thiện tái cấu trúc Flutter enterprise hậu E900
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter_test/flutter_test.dart';

import 'product_copy_guardrail_test_utils.dart';

void main() {
  group('product copy guardrails - Predictions', () {
    test('Prediction and Wallet high-risk confirmations avoid unsafe copy', () {
      final predictionRisk = readSource(
        'lib/features/predictions/presentation/phone/pages/portfolio/'
        'prediction_risk_calculator_page.dart',
      );
      expect(predictionRisk, isNot(contains('Total Bankroll')));
      expect(
        RegExp('bet size', caseSensitive: false).allMatches(predictionRisk),
        isEmpty,
      );
      expect(
        RegExp('payout', caseSensitive: false).allMatches(predictionRisk),
        isEmpty,
      );

      final tokenApproval = readSource(
        'lib/features/wallet/presentation/phone/pages/tools/'
        'wallet_token_approval_page.dart',
      );
      expect(
        RegExp('mock flow', caseSensitive: false).allMatches(tokenApproval),
        isEmpty,
      );
    });

    test('Prediction event and portfolio surfaces keep Arena boundary copy', () {
      final source = asciiFold(
        [
          'lib/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_activity_holders.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_chart.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_comments.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_common.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_detail_tabs.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_header.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_order_book.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_quick_links.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_related_arena.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_stats_position.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_trade_controls.dart',
          'lib/features/predictions/presentation/widgets/event/prediction_event_detail_trade_panel.dart',
          'lib/features/predictions/presentation/phone/pages/portfolio/predictions_portfolio_page.dart',
          'lib/features/predictions/presentation/controllers/predictions_controller.dart',
        ].map(readSource).join('\n'),
      );

      final unsafe = RegExp(
        r'casino|jackpot|risk-free|guaranteed profit|no risk',
        caseSensitive: false,
      );
      expect(unsafe.allMatches(source), isEmpty);

      final roles = {
        'positions': [RegExp(r'position|positions', caseSensitive: false)],
        'probability': [
          RegExp(r'probability|probabilityPct|chance', caseSensitive: false),
        ],
        'receipt': [RegExp(r'receipt', caseSensitive: false)],
        'rewards': [RegExp(r'rewards', caseSensitive: false)],
        'P/L': [RegExp(r'P/L|pnl', caseSensitive: false)],
        'order preview': [
          RegExp(r'Order Preview|PredictionOrderPreview|fee preview'),
        ],
        'Arena boundary': [
          RegExp(r'Arena Points only|Event context only', caseSensitive: false),
          RegExp(r'stay separate from Arena Points', caseSensitive: false),
        ],
      };

      for (final entry in roles.entries) {
        final hasRole = entry.value.any((pattern) => pattern.hasMatch(source));
        expect(
          hasRole,
          isTrue,
          reason: 'Prediction event/portfolio is missing ${entry.key} copy.',
        );
      }
    });
  });
}
