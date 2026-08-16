part of '../../phone/pages/staking/staking_auto_compound_page.dart';

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    super.key,
    required this.snapshot,
    required this.frequency,
    required this.thresholdController,
    required this.gasOptimization,
    required this.onFrequencyChanged,
    required this.onThresholdChanged,
    required this.onGasOptimizationChanged,
  });

  final StakingAutoCompoundSnapshot snapshot;
  final String frequency;
  final TextEditingController thresholdController;
  final bool gasOptimization;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<String> onThresholdChanged;
  final VoidCallback onGasOptimizationChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tần suất tái đầu tư',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (var i = 0; i < snapshot.frequencies.length; i++) ...[
                Expanded(
                  child: _FrequencyTile(
                    frequency: snapshot.frequencies[i],
                    selected: frequency == snapshot.frequencies[i].id,
                    onTap: () => onFrequencyChanged(snapshot.frequencies[i].id),
                  ),
                ),
                if (i != snapshot.frequencies.length - 1)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          VitInput(
            fieldKey: StakingAutoCompoundPage.thresholdKey,
            controller: thresholdController,
            label: 'Ngưỡng tối thiểu (USD)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onThresholdChanged,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Chỉ tái đầu tư khi phần thưởng >= ${_formatCurrency(_parseDouble(thresholdController.text, 10), compact: true)}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          _GasOptimizationTile(
            enabled: gasOptimization,
            onTap: onGasOptimizationChanged,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.primary20,
            padding: EarnSpacingTokens.earnPaddingX4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Gợi ý: ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        TextSpan(
                          text: snapshot.suggestion,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FrequencyTile extends StatelessWidget {
  const _FrequencyTile({
    required this.frequency,
    required this.selected,
    required this.onTap,
  });

  final StakingAutoCompoundFrequencyDraft frequency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.frequencyKey(frequency.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: selected ? AppColors.buy : AppColors.borderSolid,
      padding: EarnSpacingTokens.earnPaddingX4,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              frequency.label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.buy : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              frequency.description,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _GasOptimizationTile extends StatelessWidget {
  const _GasOptimizationTile({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.gasOptimizationKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnPaddingX4,
      onTap: onTap,
      child: Row(
        children: [
          _CheckBoxIndicator(checked: enabled),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tối ưu Gas Fee', style: AppTextStyles.baseMedium),
                Text(
                  'Chỉ compound khi gas fee thấp (tiết kiệm ~30-50%)',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckBoxIndicator extends StatelessWidget {
  const _CheckBoxIndicator({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x5,
      child: Material(
        color: checked ? AppColors.buy : AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(
            color: checked ? AppColors.buy : AppColors.borderSolid,
            width: EarnSpacingTokens.stakingAutoCompoundCheckBorderWidth,
          ),
        ),
        child: checked
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.iconSm,
              )
            : null,
      ),
    );
  }
}
