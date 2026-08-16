part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _OrderBookSection extends StatelessWidget {
  const _OrderBookSection({
    required this.snapshot,
    required this.expanded,
    required this.onToggle,
  });

  final PredictionEventDetailSnapshot snapshot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final chance = snapshot.event.outcomes.first.chance / 100;
    final bestBid = snapshot.orderBook.bids.first.price;
    final bestAsk = snapshot.orderBook.asks.first.price;
    return Column(
      children: [
        VitCard(
          key: PredictionEventDetailPage.orderBookToggleKey,
          onTap: onToggle,
          variant: VitCardVariant.inner,
          padding:
              PredictionsSpacingTokens.predictionDetailOrderBookTogglePadding,
          child: Row(
            children: [
              const Icon(
                Icons.layers_rounded,
                color: _predictionPrimary,
                size: PredictionsSpacingTokens
                    .predictionDetailOrderBookToggleIcon,
              ),
              const SizedBox(
                width:
                    PredictionsSpacingTokens.predictionDetailOrderBookToggleGap,
              ),
              Expanded(
                child: Text(
                  'Order Book',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(
                width:
                    PredictionsSpacingTokens.predictionDetailOrderBookToggleGap,
              ),
              Flexible(
                child: Text(
                  'Spread ${_formatPrice(bestAsk - bestBid)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(
                width:
                    PredictionsSpacingTokens.predictionDetailOrderBookToggleGap,
              ),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: PredictionsSpacingTokens.predictionDetailOrderBookChevron,
              ),
            ],
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            density: VitDensity.compact,
            child: Column(
              children: [
                _OrderBookHeader(),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                for (final ask in snapshot.orderBook.asks.reversed)
                  _OrderBookRow(entry: ask, isBid: false),
                Padding(
                  padding: PredictionsSpacingTokens
                      .predictionDetailOrderBookMidPriceMargin,
                  child: Material(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                    child: Padding(
                      padding: PredictionsSpacingTokens
                          .predictionDetailOrderBookMidPricePadding,
                      child: Center(
                        child: Text(
                          '${_formatPrice(chance)} \u00B7 mid price',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                for (final bid in snapshot.orderBook.bids)
                  _OrderBookRow(entry: bid, isBid: true),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _OrderBookLabel('PRICE')),
        SizedBox(
          width: PredictionsSpacingTokens.predictionDetailOrderBookColumnWidth,
          child: _OrderBookLabel('SHARES', alignEnd: true),
        ),
        SizedBox(
          width: PredictionsSpacingTokens.predictionDetailOrderBookColumnWidth,
          child: _OrderBookLabel('TOTAL', alignEnd: true),
        ),
      ],
    );
  }
}

class _OrderBookLabel extends StatelessWidget {
  const _OrderBookLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({required this.entry, required this.isBid});

  final PredictionOrderBookEntryDraft entry;
  final bool isBid;

  @override
  Widget build(BuildContext context) {
    final color = isBid ? AppColors.buy : AppColors.sell;
    return Material(
      color: color.withValues(alpha: .04),
      borderRadius: AppRadii.predictionDetailOrderBookRowRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDetailOrderBookRowPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatPrice(entry.price),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width:
                  PredictionsSpacingTokens.predictionDetailOrderBookColumnWidth,
              child: Text(
                _formatInt(entry.shares),
                textAlign: TextAlign.end,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width:
                  PredictionsSpacingTokens.predictionDetailOrderBookColumnWidth,
              child: Text(
                _formatInt((entry.price * entry.shares).round()),
                textAlign: TextAlign.end,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
