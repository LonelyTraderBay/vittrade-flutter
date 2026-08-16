part of '../../phone/pages/studio/arena_creator_page.dart';

class _CompactStateCard extends StatelessWidget {
  const _CompactStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaCreatorEmptyPadding,
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.text3,
            size: ArenaSpacingTokens.arenaCreatorEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCtaButton(
              onPressed: onAction,
              variant: VitCtaButtonVariant.secondary,
              density: VitDensity.compact,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class _PolicyLink extends StatelessWidget {
  const _PolicyLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: VitCard(
        key: ArenaCreatorPage.policyKey,
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: ArenaSpacingTokens.arenaCreatorPolicyPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.accent,
              size: ArenaSpacingTokens.arenaCreatorInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.accent,
              size: ArenaSpacingTokens.arenaCreatorInlineIcon,
            ),
          ],
        ),
      ),
    );
  }
}

Color _metricColor(ArenaCreatorTrustMetricKind kind) {
  return switch (kind) {
    ArenaCreatorTrustMetricKind.fairPlay => AppColors.buy,
    ArenaCreatorTrustMetricKind.disputeRate => AppColors.buy,
    ArenaCreatorTrustMetricKind.completion => AppColors.primary,
    ArenaCreatorTrustMetricKind.communityRating => AppColors.warn,
  };
}

IconData _metricIcon(ArenaCreatorTrustMetricKind kind) {
  return switch (kind) {
    ArenaCreatorTrustMetricKind.fairPlay => Icons.shield_outlined,
    ArenaCreatorTrustMetricKind.disputeRate => Icons.flag_outlined,
    ArenaCreatorTrustMetricKind.completion => Icons.verified_outlined,
    ArenaCreatorTrustMetricKind.communityRating => Icons.star_outline_rounded,
  };
}
