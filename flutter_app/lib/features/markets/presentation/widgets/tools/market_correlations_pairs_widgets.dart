part of '../../phone/pages/tools/market_correlations_page.dart';

class _SortChips extends StatelessWidget {
  const _SortChips({required this.sortOrder, required this.onSelected});

  final CorrelationSortOrder sortOrder;
  final ValueChanged<CorrelationSortOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          VitFilterChip(
            key: MarketCorrelationsPage.sortHighKey,
            label: 'Tương quan cao',
            active: sortOrder == CorrelationSortOrder.high,
            color: AppColors.sell,
            onTap: () => onSelected(CorrelationSortOrder.high),
            padding: MarketsSpacingTokens.marketCorrelationsSortChipPadding,
          ),
          const SizedBox(width: _corrChipGap),
          VitFilterChip(
            key: MarketCorrelationsPage.sortLowKey,
            label: 'Tương quan thấp',
            active: sortOrder == CorrelationSortOrder.low,
            color: AppColors.buy,
            onTap: () => onSelected(CorrelationSortOrder.low),
            padding: MarketsSpacingTokens.marketCorrelationsSortChipPadding,
          ),
        ],
      ),
    );
  }
}

class _PairCorrelationRow extends StatelessWidget {
  const _PairCorrelationRow({
    super.key,
    required this.rank,
    required this.pair,
    required this.timeframe,
    required this.maxValue,
  });

  final int rank;
  final CorrelationPairDraft pair;
  final MarketCorrelationTimeframe timeframe;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final value = _correlationValueFor(pair, timeframe);
    final color = _correlationColor(value);
    return Stack(
      children: [
        Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: maxValue == 0 ? 0 : value / maxValue,
            child: Material(
              color: color.withValues(alpha: .06),
              borderRadius: AppRadii.mdRadius,
            ),
          ),
        ),
        Material(
          color: AppColors.surface.withValues(alpha: .92),
          borderRadius: AppRadii.mdRadius,
          child: Padding(
            padding: MarketsSpacingTokens.marketCorrelationsPairRowPadding,
            child: Row(
              children: [
                SizedBox(
                  width: MarketsSpacingTokens.marketCorrelationsRankWidth,
                  child: Text(
                    '$rank',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                const SizedBox(
                  width: MarketsSpacingTokens.marketCorrelationsRankGap,
                ),
                _AssetDot(
                  symbol: pair.assetA,
                  color: AppAssetColors.forSymbol(pair.assetA),
                ),
                const SizedBox(
                  width: MarketsSpacingTokens.marketCorrelationsAssetDotGap,
                ),
                Text(
                  '↔',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(
                  width: MarketsSpacingTokens.marketCorrelationsAssetDotGap,
                ),
                _AssetDot(
                  symbol: pair.assetB,
                  color: AppAssetColors.forSymbol(pair.assetB),
                ),
                const SizedBox(
                  width: MarketsSpacingTokens.marketCorrelationsPairGap,
                ),
                Expanded(
                  child: Text(
                    '${pair.assetA}/${pair.assetB}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value.toStringAsFixed(2),
                      style: AppTextStyles.body.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      _correlationLabel(value),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetDot extends StatelessWidget {
  const _AssetDot({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: MarketsSpacingTokens.marketCorrelationsAssetDot / 2,
      backgroundColor: color.withValues(alpha: .18),
      child: Text(
        symbol.substring(0, 2),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
