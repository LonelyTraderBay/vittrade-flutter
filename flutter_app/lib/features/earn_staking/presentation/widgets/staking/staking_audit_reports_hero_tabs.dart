part of '../../phone/pages/staking/staking_audit_reports_page.dart';

class _FeedbackNote extends StatelessWidget {
  const _FeedbackNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final StakingAuditReportsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingAuditBodyLineHeight,
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

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({required this.stats});

  final List<StakingAuditStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.statsKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          for (final stat in stats) ...[
            Expanded(child: _StatItem(stat: stat)),
            if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final StakingAuditStatDraft stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stat.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          stat.value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: _toneColor(stat.tone),
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (stat.caption != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.caption!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
