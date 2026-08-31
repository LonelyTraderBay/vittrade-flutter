import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';

/// Sổ lệnh terminal (SC-048 tablet): 12 MỨC mỗi bên với DEPTH BAR nền theo
/// lũy kế, hàng SPREAD giữa hai bên — cuộn nội bộ, mỗi hàng là dữ liệu
/// hiển thị (không phải nút). Mật độ chuẩn Bybit, khớp terminal Markets.
class TradeTerminalBookPanel extends StatelessWidget {
  const TradeTerminalBookPanel({super.key, required this.orderBook});

  final TradeOrderBook orderBook;

  @override
  Widget build(BuildContext context) {
    final asks = orderBook.asks.take(12).toList();
    final bids = orderBook.bids.take(12).toList();
    if (asks.isEmpty || bids.isEmpty) {
      return const TradeTerminalPanel(
        panelKey: TradeTabletKeys.bookPanel,
        label: 'SỔ LỆNH',
        fill: true,
        child: Center(
          child: Padding(
            padding: TabletSpacingTokens.contentInsets,
            child: Text(
              'Chưa có dữ liệu sổ lệnh',
              style: AppTextStyles.micro,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    // Lũy kế từ mức tốt nhất ra ngoài — thước depth bar của mỗi hàng.
    final bidCumulative = <double>[];
    var running = 0.0;
    for (final level in bids) {
      running += level.amount;
      bidCumulative.add(running);
    }
    final askCumulative = <double>[];
    running = 0.0;
    for (final level in asks) {
      running += level.amount;
      askCumulative.add(running);
    }
    final maxCumulative = [
      ...askCumulative,
      ...bidCumulative,
    ].reduce((a, b) => a > b ? a : b);
    final spread = asks.first.price - bids.first.price;

    return TradeTerminalPanel(
      panelKey: TradeTabletKeys.bookPanel,
      label: 'SỔ LỆNH',
      fill: true,
      trailing: Text(
        'Chênh lệch ${spread.toStringAsFixed(2)}',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalPanelBodyPadding,
        child: SingleChildScrollView(
          // Luật 13dp: hàng cuối → viền dưới.
          padding: TradeSpacingTokens.tradeTerminalPanelBodyBottomPadding,
          child: Column(
            children: [
              for (var i = asks.length - 1; i >= 0; i--)
                _TradeTerminalBookRow(
                  key: TradeTabletKeys.bookRow('ask', i),
                  level: asks[i],
                  cumulative: askCumulative[i],
                  maxCumulative: maxCumulative,
                  side: TradeOrderSide.sell,
                ),
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
              for (var i = 0; i < bids.length; i++)
                _TradeTerminalBookRow(
                  key: TradeTabletKeys.bookRow('bid', i),
                  level: bids[i],
                  cumulative: bidCumulative[i],
                  maxCumulative: maxCumulative,
                  side: TradeOrderSide.buy,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Một mức giá: depth bar nền (ColoredBox + FractionallySizedBox — không
/// BoxDecoration) + giá/khối lượng/lũy kế tabular.
class _TradeTerminalBookRow extends StatelessWidget {
  const _TradeTerminalBookRow({
    super.key,
    required this.level,
    required this.cumulative,
    required this.maxCumulative,
    required this.side,
  });

  final TradeBookLevel level;
  final double cumulative;
  final double maxCumulative;
  final TradeOrderSide side;

  @override
  Widget build(BuildContext context) {
    final color = side == TradeOrderSide.buy ? AppColors.buy : AppColors.sell;
    final widthFactor = (cumulative / (maxCumulative + 1e-9)).clamp(0.0, 1.0);
    return SizedBox(
      height: TradeSpacingTokens.tradeTerminalBookRowExtent,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          FractionallySizedBox(
            widthFactor: widthFactor,
            child: ColoredBox(color: color.withValues(alpha: .10)),
          ),
          Padding(
            padding: TradeSpacingTokens.tradeTerminalBookRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    level.price.toStringAsFixed(2),
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    level.amount.toStringAsFixed(3),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    cumulative.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
