part of '../../phone/pages/client_money/cass_reconciliation_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradeCassReconciliationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Reconciled',
            value: '${snapshot.reconciledCount}',
            caption: 'Last 7 days',
            captionColor: _cassGreen,
          ),
        ),
        const SizedBox(width: _cassTinySpace),
        Expanded(
          child: _SummaryCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            caption: 'Discrepancies',
            captionColor: AppColors.text3,
          ),
        ),
        const SizedBox(width: _cassTinySpace),
        Expanded(
          child: _SummaryCard(
            label: 'Outstanding',
            value: '${snapshot.outstandingCount}',
            caption: 'None',
            captionColor: _cassGreen,
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
    required this.caption,
    required this.captionColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color captionColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _cassBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _cassLineTight,
            ),
          ),
          const SizedBox(height: _cassTinySpace),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              height: _cassLineTight,
            ),
          ),
          const SizedBox(height: _cassTinySpace),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: captionColor,
              height: _cassLineTight,
            ),
          ),
        ],
      ),
    );
  }
}
