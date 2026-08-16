part of '../../phone/pages/portfolio/prediction_portfolio_analyzer_page.dart';

class _AnalyzerTabBar extends StatelessWidget {
  const _AnalyzerTabBar({required this.activeTab, required this.onChanged});

  final _AnalyzerTab activeTab;
  final ValueChanged<_AnalyzerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_AnalyzerTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      showBottomBorder: true,
      items: const [
        (
          PredictionPortfolioAnalyzerPage.overviewTabKey,
          _AnalyzerTab.overview,
          'Tong quan',
        ),
        (
          PredictionPortfolioAnalyzerPage.performanceTabKey,
          _AnalyzerTab.performance,
          'Hieu suat',
        ),
        (
          PredictionPortfolioAnalyzerPage.riskTabKey,
          _AnalyzerTab.risk,
          'Rui ro',
        ),
      ],
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  const _PortfolioSummaryCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlTone = snapshot.totalPnl >= 0
        ? VitMetricDeltaTone.positive
        : VitMetricDeltaTone.negative;

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      background: const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            _formatMoney(snapshot.totalPortfolioValue),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.onAccent,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Flexible(
                child: VitMetricDeltaPill(
                  label:
                      '${snapshot.totalPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.totalPnl)}',
                  tone: pnlTone,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCardStat(
                  child: _SummaryMetric(
                    label: 'Invested',
                    value: _formatMoney(snapshot.totalInvested),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCardStat(
                  child: _SummaryMetric(
                    label: 'Return %',
                    value:
                        '${snapshot.totalPnlPercent >= 0 ? '+' : ''}${snapshot.totalPnlPercent.toStringAsFixed(2)}%',
                    valueColor: snapshot.totalPnl >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCardStat(
                  child: _SummaryMetric(
                    label: 'Realized P/L',
                    value:
                        '${snapshot.realizedPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.realizedPnl)}',
                    valueColor: snapshot.realizedPnl >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    small: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCardStat(
                  child: _SummaryMetric(
                    label: 'Unrealized P/L',
                    value:
                        '${snapshot.unrealizedPnl >= 0 ? '+' : ''}${_formatMoney(snapshot.unrealizedPnl)}',
                    valueColor: snapshot.unrealizedPnl >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    small: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Icons.show_chart_rounded,
        label: 'Open Positions',
        value: '${snapshot.openPositions.length}',
        color: _predictionPrimary,
      ),
      (
        icon: Icons.adjust_rounded,
        label: 'Win Rate',
        value: '${snapshot.winRate.toStringAsFixed(1)}%',
        color: AppColors.buy,
      ),
      (
        icon: Icons.workspace_premium_outlined,
        label: 'Total Trades',
        value: '${snapshot.totalTrades}',
        color: _purple,
      ),
      (
        icon: Icons.bar_chart_rounded,
        label: 'Avg Trade',
        value: _formatMoneyCompact(snapshot.averageTrade),
        color: AppColors.warn,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: PredictionsSpacingTokens.predictionAnalyzerGridColumns,
        mainAxisExtent: AppSpacing.x7 * 3,
        crossAxisSpacing: PredictionsSpacingTokens.predictionAnalyzerGridGap,
        mainAxisSpacing: PredictionsSpacingTokens.predictionAnalyzerGridGap,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return VitCardStat(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    stat.icon,
                    color: stat.color,
                    size: PredictionsSpacingTokens.predictionAnalyzerStatIcon,
                  ),
                  const SizedBox(
                    width:
                        PredictionsSpacingTokens.predictionAnalyzerStatIconGap,
                  ),
                  Expanded(
                    child: Text(
                      stat.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                stat.value,
                style: AppTextStyles.amountSm.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = snapshot.categories;
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Portfolio by Category',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Center(
            child: SizedBox(
              height: AppSpacing.x7 * 4,
              width: AppSpacing.x7 * 4,
              child: CustomPaint(
                painter: _DonutChartPainter(categories: categories),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  PredictionsSpacingTokens.predictionAnalyzerLegendColumns,
              mainAxisExtent: AppSpacing.x7,
              crossAxisSpacing:
                  PredictionsSpacingTokens.predictionAnalyzerLegendCrossGap,
              mainAxisSpacing:
                  PredictionsSpacingTokens.predictionAnalyzerLegendMainGap,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryLegendItem(
                category: category,
                color: _categoryColor(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
