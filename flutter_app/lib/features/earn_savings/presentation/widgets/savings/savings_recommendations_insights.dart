part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final SavingsRecommendationInsightDraft insight;

  @override
  Widget build(BuildContext context) {
    final color = _insightColor(insight.tone);
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _insightIcon(insight.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  insight.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppTextStyles.caption.height,
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

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: SavingsRecommendationsPage.riskButtonKey,
            variant: VitCtaButtonVariant.warning,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.riskAssessmentRoute);
            },
            leading: const Icon(Icons.shield_outlined),
            child: const Text('Đánh giá rủi ro'),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: VitCtaButton(
            key: SavingsRecommendationsPage.productsButtonKey,
            variant: VitCtaButtonVariant.success,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.savingsRoute);
            },
            leading: const Icon(Icons.savings_outlined),
            child: const Text('Tất cả sản phẩm'),
          ),
        ),
      ],
    );
  }
}
