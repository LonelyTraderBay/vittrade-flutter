part of '../../phone/pages/disclosures/riy_calculator_page.dart';

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.investment,
    required this.expectedReturn,
    required this.totalCosts,
    required this.years,
    required this.onInvestmentChanged,
    required this.onExpectedReturnChanged,
    required this.onTotalCostsChanged,
    required this.onYearsChanged,
  });

  final double investment;
  final double expectedReturn;
  final double totalCosts;
  final int years;
  final ValueChanged<double> onInvestmentChanged;
  final ValueChanged<double> onExpectedReturnChanged;
  final ValueChanged<double> onTotalCostsChanged;
  final ValueChanged<int> onYearsChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: _riyBorder.withValues(alpha: .72),
      child: Column(
        children: [
          _NumberField(
            key: RIYCalculatorPage.investmentKey,
            label: 'Initial Investment (EUR)',
            initialValue: _formatInput(investment),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0) onInvestmentChanged(parsed);
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _NumberField(
            key: RIYCalculatorPage.expectedReturnKey,
            label: 'Expected Annual Return (%)',
            initialValue: _formatInput(expectedReturn),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null) onExpectedReturnChanged(parsed);
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _NumberField(
            key: RIYCalculatorPage.totalCostsKey,
            label: 'Total Annual Costs (%)',
            initialValue: _formatInput(totalCosts),
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0) onTotalCostsChanged(parsed);
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _NumberField(
            key: RIYCalculatorPage.yearsKey,
            label: 'Holding Period (Years)',
            initialValue: '$years',
            decimals: false,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null && parsed > 0) {
                onYearsChanged(parsed.clamp(1, 20).toInt());
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.decimals = true,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        SizedBox(
          height: VitDensity.tool.controlHeight,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.numberWithOptions(decimal: decimals),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                decimals ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
              ),
            ],
            onChanged: onChanged,
            cursorColor: _riyPrimary,
            style: AppTextStyles.base.copyWith(color: AppColors.text1),
            decoration: InputDecoration(
              filled: true,
              fillColor: _riyPanel2,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              border: _fieldBorder(_riyBorder),
              enabledBorder: _fieldBorder(_riyBorder),
              focusedBorder: _fieldBorder(_riyPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({
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
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: _riyBorder.withValues(alpha: .72),
      child: SizedBox(
        height: _riyMetricExtent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(value, style: AppTextStyles.amountSm.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _CostImpactCard extends StatelessWidget {
  const _CostImpactCard({
    required this.years,
    required this.difference,
    required this.lossPct,
  });

  final int years;
  final double difference;
  final double lossPct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: _riyBorder.withValues(alpha: .72),
      child: SizedBox(
        height: _riyCostImpactExtent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cost Impact',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  '-${_formatEur(difference)}',
                  style: AppTextStyles.sectionTitleSm.copyWith(color: _riyRed),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitCard(
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.tight,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              borderColor: _riyPrimary.withValues(alpha: .12),
              child: Text(
                'Over $years years, costs reduce your investment by '
                '${_formatEur(difference)} (${lossPct.toStringAsFixed(1)}% loss).',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.projections});

  final List<TradeRiyProjection> projections;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: _riyBorder.withValues(alpha: .72),
      child: SizedBox(
        height: _riyChartExtent,
        child: CustomPaint(painter: _RiyChartPainter(projections)),
      ),
    );
  }
}
