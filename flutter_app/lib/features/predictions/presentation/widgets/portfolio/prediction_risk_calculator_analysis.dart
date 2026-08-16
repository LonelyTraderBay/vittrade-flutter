part of '../../phone/pages/portfolio/prediction_risk_calculator_page.dart';

class _RiskAnalysis extends StatelessWidget {
  const _RiskAnalysis({required this.metrics});

  final _RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Risk Analysis',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              VitInfoRow(
                leading: const Icon(
                  Icons.trending_down_rounded,
                  color: AppColors.sell,
                  size: PredictionsSpacingTokens.predictionRiskMetricIcon,
                ),
                label: 'Max Loss',
                value: _formatMoney(metrics.maxLoss),
                valueColor: AppColors.sell,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                leading: const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.buy,
                  size: PredictionsSpacingTokens.predictionRiskMetricIcon,
                ),
                label: 'Max Gain',
                value: _formatMoney(metrics.maxGain),
                valueColor: AppColors.buy,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                leading: const Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.text3,
                  size: PredictionsSpacingTokens.predictionRiskMetricIcon,
                ),
                label: 'Break-even Price',
                value: _formatPrice(metrics.breakEvenPrice),
                density: VitDensity.compact,
              ),
              VitInfoRow(
                leading: const Icon(
                  Icons.percent_rounded,
                  color: _predictionPrimary,
                  size: PredictionsSpacingTokens.predictionRiskMetricIcon,
                ),
                label: 'Implied Probability',
                value: '${metrics.probabilityOfProfit.toStringAsFixed(1)}%',
                valueColor: _predictionPrimary,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                leading: const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.text3,
                  size: PredictionsSpacingTokens.predictionRiskMetricIcon,
                ),
                label: 'Expected Value',
                value:
                    '${metrics.expectedValue >= 0 ? '+' : ''}${_formatMoney(metrics.expectedValue)}',
                valueColor: metrics.expectedValue >= 0
                    ? AppColors.buy
                    : AppColors.sell,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                leading: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.text3,
                  size: PredictionsSpacingTokens.predictionRiskMetricIcon,
                ),
                label: 'Risk/Reward Ratio',
                value: '1:${metrics.riskRewardRatio.toStringAsFixed(2)}',
                density: VitDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KellyRecommendation extends StatelessWidget {
  const _KellyRecommendation({required this.metrics, required this.riskBudget});

  final _RiskMetrics metrics;
  final double riskBudget;

  @override
  Widget build(BuildContext context) {
    final pct = riskBudget > 0
        ? (metrics.suggestedExposure / riskBudget) * 100
        : 0;

    return VitCard(
      borderColor: AppColors.primary15,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _predictionPrimary,
                size: PredictionsSpacingTokens.predictionRiskKellyIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelly Criterion Position Sizing',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Suggested exposure based on risk budget and edge',
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x1,
            children: [
              Text(
                _formatMoney(metrics.suggestedExposure),
                style: AppTextStyles.amountSm.copyWith(
                  color: _predictionPrimary,
                ),
              ),
              Text(
                '(${pct.toStringAsFixed(1)}% of risk budget)',
                style: AppTextStyles.badge.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: PredictionsSpacingTokens.predictionRiskWarningIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Phan tich rui ro chi mang tinh tham khao. Ket qua thuc te co the khac. Luon quan ly von than trong.',
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
