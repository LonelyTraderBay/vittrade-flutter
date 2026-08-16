part of '../../phone/pages/staking/staking_risk_score_calculator_page.dart';

class _RiskScoreCard extends StatelessWidget {
  const _RiskScoreCard({
    required this.score,
    required this.label,
    required this.color,
    required this.axes,
  });

  final int score;
  final String label;
  final Color color;
  final List<_RiskRadarAxis> axes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskScoreCalculatorPage.scoreKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        children: [
          Text(
            'Calculated Risk Score',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox(
            width: AppSpacing.x7 * 2,
            height: AppSpacing.x7 * 2,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: 0.12),
                shape: CircleBorder(
                  side: BorderSide(
                    color: color,
                    width: EarnSpacingTokens.stakingRiskScoreBorderWidth,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: AppTextStyles.display.copyWith(
                        color: color,
                        fontFeatures: AppTextStyles.tabularFigures,
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
          DecoratedBox(
            decoration: ShapeDecoration(
              color: color.withValues(alpha: 0.16),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.pillRadius,
              ),
            ),
            child: Padding(
              padding: EarnSpacingTokens.earnWidePillPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: color,
                    size: EarnSpacingTokens.stakingRiskScorePillIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox(
            key: StakingRiskScoreCalculatorPage.radarKey,
            height: AppSpacing.x7 * 3,
            child: _RiskRadarChart(axes: axes, color: color),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection({required this.recommendations});

  final List<StakingRiskScoreRecommendationDraft> recommendations;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingRiskScoreCalculatorPage.recommendationsKey,
      label: 'Recommendations',
      accentColor: AppColors.primarySoft,
      children: [
        for (final recommendation in recommendations)
          _RecommendationCard(recommendation: recommendation),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final StakingRiskScoreRecommendationDraft recommendation;

  @override
  Widget build(BuildContext context) {
    final color = _recommendationColor(recommendation.tone);
    final icon = switch (recommendation.tone) {
      'success' => Icons.check_circle_outline_rounded,
      'warning' => Icons.error_outline_rounded,
      _ => Icons.lightbulb_outline_rounded,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.28),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  recommendation.title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  recommendation.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _recommendationColor(String tone) {
    return switch (tone) {
      'success' => AppColors.buy,
      'warning' => AppColors.warn,
      _ => AppColors.primarySoft,
    };
  }
}

final class _RiskRadarAxis {
  const _RiskRadarAxis({required this.label, required this.value});

  final String label;
  final double value;
}
