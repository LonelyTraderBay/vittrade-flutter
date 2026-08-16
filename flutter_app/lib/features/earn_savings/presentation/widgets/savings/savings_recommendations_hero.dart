part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.accent08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardLargeRadius,
          side: BorderSide(
            color: AppColors.accent20,
            width: EarnSpacingTokens.savingsConsumerBorderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accent,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    snapshot.heroSubtitle,
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
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final profile = snapshot.profile;
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Hồ sơ của bạn', style: AppTextStyles.baseMedium),
              ),
              if (profile.hasCompletedAssessment)
                _SmallPill(
                  label: 'Đã đánh giá ${profile.assessmentDate}',
                  color: AppColors.buy,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
              return Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Mức rủi ro',
                      value: _riskToleranceLabel(profile.riskTolerance),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Thời gian đầu tư',
                      value: _horizonLabel(profile.investmentHorizon),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Nhu cầu thanh khoản',
                      value: _liquidityLabel(profile.liquidityNeed),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Tài sản yêu thích',
                      value: profile.preferredAssets.join(', '),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.riskAssessmentRoute);
            },
            child: Text(
              profile.hasCompletedAssessment
                  ? 'Làm lại đánh giá rủi ro'
                  : 'Đánh giá rủi ro',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
