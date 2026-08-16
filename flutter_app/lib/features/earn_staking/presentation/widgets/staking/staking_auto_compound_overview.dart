part of '../../phone/pages/staking/staking_auto_compound_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.positions,
    required this.frequency,
    required this.threshold,
  });

  final List<StakingAutoCompoundPositionDraft> positions;
  final String frequency;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final active = positions.where((position) => position.autoCompound).length;
    return VitCard(
      key: StakingAutoCompoundPage.summaryKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-compound đang bật',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      '$active/${positions.length}',
                      style: AppTextStyles.numericDisplayXl,
                    ),
                    Text(
                      'positions',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox.square(
                dimension: AppSpacing.buttonHero,
                child: Material(
                  color: AppModuleAccents.earn.withValues(alpha: 0.1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xlRadius,
                    side: BorderSide(
                      color: AppModuleAccents.earn,
                      width: EarnSpacingTokens
                          .stakingAutoCompoundHeroIconBorderWidth,
                    ),
                  ),
                  child: const Icon(
                    Icons.autorenew_rounded,
                    color: AppModuleAccents.earn,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Tần suất',
                  value: _frequencyLabel(frequency),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SummaryTile(
                  label: 'Ngưỡng tối thiểu',
                  value: _formatCurrency(threshold, compact: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnStaticSelectPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(value, style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.snapshot});

  final StakingAutoCompoundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX5,
      child: VitRiskDisclaimerNote(message: snapshot.footerNote),
    );
  }
}
