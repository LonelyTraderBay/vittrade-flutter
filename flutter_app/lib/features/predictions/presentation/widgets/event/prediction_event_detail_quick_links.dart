part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.onRewards, required this.onActivity});

  final VoidCallback onRewards;
  final VoidCallback onActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkCard(
            key: PredictionEventDetailPage.dailyRewardsKey,
            icon: Icons.card_giftcard_rounded,
            color: AppColors.warn,
            title: 'Daily Rewards',
            subtitle: 'Earn by providing liquidity',
            onTap: onRewards,
          ),
        ),
        const SizedBox(
          width: PredictionsSpacingTokens.predictionDetailQuickLinkGap,
        ),
        Expanded(
          child: _QuickLinkCard(
            key: PredictionEventDetailPage.globalActivityKey,
            icon: Icons.timeline_rounded,
            color: _predictionPurple,
            title: 'Global Activity',
            subtitle: 'Live trading feed',
            onTap: onActivity,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: PredictionsSpacingTokens.predictionDetailQuickLinkPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: PredictionsSpacingTokens.predictionDetailQuickLinkIcon,
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionDetailQuickLinkGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
