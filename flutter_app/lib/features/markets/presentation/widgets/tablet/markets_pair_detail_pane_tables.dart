part of 'markets_pair_detail_pane.dart';

/// Bảng dữ liệu của pane phân tích cặp (part `_tables`): sổ lệnh 4 mức
/// mỗi bên + bảng giao dịch gần đây — tách khỏi `_sections` để mỗi part
/// giữ vai trò ổn định và dưới ngưỡng 600 dòng (guardrail size-debt).

/// Port tablet của `_OrderBookPanel` Phone — sổ lệnh 4 mức mỗi bên.
class MarketsPairOrderBookPanel extends StatelessWidget {
  const MarketsPairOrderBookPanel({super.key, required this.snapshot});

  final MarketPairDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairOrderPanelPadding,
      child: VitCard(
        padding: MarketsSpacingTokens.pairOrderCardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Sổ lệnh ${snapshot.pair.symbol}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Mid ${formatMarketPriceFixed2(snapshot.depth.midPrice)}',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            for (final level in snapshot.depth.asks.take(4).toList().reversed)
              _DepthRow(level: level, side: MarketOrderSide.sell),
            const Divider(
              color: AppColors.divider,
              height: AppSpacing.dividerHairline,
            ),
            for (final level in snapshot.depth.bids.take(4))
              _DepthRow(level: level, side: MarketOrderSide.buy),
          ],
        ),
      ),
    );
  }
}

class _DepthRow extends StatelessWidget {
  const _DepthRow({required this.level, required this.side});

  final MarketDepthLevel level;
  final MarketOrderSide side;

  @override
  Widget build(BuildContext context) {
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: MarketsSpacingTokens.pairDepthRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              formatMarketPriceFixed2(level.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              level.quantity.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              level.cumulative.toStringAsFixed(3),
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

/// Port tablet của `_TradesPanel` Phone — bảng giao dịch gần đây.
class MarketsPairTradesPanel extends StatelessWidget {
  const MarketsPairTradesPanel({super.key, required this.trades});

  final List<MarketRecentTrade> trades;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairOrderPanelPadding,
      child: VitCard(
        padding: MarketsSpacingTokens.pairOrderCardPadding,
        child: Column(
          children: [
            const _TradeHeader(),
            for (final trade in trades) _TradeRow(trade: trade),
          ],
        ),
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  const _TradeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairTradeHeaderPadding,
      child: Row(
        children: [
          Expanded(child: Text('Giá', style: _tableHeaderStyle)),
          Expanded(
            child: Text(
              'Khối lượng',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle,
            ),
          ),
          Expanded(
            child: Text(
              'Thời gian',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeRow extends StatelessWidget {
  const _TradeRow({required this.trade});

  final MarketRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final color = trade.side == MarketOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;
    return Padding(
      padding: MarketsSpacingTokens.pairTradeRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              formatMarketPriceFixed2(trade.price),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              trade.amount.toStringAsFixed(4),
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
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

final _tableHeaderStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);
