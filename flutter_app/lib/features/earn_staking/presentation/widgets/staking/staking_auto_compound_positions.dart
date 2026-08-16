part of '../../phone/pages/staking/staking_auto_compound_page.dart';

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.frequency,
    required this.onToggle,
  });

  final StakingAutoCompoundPositionDraft position;
  final String frequency;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.positionKey(position.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatAmount(position.amount)} ${position.asset}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _ToggleSwitch(
                key: StakingAutoCompoundPage.toggleKey(position.id),
                enabled: position.autoCompound,
                onTap: onToggle,
              ),
            ],
          ),
          if (position.autoCompound) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Material(
              color: AppColors.buy10,
              borderRadius: AppRadii.inputRadius,
              child: Padding(
                padding: EarnSpacingTokens.earnCardPaddingX3X4,
                child: Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.buy,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Auto-compound đang bật • ${_frequencyLabel(frequency)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: enabled,
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.large,
        padding: AppSpacing.zeroInsets,
        onTap: onTap,
        child: VitTogglePill(
          enabled: enabled,
          width: EarnSpacingTokens.stakingAutoCompoundToggleWidth,
          height: EarnSpacingTokens.stakingAutoCompoundToggleHeight,
          knobSize: AppSpacing.x5,
          knobMargin: EarnSpacingTokens.earnPaddingX1,
          activeColor: AppColors.buy,
          inactiveColor: AppColors.surface3,
          inactiveKnobColor: AppColors.onAccent,
          inactiveBorderColor: AppColors.surface3,
          duration: const Duration(milliseconds: 180),
        ),
      ),
    );
  }
}
