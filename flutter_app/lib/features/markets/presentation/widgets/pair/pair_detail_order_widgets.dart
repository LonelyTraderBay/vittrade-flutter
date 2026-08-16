part of '../../phone/pages/pair/pair_detail_page.dart';

class _OrderBookPanel extends StatelessWidget {
  const _OrderBookPanel({required this.snapshot});

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
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          Expanded(
            child: Text(
              level.cumulative.toStringAsFixed(3),
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradesPanel extends StatelessWidget {
  const _TradesPanel({required this.trades});

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
          Expanded(child: Text('Giá', style: _tableHeaderStyle())),
          Expanded(
            child: Text(
              'Khối lượng',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
          Expanded(
            child: Text(
              'Thời gian',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
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
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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
