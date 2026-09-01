import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';

/// Bảng giao dịch gần đây (tape) của terminal: cuộn NỘI BỘ, 24 dòng từ
/// fixture sinh deterministic — mật độ chuẩn sàn lớn. Hướng mua/bán thể
/// hiện bằng MŨI TÊN ▲▼ kèm màu (không chỉ phụ thuộc màu — a11y).
class TradeTerminalTapePanel extends StatelessWidget {
  const TradeTerminalTapePanel({super.key, required this.trades});

  final List<TradeTapePrint> trades;

  @override
  Widget build(BuildContext context) {
    return TradeTerminalPanel(
      panelKey: TradeTabletKeys.tapePanel,
      label: 'GIAO DỊCH',
      fill: true,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalPanelBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TradeTapeHeader(),
            Expanded(
              child: trades.isEmpty
                  ? Center(
                      child: Padding(
                        padding: TabletSpacingTokens.contentInsets,
                        child: Text(
                          'Chưa có giao dịch gần đây',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      // Luật Base-8-derived 12dp: hàng cuối → viền dưới khi cuộn tới đáy.
                      padding: TradeSpacingTokens
                          .tradeTerminalPanelBodyBottomPadding,
                      itemCount: trades.length,
                      itemExtent:
                          TradeSpacingTokens.tradeTerminalTradeRowExtent,
                      itemBuilder: (context, index) => _TradeTapeRow(
                        key: TradeTabletKeys.tapeRow(index),
                        trade: trades[index],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeTapeHeader extends StatelessWidget {
  const _TradeTapeHeader();

  @override
  Widget build(BuildContext context) {
    // Luật Base-8-derived 12dp: không padding dọc — khoảng nhãn → header cột đã do label
    // padding bottom 12 đảm nhiệm; chỉ inset ngang như hàng dữ liệu.
    return Padding(
      padding: TradeSpacingTokens.tradeTerminalColumnHeaderPadding,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            child: Text(
              'Khối lượng',
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              'Thời gian',
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeTapeRow extends StatelessWidget {
  const _TradeTapeRow({super.key, required this.trade});

  final TradeTapePrint trade;

  String get _priceLabel {
    final arrow = trade.isBuy ? '▲' : '▼';
    final price = trade.price.toStringAsFixed(2);
    return '$arrow $price';
  }

  @override
  Widget build(BuildContext context) {
    final color = trade.isBuy ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TradeSpacingTokens.tradeTerminalBottomRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              _priceLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              trade.amount.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              trade.time,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
