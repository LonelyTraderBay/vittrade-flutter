part of '../../phone/pages/hub/predictions_rewards_page.dart';

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      borderColor: AppColors.accent20,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: AppColors.warn10,
                borderRadius: AppRadii.cardRadius,
                child: SizedBox.square(
                  dimension: VitDensity.compact.controlHeight,
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.warn,
                    size: PredictionsSpacingTokens.predictionRewardsHeroIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Rewards',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                      ),
                    ),
                    Text(
                      'Earn rewards by placing competitive limit orders',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: PredictionsSpacingTokens.predictionRewardsPoolIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'Total daily pool:',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                '\$${snapshot.totalDailyPool.toStringAsFixed(0)}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HowItWorksNote extends StatelessWidget {
  const _HowItWorksNote();

  @override
  Widget build(BuildContext context) {
    return const VitAnnouncementBanner(
      message:
          'Đặt lệnh limit (không phải market) trong Max Spread và giữ tối thiểu '
          'Min Shares. Phần thưởng phân phối hàng ngày lúc 00:00 UTC — không '
          'phải lợi nhuận đảm bảo.',
      icon: Icons.info_outline_rounded,
      accentColor: _predictionPrimary,
      variant: VitAnnouncementBannerVariant.compact,
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.categories,
    required this.activeCategory,
    required this.favoritesOnly,
    required this.onCategoryChanged,
    required this.onFavoritesToggle,
  });

  final List<String> categories;
  final String activeCategory;
  final bool favoritesOnly;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onFavoritesToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: VitDensity.compact.controlHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return VitChoicePill(
              key: PredictionsRewardsPage.favoritesFilterKey,
              label: 'Favs',
              selected: favoritesOnly,
              onTap: onFavoritesToggle,
              accentColor: AppColors.sell,
              padding: PredictionsSpacingTokens.predictionRewardsFilterPadding,
              leading: const Icon(
                Icons.favorite_rounded,
                size: PredictionsSpacingTokens.predictionRewardsFilterIcon,
              ),
            );
          }
          final category = categories[index - 1];
          return VitChoicePill(
            key: category == 'All'
                ? PredictionsRewardsPage.allFilterKey
                : category == 'Live Crypto'
                ? PredictionsRewardsPage.liveCryptoFilterKey
                : Key('sc032_filter_$category'),
            label: category,
            selected: activeCategory == category,
            onTap: () => onCategoryChanged(category),
            accentColor: _predictionPrimary,
            padding: PredictionsSpacingTokens.predictionRewardsFilterPadding,
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x2),
        itemCount: categories.length + 1,
      ),
    );
  }
}
