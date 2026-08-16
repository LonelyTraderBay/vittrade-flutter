part of '../../phone/pages/security/p2p_achievements_page.dart';

class _TradingLevelLink extends StatelessWidget {
  const _TradingLevelLink({required this.snapshot});

  final P2PAchievementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAchievementsPage.tradingLevelKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pTrustProgressCardPadding,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(snapshot.tradingLevelRoute);
      },
      child: Row(
        children: [
          const _AchievementIconBubble(
            icon: Icons.trending_up_rounded,
            color: AppColors.primary,
            showBadge: false,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem cấp bậc giao dịch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Nâng cấp để mở thêm quyền lợi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

IconData _achievementIcon(String iconKey) {
  return switch (iconKey) {
    'bolt' => Icons.bolt_rounded,
    'target' => Icons.track_changes_rounded,
    'medal' => Icons.workspace_premium_outlined,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'star' => Icons.star_border_rounded,
    'users' => Icons.groups_2_outlined,
    _ => Icons.emoji_events_outlined,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'warning' => AppModuleAccents.p2p,
    'accent' => AppColors.accent,
    'highlight' => AppColors.sell,
    'orange' => AppColors.primary,
    _ => AppColors.primary,
  };
}
