part of '../../phone/pages/staking/staking_suitability_assessment_page.dart';

class _ResultView extends ConsumerWidget {
  const _ResultView({
    required this.snapshot,
    required this.profile,
    required this.score,
    required this.onReset,
  });

  final StakingSuitabilityAssessmentSnapshot snapshot;
  final StakingSuitabilityProfileDraft profile;
  final int score;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _profileColor(profile.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          density: VitDensity.compact,
          state: VitHighRiskUiState.success,
          title: 'Suitability result ready',
          message:
              'Review recommended products, allocation limits, lockup terms, annual reassessment and next steps before subscribing.',
          contractId: 'staking-suitability-result',
        ),
        VitCard(
          key: StakingSuitabilityAssessmentPage.resultCardKey,
          radius: VitCardRadius.large,
          borderColor: color.withValues(alpha: 0.6),
          padding: _stakingSuitabilityCardPadding,
          child: Column(
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: CircleBorder(
                    side: BorderSide(
                      color: color,
                      width:
                          EarnSpacingTokens.stakingAssessmentScoreBorderWidth,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: _stakingSuitabilityScoreRing,
                  height: _stakingSuitabilityScoreRing,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$score',
                          style: AppTextStyles.heroNumber.copyWith(
                            color: color,
                          ),
                        ),
                        Text(
                          '/ 100',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                '${profile.label} Investor',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle.copyWith(color: color),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                profile.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _stakingSuitabilityBodyLineHeight,
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'Recommended Products',
          accentColor: color,
          density: VitDensity.compact,
          children: [
            for (final product in profile.products)
              _RecommendedProduct(product: product, color: color),
          ],
        ),
        if (profile.warning != null)
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: _stakingSuitabilityCardPadding,
            child: Text(
              profile.warning!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _stakingSuitabilityBodyLineHeight,
              ),
            ),
          ),
        VitCtaButton(
          key: StakingSuitabilityAssessmentPage.exploreButtonKey,
          density: VitDensity.compact,
          onPressed: () => context.go(snapshot.stakingRoute),
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Explore Recommended Products'),
        ),
        VitCtaButton(
          key: StakingSuitabilityAssessmentPage.resetButtonKey,
          variant: VitCtaButtonVariant.secondary,
          density: VitDensity.compact,
          onPressed: onReset,
          leading: const Icon(Icons.refresh_rounded),
          child: const Text('Retake Assessment'),
        ),
        VitCard(
          variant: VitCardVariant.inner,
          padding: _stakingSuitabilityCardPadding,
          child: Text(
            'This assessment is valid until ${snapshot.validUntil}. You must re-assess annually or if your financial situation changes significantly.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _stakingSuitabilityFooterLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendedProduct extends StatelessWidget {
  const _RecommendedProduct({required this.product, required this.color});

  final String product;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingSuitabilityCardPadding,
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(child: Text(product, style: AppTextStyles.baseMedium)),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

Color _profileColor(StakingSuitabilityProfileLevel level) {
  return switch (level) {
    StakingSuitabilityProfileLevel.conservative => AppColors.buy,
    StakingSuitabilityProfileLevel.moderate => AppColors.primarySoft,
    StakingSuitabilityProfileLevel.aggressive => AppColors.warn,
  };
}
