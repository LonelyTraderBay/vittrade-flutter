part of '../../phone/pages/portfolio/prediction_risk_calculator_page.dart';

class _RiskTabBar extends StatelessWidget {
  const _RiskTabBar({required this.activeTab, required this.onChanged});

  final _RiskTab activeTab;
  final ValueChanged<_RiskTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_RiskTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      showBottomBorder: true,
      semanticsLabel: 'Tab máy tính rủi ro dự đoán',
      items: const [
        (
          PredictionRiskCalculatorPage.calculatorTabKey,
          _RiskTab.calculator,
          'May tinh',
        ),
        (
          PredictionRiskCalculatorPage.scenariosTabKey,
          _RiskTab.scenarios,
          'Kich ban',
        ),
        (PredictionRiskCalculatorPage.guideTabKey, _RiskTab.guide, 'Huong dan'),
      ],
    );
  }
}

class _PositionInfoCard extends StatelessWidget {
  const _PositionInfoCard({
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
      label: 'Thong tin vi the',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _RiskInput(label: 'Event', controller: eventController),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _OutcomeToggle(value: outcome, onChanged: onOutcomeChanged),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _RiskInput(
                      label: 'Shares',
                      controller: sharesController,
                      fieldKey: PredictionRiskCalculatorPage.sharesFieldKey,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _RiskInput(
                      label: 'Entry Price (\$)',
                      controller: entryPriceController,
                      fieldKey: PredictionRiskCalculatorPage.entryFieldKey,
                      numeric: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _RiskInput(
                      label: 'Current Price (\$)',
                      controller: currentPriceController,
                      fieldKey: PredictionRiskCalculatorPage.currentFieldKey,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _RiskInput(
                      label: 'Risk Budget (\$)',
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

class _RiskInput extends StatelessWidget {
  const _RiskInput({
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
        const SizedBox(height: AppSpacing.x1),
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
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _OutcomeToggle extends StatelessWidget {
  const _OutcomeToggle({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Outcome',
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            Expanded(
              child: _OutcomeButton(
                key: PredictionRiskCalculatorPage.yesKey,
                label: 'YES',
                selected: value == 'yes',
                selectedColor: AppColors.buy,
                onTap: () => onChanged('yes'),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _OutcomeButton(
                key: PredictionRiskCalculatorPage.noKey,
                label: 'NO',
                selected: value == 'no',
                selectedColor: AppColors.sell,
                onTap: () => onChanged('no'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OutcomeButton extends StatelessWidget {
  const _OutcomeButton({
    super.key,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Kịch bản rủi ro $label',
      child: VitChoicePill(
        label: label,
        selected: selected,
        onTap: onTap,
        accentColor: selectedColor,
        fullWidth: true,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
        ),
      ),
    );
  }
}

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.inputs});

  final _RiskInputs inputs;

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
            'Position Summary',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Total Cost',
                  value: _formatMoney(cost),
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Current Value',
                  value: _formatMoney(currentValue),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Unrealized P/L',
                  value: '${pnl >= 0 ? '+' : ''}${_formatMoney(pnl)}',
                  valueColor: pnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'P/L %',
                  value:
                      '${pnlPct >= 0 ? '+' : ''}${pnlPct.toStringAsFixed(2)}%',
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
