part of '../../phone/pages/savings/savings_analytics_page.dart';

class _YieldChartCard extends StatelessWidget {
  const _YieldChartCard({required this.summary, required this.points});

  final SavingsAnalyticsSummaryDraft summary;
  final List<SavingsYieldPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.yieldChartKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng yield tích lũy',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      EarnFormatters.usd(summary.totalEarned),
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: AppColors.buy10,
                borderRadius: AppRadii.mdRadius,
                child: Padding(
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.x2,
                    top: AppSpacing.x1,
                    right: AppSpacing.x2,
                    bottom: AppSpacing.x1,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        '+${summary.yieldChange.toStringAsFixed(2)}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox(
            height: EarnSpacingTokens.savingsConsumerYieldChartHeight,
            child: _YieldChart(points: points),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const _YieldLegend(),
        ],
      ),
    );
  }
}

class _YieldLegend extends StatelessWidget {
  const _YieldLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.x4,
      runSpacing: AppSpacing.x2,
      children: [
        VitLegendItem(label: 'USDT', color: AppColors.buy),
        VitLegendItem(label: 'BTC', color: AppColors.warn),
        VitLegendItem(label: 'SOL', color: AppColors.accent),
        VitLegendItem(label: 'ETH', color: AppColors.primary),
      ],
    );
  }
}

class _MonthlyIncomeCard extends StatelessWidget {
  const _MonthlyIncomeCard({required this.points});

  final List<SavingsMonthlyEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.monthlyChartKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Thu nhập hằng tháng',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: EarnSpacingTokens.savingsConsumerMonthlyChartHeight,
            child: _MonthlyBars(points: points),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.summary});

  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: SavingsAnalyticsPage.metricsKey,
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.attach_money_rounded,
            label: 'Thu nhập/ngày',
            value: EarnFormatters.usd(summary.dailyEarnings),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.calendar_month_outlined,
            label: 'Thu nhập/tháng',
            value: EarnFormatters.usd(summary.monthlyEarnings),
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            label: 'Dự kiến/năm',
            value: EarnFormatters.usd(summary.annualProjection),
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
