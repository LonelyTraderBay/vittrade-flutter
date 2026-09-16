part of 'prediction_risk_calculator_tablet_page.dart';

class _Sc216PositionInfoCard extends StatelessWidget {
  const _Sc216PositionInfoCard({
    required this.eventController,
    required this.sharesController,
    required this.entryPriceController,
    required this.currentPriceController,
    required this.riskBudgetController,
    required this.outcome,
    required this.onOutcomeChanged,
  });

  final TextEditingController eventController;
  final TextEditingController sharesController;
  final TextEditingController entryPriceController;
  final TextEditingController currentPriceController;
  final TextEditingController riskBudgetController;
  final String outcome;
  final ValueChanged<String> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thông tin vị thế',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _Sc216RiskInput(label: 'Sự kiện', controller: eventController),
              const SizedBox(height: TabletSpacingTokens.x4),
              _Sc216OutcomeToggle(value: outcome, onChanged: onOutcomeChanged),
              const SizedBox(height: TabletSpacingTokens.x4),
              Row(
                children: [
                  Expanded(
                    child: _Sc216RiskInput(
                      label: 'Cổ phần',
                      controller: sharesController,
                      fieldKey:
                          PredictionRiskCalculatorTabletPage.sharesFieldKey,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                  Expanded(
                    child: _Sc216RiskInput(
                      label: 'Giá vào (USD)',
                      controller: entryPriceController,
                      fieldKey:
                          PredictionRiskCalculatorTabletPage.entryFieldKey,
                      numeric: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              Row(
                children: [
                  Expanded(
                    child: _Sc216RiskInput(
                      label: 'Giá hiện tại (USD)',
                      controller: currentPriceController,
                      fieldKey:
                          PredictionRiskCalculatorTabletPage.currentFieldKey,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                  Expanded(
                    child: _Sc216RiskInput(
                      label: 'Ngân sách rủi ro (USD)',
                      controller: riskBudgetController,
                      numeric: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Sc216RiskInput extends StatelessWidget {
  const _Sc216RiskInput({
    required this.label,
    required this.controller,
    this.fieldKey,
    this.numeric = false,
  });

  final String label;
  final TextEditingController controller;
  final Key? fieldKey;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        VitInput(
          fieldKey: fieldKey,
          controller: controller,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: numeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
          semanticLabel: label,
          textStyle: AppTextStyles.body.copyWith(
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Sc216OutcomeToggle extends StatelessWidget {
  const _Sc216OutcomeToggle({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kết quả',
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                selected: value == 'yes',
                label: 'Kịch bản rủi ro Yes',
                child: VitChoicePill(
                  key: PredictionRiskCalculatorTabletPage.yesKey,
                  label: 'YES',
                  selected: value == 'yes',
                  onTap: () => onChanged('yes'),
                  accentColor: AppColors.buy,
                  fullWidth: true,
                ),
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x3),
            Expanded(
              child: Semantics(
                button: true,
                selected: value == 'no',
                label: 'Kịch bản rủi ro No',
                child: VitChoicePill(
                  key: PredictionRiskCalculatorTabletPage.noKey,
                  label: 'NO',
                  selected: value == 'no',
                  onTap: () => onChanged('no'),
                  accentColor: AppColors.sell,
                  fullWidth: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Sc216PositionSummary extends StatelessWidget {
  const _Sc216PositionSummary({required this.inputs});

  final _Sc216RiskInputs inputs;

  @override
  Widget build(BuildContext context) {
    final cost = inputs.cost;
    final currentValue = inputs.currentValue;
    final pnl = currentValue - cost;
    final pnlPct = cost > 0 ? (pnl / cost) * 100 : 0;

    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tóm tắt vị thế',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Row(
            children: [
              Expanded(
                child: _Sc216SummaryMetric(
                  label: 'Tổng chi phí',
                  value: VitFormat.usd(cost),
                ),
              ),
              Expanded(
                child: _Sc216SummaryMetric(
                  label: 'Giá trị hiện tại',
                  value: VitFormat.usd(currentValue),
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Row(
            children: [
              Expanded(
                child: _Sc216SummaryMetric(
                  label: 'Lãi/lỗ chưa khớp',
                  value: VitFormat.usdSigned(pnl),
                  valueColor: pnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _Sc216SummaryMetric(
                  label: 'Lãi/lỗ %',
                  value: VitFormat.signedPercent(pnlPct, fractionDigits: 2),
                  valueColor: pnlPct >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sc216SummaryMetric extends StatelessWidget {
  const _Sc216SummaryMetric({
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
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Sc216RiskAnalysis extends StatelessWidget {
  const _Sc216RiskAnalysis({required this.metrics});

  final _Sc216RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Phân tích rủi ro',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              VitInfoRow(
                label: 'Tối đa mất',
                value: VitFormat.usd(metrics.maxLoss),
                valueColor: AppColors.sell,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Tối đa được',
                value: VitFormat.usd(metrics.maxGain),
                valueColor: AppColors.buy,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Giá hòa vốn',
                value: VitFormat.usd(metrics.breakEvenPrice),
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Xác suất ngụ ý',
                value: VitFormat.percent(
                  metrics.probabilityOfProfit,
                  fractionDigits: 1,
                ),
                valueColor: AppColors.primary,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Giá trị kỳ vọng',
                value: VitFormat.usdSigned(metrics.expectedValue),
                valueColor: metrics.expectedValue >= 0
                    ? AppColors.buy
                    : AppColors.sell,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Tỷ lệ rủi ro/lợi nhuận',
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

class _Sc216KellyRecommendation extends StatelessWidget {
  const _Sc216KellyRecommendation({
    required this.metrics,
    required this.riskBudget,
  });

  final _Sc216RiskMetrics metrics;
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
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Định cỡ vị thế theo Kelly',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      'Mức đề xuất dựa trên ngân sách rủi ro và lợi thế',
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: TabletSpacingTokens.x2,
            runSpacing: TabletSpacingTokens.x1,
            children: [
              Text(
                VitFormat.usd(metrics.suggestedExposure),
                style: AppTextStyles.amountSm.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                '(${VitFormat.percent(pct, fractionDigits: 1)} ngân sách rủi ro)',
                style: AppTextStyles.badge.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sc216RiskWarning extends StatelessWidget {
  const _Sc216RiskWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: TabletSpacingTokens.iconSm,
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: TabletSpacingTokens.iconSm,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Text(
              'Phân tích rủi ro chỉ mang tính tham khảo. Kết quả thực tế có '
              'thể khác. Luôn quản lý vốn thận trọng.',
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
