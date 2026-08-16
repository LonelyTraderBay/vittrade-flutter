part of '../../phone/pages/disclosures/ex_post_costs_report_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: _reportBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: muted ? AppColors.text3 : AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _YearTabs extends StatelessWidget {
  const _YearTabs({
    required this.reports,
    required this.activeYear,
    required this.onChanged,
  });

  final List<TradeExPostCostReport> reports;
  final int activeYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      radius: VitCardRadius.tight,
      padding: AppSpacing.zeroInsets,
      constraints: BoxConstraints(minHeight: VitDensity.tool.controlHeight),
      child: VitTabBar(
        activeKey: '$activeYear',
        onChanged: (year) => onChanged(int.parse(year)),
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final report in reports)
            VitTabItem(
              key: '${report.year}',
              label: '${report.year}',
              widgetKey: ExPostCostsReportPage.tabKey(report.year),
            ),
        ],
      ),
    );
  }
}

class _CostBreakdownCard extends StatelessWidget {
  const _CostBreakdownCard({
    required this.title,
    required this.actual,
    required this.estimate,
    this.note,
  });

  final String title;
  final double actual;
  final double estimate;
  final _VarianceNote? note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: _reportBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
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
                    _formatEur(actual),
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Est: ${_formatEur(estimate)}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _VarianceNoteView(note: note!),
          ],
        ],
      ),
    );
  }
}
