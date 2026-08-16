part of '../../phone/pages/execution/execution_venue_analysis_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeExecutionVenueAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total Venues',
            value: summary.totalVenues.toString(),
            subtitle: 'Active integrations',
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.executionVenueSummaryGap),
        Expanded(
          child: _SummaryCard(
            label: 'Avg Total Cost',
            value: '${summary.avgTotalCost.toStringAsFixed(2)} bps',
            subtitle: '-5% vs last quarter',
            subtitleColor: _venueGreen,
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.executionVenueSummaryGap),
        Expanded(
          child: _SummaryCard(
            label: 'Avg Fill Time',
            value: '${summary.avgFillTime.toStringAsFixed(2)}s',
            subtitle: '-12% vs last quarter',
            subtitleColor: _venueGreen,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleColor = AppColors.text3,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _venueBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: subtitleColor),
          ),
        ],
      ),
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      ('volume', 'Volume'),
      ('cost', 'Lowest\nCost'),
      ('speed', 'Fastest'),
      ('fill-rate', 'Best Fill\nRate'),
    ];
    return Row(
      children: [
        const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.text3,
          size: TradeSpacingTokens.executionVenueSortIcon,
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: TradeSpacingTokens.executionVenueSortLabelWidth,
          child: Text(
            'Sort\nby:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.executionVenueSortLabelGap),
        for (final option in options) ...[
          Expanded(
            child: VitChoicePill(
              key: ExecutionVenueAnalysisPage.sortKey(option.$1),
              label: option.$2.replaceAll('\n', ' '),
              selected: activeId == option.$1,
              onTap: () => onChanged(option.$1),
              fullWidth: true,
              height: TradeSpacingTokens.tradeBotControlCompact,
              accentColor: _venuePrimary,
            ),
          ),
          if (option != options.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}
