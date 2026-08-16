part of '../../phone/pages/savings/savings_analytics_page.dart';

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({required this.summary});

  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAnalyticsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              label: 'Tổng tiết kiệm',
              value: EarnFormatters.usd(summary.totalInvested),
              color: AppColors.text1,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              label: 'Tổng yield',
              value: '+${EarnFormatters.usd(summary.totalEarned)}',
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              label: 'APY ước tính BQ',
              value: '${summary.weightedApy.toStringAsFixed(2)}%',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
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
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({
    required this.ranges,
    required this.activeRange,
    required this.onChanged,
  });

  final List<String> ranges;
  final String activeRange;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<String>(
      accentColor: AppModuleAccents.earn,
      selectedValue: activeRange,
      onTap: onChanged,
      items: [
        for (final range in ranges)
          VitPresetChipItem(
            value: range,
            label: range,
            key: SavingsAnalyticsPage.rangeKey(range),
          ),
      ],
    );
  }
}
