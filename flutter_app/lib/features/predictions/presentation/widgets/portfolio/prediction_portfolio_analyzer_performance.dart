part of '../../phone/pages/portfolio/prediction_portfolio_analyzer_page.dart';

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'P/L Over Time',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: AppSpacing.x7 * 5,
            child: CustomPaint(
              painter: _PnlLinePainter(points: snapshot.pnlHistory),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeStatsSection extends StatelessWidget {
  const _TradeStatsSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Trade Statistics',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          density: VitDensity.compact,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Win Rate',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      '${snapshot.winRate.toStringAsFixed(1)}%',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Winning',
                      value: '${snapshot.winningTrades}',
                      valueColor: AppColors.buy,
                    ),
                  ),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Losing',
                      value: '${snapshot.losingTrades}',
                      valueColor: AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: LinearProgressIndicator(
                  minHeight: PredictionsSpacingTokens
                      .predictionAnalyzerTradeProgressHeight,
                  value: snapshot.winRate / 100,
                  color: AppColors.buy,
                  backgroundColor: AppColors.bg,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttributionSection extends StatelessWidget {
  const _AttributionSection({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final closed = snapshot.closedPositions.toList()
      ..sort((a, b) => b.pnl.compareTo(a.pnl));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Performance Attribution',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          density: VitDensity.compact,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final position in closed)
          VitCard(
            density: VitDensity.compact,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.eventName,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        position.category,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens
                      .predictionAnalyzerAttributionTrailingGap,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${position.pnl >= 0 ? '+' : ''}${_formatMoney(position.pnl)}',
                      style: AppTextStyles.caption.copyWith(
                        color: position.pnl >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      position.resolvedAtLabel ?? '',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
