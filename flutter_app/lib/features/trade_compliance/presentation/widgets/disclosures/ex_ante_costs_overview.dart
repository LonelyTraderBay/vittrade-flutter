part of '../../phone/pages/disclosures/ex_ante_costs_page.dart';

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _costBorder.withValues(alpha: .72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example Investment Amount',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: _costTinySpace),
                Text(
                  _formatEur(snapshot.investmentAmount),
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: _costTinySpace),
                Text(
                  'Illustrative estimate',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _costLineTight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _costTinySpace),
          Expanded(
            child: _MetricBox(
              label: 'Year 1',
              value: _formatEur(snapshot.totalFirstYear),
            ),
          ),
          const SizedBox(width: _costTinySpace),
          Expanded(
            child: _MetricBox(
              label: '% Invested',
              value: '${snapshot.totalPercentage.toStringAsFixed(2)}%',
              valueColor: _costRed,
            ),
          ),
        ],
      ),
    );
  }
}
