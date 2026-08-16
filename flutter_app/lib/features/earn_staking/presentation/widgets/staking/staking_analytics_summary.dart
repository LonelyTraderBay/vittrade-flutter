part of '../../phone/pages/staking/staking_analytics_page.dart';

const double _stakingAnalyticsCaptionLineHeight = 1.22;

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.showCalculator,
    required this.onCalculate,
    required this.onExport,
  });

  final StakingAnalyticsSnapshot snapshot;
  final bool showCalculator;
  final VoidCallback onCalculate;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAnalyticsPage.summaryKey,
      radius: VitCardRadius.large,
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.attach_money_rounded,
                  label: 'Tổng thu nhập',
                  value: '+${EarnFormatters.usd(snapshot.summary.totalEarned)}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.percent_rounded,
                  label: 'APY ước tính',
                  value: '${snapshot.summary.averageApy.toStringAsFixed(1)}%',
                  color: AppModuleAccents.earn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'ROI tham chiếu',
                  value: '${snapshot.summary.bestRoi.toStringAsFixed(1)}%',
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingAnalyticsPage.calculateButtonKey,
                  density: VitDensity.compact,
                  onPressed: onCalculate,
                  leading: Icon(
                    showCalculator
                        ? Icons.expand_less_rounded
                        : Icons.bar_chart_rounded,
                  ),
                  child: const Text('Tính lợi nhuận'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingAnalyticsPage.exportButtonKey,
                  density: VitDensity.compact,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: onExport,
                  leading: const Icon(Icons.file_download_outlined),
                  child: const Text('Xuất báo cáo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: EarnSpacingTokens.earnAnalyticsSummaryIcon,
            ),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  const _CalculatorCard({
    super.key,
    required this.compound,
    required this.onToggleCompound,
  });

  final bool compound;
  final VoidCallback onToggleCompound;

  @override
  Widget build(BuildContext context) {
    final principal = 1000.0;
    final apy = 7.5;
    final days = 90.0;
    final earned = compound
        ? principal * math.pow(1 + (apy / 100) / 365, days) - principal
        : principal * (apy / 100) * (days / 365);
    final finalValue = principal + earned;

    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
                size: EarnSpacingTokens.earnAnalyticsInlineIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Mẫu tính lợi nhuận',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              Switch.adaptive(
                value: compound,
                onChanged: (_) => onToggleCompound(),
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _CalculatorMetric(
                  label: 'Gốc',
                  value: EarnFormatters.usd(principal),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CalculatorMetric(label: 'APY ước tính', value: '$apy%'),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CalculatorMetric(
                  label: compound ? 'Lãi kép' : 'Lãi đơn',
                  value: '+${EarnFormatters.usd(earned)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Tổng nhận về ${EarnFormatters.usd(finalValue)} sau 90 ngày. Đây là mô phỏng để kiểm UI, không phải cam kết lợi nhuận.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _stakingAnalyticsCaptionLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorMetric extends StatelessWidget {
  const _CalculatorMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
