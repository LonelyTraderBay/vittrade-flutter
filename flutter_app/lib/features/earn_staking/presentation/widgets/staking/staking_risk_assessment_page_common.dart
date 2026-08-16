part of '../../phone/pages/staking/staking_risk_assessment_page.dart';

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.result,
    required this.score,
    required this.maxScore,
    required this.onReset,
  });

  final StakingRiskAssessmentSnapshot snapshot;
  final StakingRiskProfileResultDraft result;
  final int score;
  final int maxScore;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final accent = _profileAccent(result.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.success,
          title: 'Staking risk profile ready',
          message:
              'Review validator risk, lockup, APY variability, liquidity limits and confirmation path before subscribing.',
          contractId: 'staking-risk-assessment-result',
        ),
        VitCard(
          key: StakingRiskAssessmentPage.resultCardKey,
          radius: VitCardRadius.large,
          borderColor: accent,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ResultIcon(color: accent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hồ sơ rủi ro của bạn:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          result.label,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: accent,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Text(
                          result.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: AppTextStyles.caption.height,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _ScoreMeter(score: score, maxScore: maxScore, color: accent),
            ],
          ),
        ),
        VitPageSection(
          label: 'Gợi ý cho bạn',
          accentColor: accent,
          children: [
            for (final recommendation in result.recommendations)
              _BulletRow(text: recommendation, color: accent),
          ],
        ),
        VitPageSection(
          label: 'Sản phẩm phù hợp',
          accentColor: AppColors.buy,
          children: [
            for (final product in result.products)
              _ProductTile(product: product),
          ],
        ),
        VitPageSection(
          label: 'Lưu ý',
          accentColor: AppColors.warn,
          children: [
            for (final warning in result.warnings)
              _BulletRow(text: warning, color: AppColors.warn),
          ],
        ),
        VitInfoCallout(
          message: snapshot.footerDisclaimer,
          icon: Icons.info_outline_rounded,
          accentColor: AppColors.primary,
          padding: EarnSpacingTokens.earnCardPaddingX3,
        ),
        VitCtaButton(
          key: StakingRiskAssessmentPage.exploreButtonKey,
          onPressed: () {
            unawaited(HapticFeedback.selectionClick());
            context.go(snapshot.stakingRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Khám phá sản phẩm'),
        ),
        VitCtaButton(
          key: StakingRiskAssessmentPage.resetButtonKey,
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.refresh_rounded),
          onPressed: onReset,
          child: const Text('Làm lại'),
        ),
      ],
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color,
            width: EarnSpacingTokens.stakingAssessmentOptionBorderWidth,
          ),
          borderRadius: AppRadii.xlRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Center(
          child: Icon(
            Icons.shield_outlined,
            color: color,
            size: AppSpacing.iconLg,
          ),
        ),
      ),
    );
  }
}

class _ScoreMeter extends StatelessWidget {
  const _ScoreMeter({
    required this.score,
    required this.maxScore,
    required this.color,
  });

  final int score;
  final int maxScore;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = maxScore == 0 ? 0.0 : score / maxScore;

    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: VitProgressBar(
        progress: progress,
        label: 'Điểm của bạn:',
        trailingLabel: '$score/$maxScore điểm',
        color: color,
        trackColor: AppColors.surface3,
        height: AppSpacing.pageRhythmCompactInnerGap,
        gap: AppSpacing.pageRhythmStandardInnerGap,
        borderRadius: AppRadii.xlRadius,
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitBulletRow(
      text: text,
      icon: Icons.check_circle_rounded,
      color: color,
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final StakingRiskAssessmentProductDraft product;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Rủi ro: ${product.risk}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.apy,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'APY',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _profileAccent(StakingRiskProfileLevel level) {
  return switch (level) {
    StakingRiskProfileLevel.conservative => AppColors.buy,
    StakingRiskProfileLevel.moderate => AppColors.warn,
    StakingRiskProfileLevel.aggressive => AppColors.sell,
  };
}
