part of '../../phone/pages/staking/staking_risk_disclosure_page.dart';

class _AssessmentTab extends StatelessWidget {
  const _AssessmentTab({required this.snapshot, required this.onStart});

  final StakingRiskDisclosureSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: _stakingRiskCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox.square(
                    dimension: _stakingRiskAssessmentIconBox,
                    child: Material(
                      color: AppColors.primary12,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.cardLargeRadius,
                        side: BorderSide(
                          color: AppColors.primary30,
                          width: _stakingRiskBorderWidth,
                        ),
                      ),
                      child: Icon(
                        Icons.balance_rounded,
                        color: AppColors.primary,
                        size: _stakingRiskAssessmentIcon,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.assessmentTitle,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const Padding(
                          padding: EarnSpacingTokens.earnTopPaddingX1,
                        ),
                        Text(
                          snapshot.assessmentSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                snapshot.assessmentBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _stakingRiskBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              VitCtaButton(
                key: StakingRiskDisclosurePage.assessmentCtaKey,
                height: _stakingRiskCtaHeight,
                onPressed: onStart,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: Text(snapshot.assessmentCta),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitSectionHeader(
          title: snapshot.faqTitle,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppColors.primary,
          density: VitDensity.compact,
          titleColor: AppColors.text2,
          titleHeight: _stakingRiskCompactLineHeight,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final faq in snapshot.faqs) ...[
          VitCard(
            radius: VitCardRadius.large,
            padding: _stakingRiskCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  faq.answer,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _stakingRiskNoticeLineHeight,
                  ),
                ),
              ],
            ),
          ),
          if (faq != snapshot.faqs.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _RiskLevelBadge extends StatelessWidget {
  const _RiskLevelBadge({required this.level, this.prefix = false});

  final StakingDisclosureRiskLevel level;
  final bool prefix;

  @override
  Widget build(BuildContext context) {
    final label = prefix
        ? 'Rủi ro ${_riskLevelLabel(level)}'
        : _riskLevelLabel(level);
    final color = _riskColor(level);
    return Material(
      borderRadius: AppRadii.mdRadius,
      color: _riskTint(level),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3X2,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _stakingRiskCompactLineHeight,
          ),
        ),
      ),
    );
  }
}

Color _riskColor(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy,
    StakingDisclosureRiskLevel.medium => AppColors.warn,
    StakingDisclosureRiskLevel.high => AppColors.sell,
  };
}

Color _riskTint(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy10,
    StakingDisclosureRiskLevel.medium => AppColors.warn10,
    StakingDisclosureRiskLevel.high => AppColors.sell10,
  };
}

String _riskLevelLabel(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => 'Thấp',
    StakingDisclosureRiskLevel.medium => 'Trung bình',
    StakingDisclosureRiskLevel.high => 'Cao',
  };
}

IconData _categoryIcon(String id) {
  return switch (id) {
    'market' => Icons.trending_down_rounded,
    'liquidity' => Icons.lock_outline_rounded,
    'slashing' => Icons.report_problem_outlined,
    'smart-contract' => Icons.code_rounded,
    'counterparty' => Icons.business_rounded,
    'regulatory' => Icons.gavel_rounded,
    'technical' => Icons.public_rounded,
    _ => Icons.warning_amber_rounded,
  };
}
