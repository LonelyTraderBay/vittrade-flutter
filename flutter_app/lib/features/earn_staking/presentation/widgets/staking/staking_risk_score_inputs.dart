part of '../../phone/pages/staking/staking_risk_score_calculator_page.dart';

class _ScenarioInputs extends StatelessWidget {
  const _ScenarioInputs({
    required this.snapshot,
    required this.amountController,
    required this.asset,
    required this.duration,
    required this.validators,
    required this.onAmountChanged,
    required this.onAssetChanged,
    required this.onDurationChanged,
    required this.onValidatorsChanged,
  });

  final StakingRiskScoreCalculatorSnapshot snapshot;
  final TextEditingController amountController;
  final String asset;
  final String duration;
  final int validators;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onAssetChanged;
  final ValueChanged<String> onDurationChanged;
  final ValueChanged<int> onValidatorsChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskScoreCalculatorPage.formKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Scenario Inputs', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _FieldLabel(
            label: 'Stake Amount (USD)',
            child: _AmountInput(
              controller: amountController,
              onChanged: onAmountChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _FieldLabel(
            label: 'Asset',
            child: _RiskDropdown(
              fieldKey: StakingRiskScoreCalculatorPage.assetSelectorKey,
              value: asset,
              options: snapshot.assetOptions,
              onChanged: onAssetChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _FieldLabel(
            label: 'Lock-up Period',
            child: _RiskDropdown(
              fieldKey: StakingRiskScoreCalculatorPage.durationSelectorKey,
              value: duration,
              options: snapshot.durationOptions,
              onChanged: onDurationChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ValidatorSlider(
            validators: validators,
            onChanged: onValidatorsChanged,
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        child,
      ],
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: StakingRiskScoreCalculatorPage.amountFieldKey,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      semanticLabel: 'Số tiền tính điểm rủi ro staking',
      hintText: '0',
      onChanged: onChanged,
      textStyle: AppTextStyles.baseMedium.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _RiskDropdown extends StatelessWidget {
  const _RiskDropdown({
    required this.fieldKey,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final Key fieldKey;
  final String value;
  final List<StakingRiskScoreOptionDraft> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = options.firstWhere(
      (option) => option.value == value,
      orElse: () => options.first,
    );
    return VitCard(
      key: fieldKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      onTap: () => _showOptions(context),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: Text(
              selected.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        barrierColor: AppColors.bg.withValues(alpha: 0.72),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: EarnSpacingTokens.earnSheetContentPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final option in options)
                    _RiskOptionRow(
                      option: option,
                      selected: option.value == value,
                      onTap: () {
                        Navigator.of(context).pop();
                        onChanged(option.value);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RiskOptionRow extends StatelessWidget {
  const _RiskOptionRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final StakingRiskScoreOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnBottomPaddingX2,
      child: VitCard(
        variant: VitCardVariant.inner,
        borderColor: selected ? AppColors.primary30 : null,
        onTap: onTap,
        padding: EarnSpacingTokens.earnCardPaddingX4,
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: selected
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}

class _ValidatorSlider extends StatelessWidget {
  const _ValidatorSlider({required this.validators, required this.onChanged});

  final int validators;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Number of Validators: $validators',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        Slider(
          key: StakingRiskScoreCalculatorPage.validatorSliderKey,
          min: 1,
          max: 10,
          divisions: 9,
          value: validators.toDouble(),
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface3,
          onChanged: (next) => onChanged(next.round()),
        ),
      ],
    );
  }
}
