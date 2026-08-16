part of '../../phone/pages/portfolio/prediction_risk_calculator_page.dart';

class _ScenariosTab extends StatelessWidget {
  const _ScenariosTab({required this.inputs, required this.metrics});

  final _RiskInputs inputs;
  final _RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      (
        outcome: 'Win (YES resolves)',
        settlementValue: inputs.shares,
        probability: inputs.currentPrice * 100,
        positive: true,
      ),
      (
        outcome: 'Loss (NO resolves)',
        settlementValue: 0.0,
        probability: (1 - inputs.currentPrice) * 100,
        positive: false,
      ),
    ];

    return VitPageSection(
      label: 'Scenarios Analysis',
      accentColor: _predictionPrimary,
      children: [
        for (final scenario in scenarios)
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.outcome,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                          Text(
                            'Implied probability: ${scenario.probability.toStringAsFixed(1)}%',
                            style: AppTextStyles.numericMicro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      scenario.positive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: scenario.positive ? AppColors.buy : AppColors.sell,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitInfoRow(
                  label: 'Settlement value',
                  value: _formatMoney(scenario.settlementValue),
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'P/L',
                  value:
                      '${scenario.settlementValue - inputs.cost >= 0 ? '+' : ''}${_formatMoney(scenario.settlementValue - inputs.cost)}',
                  valueColor: scenario.settlementValue - inputs.cost >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  density: VitDensity.compact,
                ),
              ],
            ),
          ),
        VitCard(
          density: VitDensity.compact,
          child: VitInfoRow(
            label: 'Net Expected Value',
            value:
                '${metrics.expectedValue >= 0 ? '+' : ''}${_formatMoney(metrics.expectedValue)}',
            valueColor: metrics.expectedValue >= 0
                ? AppColors.buy
                : AppColors.sell,
            density: VitDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _GuideTab extends StatelessWidget {
  const _GuideTab();

  @override
  Widget build(BuildContext context) {
    return const VitPageSection(
      label: 'How to Use',
      accentColor: _predictionPrimary,
      children: [
        _GuideCard(
          title: '1. Input Position Details',
          body:
              'Nhap thong tin vi the: event, outcome, so luong shares, gia entry va current',
        ),
        _GuideCard(
          title: '2. Review Risk Metrics',
          body:
              'Xem phan tich rui ro: max loss/gain, break-even, expected value',
        ),
        _GuideCard(
          title: '3. Check Position Sizing',
          body:
              'Tham khao Kelly criterion de xac dinh kich thuoc vi the toi uu',
        ),
        _GuideCard(
          title: 'Expected Value',
          body:
              'Cong cu tinh toan chi la tham khao. Probability khong phai la certainty.',
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            body,
            style: AppTextStyles.badge.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

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
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _RiskInputs {
  const _RiskInputs({
    required this.shares,
    required this.entryPrice,
    required this.currentPrice,
    required this.riskBudget,
  });

  final double shares;
  final double entryPrice;
  final double currentPrice;
  final double riskBudget;

  double get cost => shares * entryPrice;
  double get currentValue => shares * currentPrice;
}

class _RiskMetrics {
  const _RiskMetrics({
    required this.maxLoss,
    required this.maxGain,
    required this.breakEvenPrice,
    required this.probabilityOfProfit,
    required this.expectedValue,
    required this.riskRewardRatio,
    required this.suggestedExposure,
  });

  final double maxLoss;
  final double maxGain;
  final double breakEvenPrice;
  final double probabilityOfProfit;
  final double expectedValue;
  final double riskRewardRatio;
  final double suggestedExposure;
}

_RiskMetrics _calculate(_RiskInputs inputs) {
  final maxLoss = inputs.cost;
  final maxGain = inputs.shares * (1 - inputs.entryPrice);
  final ratio = maxLoss > 0 ? maxGain / maxLoss : 0.0;
  final expectedValue =
      (inputs.currentPrice * maxGain) - ((1 - inputs.currentPrice) * maxLoss);
  final kellyFraction = ratio > 0
      ? ((inputs.currentPrice * ratio) - (1 - inputs.currentPrice)) / ratio
      : 0.0;
  final safeKellyFraction = kellyFraction.clamp(0.0, 1.0).toDouble();

  return _RiskMetrics(
    maxLoss: maxLoss,
    maxGain: maxGain,
    breakEvenPrice: inputs.entryPrice,
    probabilityOfProfit: inputs.currentPrice * 100,
    expectedValue: expectedValue,
    riskRewardRatio: ratio,
    suggestedExposure: safeKellyFraction * inputs.riskBudget,
  );
}

double _parse(String value, {double fallback = 0}) {
  return double.tryParse(value) ?? fallback;
}

String _formatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toString();
}

String _formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';
