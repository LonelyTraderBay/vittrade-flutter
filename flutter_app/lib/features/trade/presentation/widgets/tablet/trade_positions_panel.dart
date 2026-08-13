import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Public port of `trade_page_state.dart`'s private `_SimplePositionsList`
/// ("Tài sản của bạn") — needed because `TradeTabletPage` cannot import a
/// private class from that part file (R2). Straight duplication of
/// already-battle-tested logic, not new behavior.
class TradePositionsPanel extends StatelessWidget {
  const TradePositionsPanel({super.key, required this.positions});

  final List<TradePosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Chưa có tài sản Spot',
        message: 'Mua coin đầu tiên để bắt đầu.',
      );
    }

    final visible = positions.take(3).toList();
    return VitTradeOrderList(
      records: [
        for (final position in visible)
          VitTradeOrderRecord(
            id: position.symbol,
            symbol: position.symbol,
            sideLabel: position.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
            sideColor: position.side == TradeOrderSide.buy
                ? AppColors.buy
                : AppColors.sell,
            detail:
                '${formatTradeMoney(position.notional)} · PnL ${formatTradeMoney(position.pnl)}',
          ),
      ],
      emptyLabel: 'Chưa có tài sản Spot',
    );
  }
}
