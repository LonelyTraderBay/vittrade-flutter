part of '../../phone/pages/analytics/copy_performance_page.dart';

class _PerformanceSummary extends StatelessWidget {
  const _PerformanceSummary({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tổng quan so sánh',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: _performanceSpace),
          Row(
            children: [
              Expanded(
                child: _ReturnCard(
                  title: 'Hiệu suất của bạn',
                  value: '+${snapshot.yourReturnPct.toStringAsFixed(1)}%',
                  range:
                      '\$${snapshot.initialCapital.toStringAsFixed(0)} → \$${snapshot.yourCurrentValue.toStringAsFixed(0)}',
                  border: _performancePrimary,
                  foreground: _performancePrimary,
                  textColor: AppColors.infoTextStrong,
                ),
              ),
              const SizedBox(width: _performanceSpace),
              Expanded(
                child: _ReturnCard(
                  title: 'Provider lý thuyết',
                  value: '+${snapshot.providerReturnPct.toStringAsFixed(1)}%',
                  range:
                      '\$${snapshot.initialCapital.toStringAsFixed(0)} → \$${snapshot.providerTheoreticalValue.toStringAsFixed(0)}',
                  border: _performancePurple,
                  foreground: _performancePurple,
                  textColor: AppColors.accentTextStrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: _performanceSpace),
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            padding: AppSpacing.cardPaddingCompact,
            borderColor: _performanceGreen,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: _performanceGreen,
                      size: WalletSpacingTokens.walletTokenApprovalActionIcon,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        'Chênh lệch hiệu suất',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.buy20,
                        ),
                      ),
                    ),
                    Text(
                      '${snapshot.performanceGapPct.toStringAsFixed(2)}%',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _performanceGreen,
                        fontWeight: AppTextStyles.extraBold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _performanceSpace),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nguyên nhân chính: slippage (${snapshot.avgSlippagePct.toStringAsFixed(2)}%) và chi phí (\$${snapshot.totalCosts.toStringAsFixed(0)})',
                    style: AppTextStyles.micro.copyWith(color: AppColors.buy20),
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

class _ReturnCard extends StatelessWidget {
  const _ReturnCard({
    required this.title,
    required this.value,
    required this.range,
    required this.border,
    required this.foreground,
    required this.textColor,
  });

  final String title;
  final String value;
  final String range;
  final Color border;
  final Color foreground;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      height: TradeSpacingTokens.copyPerformanceReturnCardHeight,
      padding: TradeSpacingTokens.copyPerformanceReturnCardPadding,
      borderColor: border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: textColor),
          ),
          const SizedBox(height: _performanceSpace),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.extraBold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(range, style: AppTextStyles.micro.copyWith(color: textColor)),
        ],
      ),
    );
  }
}

class _PerformanceTabs extends StatelessWidget {
  const _PerformanceTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Tổng quan'),
      ('trades', 'Trades'),
      ('costs', 'Chi phí'),
      ('metrics', 'Metrics'),
    ];
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      height: TradeSpacingTokens.copyPerformanceTabsHeight,
      padding: AppSpacing.zeroInsets,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: CopyPerformancePage.tabKey(tab.$1),
            ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Đường vốn so sánh (30 ngày)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
        const SizedBox(height: _performanceSpace),
        SizedBox(
          height: TradeSpacingTokens.copyPerformanceEquityChartHeight,
          child: CustomPaint(
            painter: _LineChartPainter(points: snapshot.equityCurve),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: _performanceSpace),
        const _InfoBox(
          title: 'Tại sao có chênh lệch?',
          lines: [
            'Slippage: Copy orders thực thi chậm hơn 0.5-3s',
            'Chi phí: Trading fees + performance fees',
            'Position sizing: Fixed mode sử dụng 50% capital',
          ],
        ),
        const SizedBox(height: _performanceCardSpace),
        Text(
          'Phân bổ Slippage',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
        const SizedBox(height: _performanceSpace),
        SizedBox(
          height: TradeSpacingTokens.tradeChartHeight,
          child: CustomPaint(
            painter: _BarChartPainter(buckets: snapshot.slippageBuckets),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: _performanceSpace),
        Row(
          children: [
            Expanded(
              child: _SmallMetricCard(
                label: 'Slippage TB của bạn',
                value: '${snapshot.avgSlippagePct.toStringAsFixed(2)}%',
              ),
            ),
            const SizedBox(width: _performanceSpace),
            Expanded(
              child: _SmallMetricCard(
                label: 'Provider TB',
                value: '${snapshot.providerAvgSlippagePct.toStringAsFixed(2)}%',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
