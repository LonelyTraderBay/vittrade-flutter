// Origin: 60a7f124 (2026-06-04) - feat: chuẩn hóa header và điều hướng Flutter
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('representative high-risk pages use shared state primitives', () {
    const targets = {
      'lib/features/trade/presentation/phone/pages/trade_page_state.dart',
      'lib/features/wallet/presentation/phone/pages/withdraw_page.dart',
      'lib/features/p2p_marketplace/presentation/widgets/hub/p2p_home_page_state.dart',
      'lib/features/earn_staking/presentation/pages/staking/staking_earn_page.dart',
      'lib/features/launchpad/presentation/pages/bridge/launchpad_bridge_order_page.dart',
      'lib/features/predictions/presentation/pages/hub/predictions_home_page.dart',
      'lib/features/predictions/presentation/pages/event/prediction_event_detail_page.dart',
      'lib/features/predictions/presentation/widgets/event/prediction_order_receipt_page_sections.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_agreement.dart',
      'lib/features/profile/presentation/pages/security_page.dart',
      'lib/features/p2p_account/presentation/pages/payment/p2p_payment_method_add_page.dart',
      'lib/features/p2p_account/presentation/pages/payment/p2p_payment_method_ownership_page.dart',
      'lib/features/p2p_account/presentation/pages/payment/p2p_payment_method_cooling_period_page.dart',
      'lib/features/trade/presentation/widgets/futures/futures_page_state.dart',
      'lib/features/trade_bots/presentation/pages/hub/trading_bots_page.dart',
      'lib/features/trade_copy/presentation/pages/hub/copy_trading_page.dart',
    };

    final missing = <String>[];
    for (final path in targets) {
      final source = File(path).readAsStringSync();
      if (!source.contains('VitHighRiskStatePanel') ||
          !source.contains('highRiskContractId')) {
        missing.add(path);
      }
    }

    expect(
      missing,
      isEmpty,
      reason:
          'P1 dark professional polish requires high-risk pages with '
          'contract metadata to use the shared high-risk state primitive.',
    );
  });
}
