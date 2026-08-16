part of '../../phone/pages/analytics/copy_performance_page.dart';

class _TradesTab extends StatelessWidget {
  const _TradesTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _InfoBox(
          title: 'So sánh từng giao dịch',
          lines: ['Chênh lệch chủ yếu do slippage và execution delay.'],
        ),
        const SizedBox(height: _performanceSpace),
        for (final trade in snapshot.tradeComparisons) ...[
          VitCard(
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            padding: TradeSpacingTokens.copyPerformanceTradeCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SidePill(side: trade.side),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        trade.pair,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.extraBold,
                        ),
                      ),
                    ),
                    Text(
                      trade.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _performanceSpace),
                Row(
                  children: [
                    Expanded(
                      child: _TradeColumn(
                        title: 'Provider',
                        color: _performancePurple,
                        entry: trade.providerEntry,
                        exit: trade.providerExit,
                        pnl: trade.providerPnl,
                      ),
                    ),
                    const SizedBox(width: _performanceSpace),
                    Expanded(
                      child: _TradeColumn(
                        title: 'Bạn',
                        color: _performancePrimary,
                        entry: trade.yourEntry,
                        exit: trade.yourExit,
                        pnl: trade.yourPnl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _performanceSpace),
                Row(
                  children: [
                    Expanded(
                      child: _InlineInfo(
                        icon: Icons.schedule_rounded,
                        label: 'Delay: ${trade.delay}',
                      ),
                    ),
                    Expanded(
                      child: _InlineInfo(
                        icon: Icons.show_chart_rounded,
                        label: 'Slippage: ${trade.slippagePct}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: _performanceSpace),
        ],
      ],
    );
  }
}

class _CostsTab extends StatelessWidget {
  const _CostsTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in snapshot.costAttribution)
          Padding(
            padding: TradeSpacingTokens.copyPerformanceCostItemPadding,
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.tight,
              density: VitDensity.tool,
              padding: AppSpacing.cardPaddingCompact,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Color(item.colorHex),
                  ),
                  const SizedBox(width: _performanceSpace),
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '\$${item.value.toStringAsFixed(0)}',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.extraBold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Divider(
          color: AppColors.divider,
          height: AppSpacing.sectionGapRegular,
        ),
        _SmallMetricCard(
          label: 'Tổng chi phí',
          value: '\$${snapshot.totalCosts.toStringAsFixed(0)}',
          valueColor: _performanceRed,
        ),
      ],
    );
  }
}

class _MetricsTab extends StatelessWidget {
  const _MetricsTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final metric in snapshot.metrics)
          Padding(
            padding: TradeSpacingTokens.copyPerformanceMetricItemPadding,
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.tight,
              density: VitDensity.tool,
              padding: TradeSpacingTokens.copyPerformanceTradeCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.name,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                  const SizedBox(height: _performanceSpace),
                  Row(
                    children: [
                      Expanded(
                        child: _SmallMetricCard(
                          label: 'Bạn',
                          value:
                              '${metric.you.toStringAsFixed(2)}${metric.suffix}',
                        ),
                      ),
                      const SizedBox(width: _performanceSpace),
                      Expanded(
                        child: _SmallMetricCard(
                          label: 'Provider',
                          value:
                              '${metric.provider.toStringAsFixed(2)}${metric.suffix}',
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

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return TradeCopyHeaderBodyCard(
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.text3,
      iconSize: AppSpacing.x4,
      title: title,
      titleStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
      headerGap: _performanceSpace,
      variant: VitCardVariant.ghost,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.copyPerformanceInfoBoxPadding,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            Padding(
              padding: TradeSpacingTokens.copyPerformanceInfoLinePadding,
              child: Text(
                '• $line',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _performanceInfoLineHeight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  const _SmallMetricCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.extraBold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
