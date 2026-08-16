part of '../../phone/pages/portfolio/prediction_market_maker_page.dart';

class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Phan tich thu nhap',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fee Earnings Over Time',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              SizedBox(
                height: VitDensity.compact.controlHeight * 3.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final point in snapshot.earningsHistory)
                      Expanded(
                        child: Padding(
                          padding: PredictionsSpacingTokens
                              .predictionMarketMakerEarningsBarPadding,
                          child: _FeeBar(point: point),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _AnalysisRow(
                label: 'Total Fees',
                value: _formatMoney(snapshot.totalFees),
                valueColor: AppColors.buy,
                icon: Icons.local_activity_rounded,
              ),
              _AnalysisRow(
                label: 'Avg Daily Fees',
                value: _formatMoney(snapshot.totalFees / 60),
                icon: Icons.bar_chart_rounded,
              ),
              _AnalysisRow(
                label: 'Fee Yield (annualized)',
                value: '${snapshot.averageApr.toStringAsFixed(1)}%',
                icon: Icons.percent_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeeBar extends StatelessWidget {
  const _FeeBar({required this.point});

  final PredictionEarningsPointDraft point;

  @override
  Widget build(BuildContext context) {
    final height = 36 + point.fees;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: const Material(
            color: _predictionPrimary,
            borderRadius: BorderRadius.vertical(top: AppRadii.smCorner),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          point.date,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: (small ? AppTextStyles.caption : AppTextStyles.baseMedium)
              .copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  const _AnalysisRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PredictionsSpacingTokens.predictionMarketMakerAnalysisRowPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.text3,
            size: PredictionsSpacingTokens.predictionMarketMakerAnalysisIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Key _spreadKey(int value) {
  return switch (value) {
    25 => PredictionMarketMakerPage.spread25Key,
    50 => PredictionMarketMakerPage.spread50Key,
    100 => PredictionMarketMakerPage.spread100Key,
    200 => PredictionMarketMakerPage.spread200Key,
    _ => Key('sc037_spread_$value'),
  };
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toString();
}
