part of '../../phone/pages/research/market_news_page.dart';

class _BreakingNewsCard extends StatelessWidget {
  const _BreakingNewsCard({required this.news});

  final MarketNewsItem news;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell.withValues(alpha: .28),
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: AppColors.sell.withValues(alpha: .16),
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.x2,
                    AppSpacing.x1,
                    AppSpacing.x2,
                    AppSpacing.x1,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.circle,
                        color: AppColors.sell,
                        size: AppSpacing.x2,
                      ),
                      const SizedBox(width: _marketTinySpace),
                      Text(
                        'NÓNG',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: _marketSpace),
              Text(
                news.timeAgo,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: _marketSpace),
          Text(
            news.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.body.height,
            ),
          ),
          const SizedBox(height: _marketSpace),
          Wrap(
            spacing: _marketTinySpace,
            runSpacing: _marketTinySpace,
            children: [
              for (final token in news.relatedTokens)
                Material(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.smRadius,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.x2,
                      AppSpacing.x1,
                      AppSpacing.x2,
                      AppSpacing.x1,
                    ),
                    child: Text(
                      token,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<MarketNewsCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final category in categories) ...[
            VitFilterChip(
              key: category.id == 'all'
                  ? MarketNewsPage.categoryAllKey
                  : category.id == 'breaking'
                  ? MarketNewsPage.categoryBreakingKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              onTap: () => onSelected(category.id),
              color: category.color.resolve(),
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.x2,
                AppSpacing.x1,
                AppSpacing.x2,
                AppSpacing.x1,
              ),
            ),
            if (category != categories.last)
              const SizedBox(width: _marketTinySpace),
          ],
        ],
      ),
    );
  }
}

class _SentimentFilters extends StatelessWidget {
  const _SentimentFilters({
    required this.badges,
    required this.active,
    required this.onSelected,
  });

  final Map<MarketNewsSentiment, MarketNewsSentimentBadge> badges;
  final MarketNewsSentiment? active;
  final ValueChanged<MarketNewsSentiment> onSelected;

  @override
  Widget build(BuildContext context) {
    const order = [
      MarketNewsSentiment.bullish,
      MarketNewsSentiment.neutral,
      MarketNewsSentiment.bearish,
    ];
    return Row(
      children: [
        for (final sentiment in order) ...[
          _SentimentChip(
            key: sentiment == MarketNewsSentiment.bullish
                ? MarketNewsPage.sentimentBullishKey
                : sentiment == MarketNewsSentiment.bearish
                ? MarketNewsPage.sentimentBearishKey
                : null,
            sentiment: sentiment,
            badge: badges[sentiment]!,
            active: active == sentiment,
            onTap: () => onSelected(sentiment),
          ),
          if (sentiment != order.last) const SizedBox(width: _marketTinySpace),
        ],
      ],
    );
  }
}

class _SentimentChip extends StatelessWidget {
  const _SentimentChip({
    super.key,
    required this.sentiment,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  final MarketNewsSentiment sentiment;
  final MarketNewsSentimentBadge badge;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: badge.label,
      selected: active,
      onTap: onTap,
      accentColor: badge.color.resolve(),
      leading: Icon(_sentimentIcon(sentiment), size: AppSpacing.x3),
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.x2,
        AppSpacing.x1,
        AppSpacing.x2,
        AppSpacing.x1,
      ),
    );
  }
}

class _NewsFeed extends StatelessWidget {
  const _NewsFeed({
    required this.news,
    required this.categories,
    required this.badges,
    required this.savedIds,
    required this.expandedId,
    required this.onToggleExpanded,
    required this.onToggleSaved,
    required this.onTokenTap,
  });

  final List<MarketNewsItem> news;
  final List<MarketNewsCategory> categories;
  final Map<MarketNewsSentiment, MarketNewsSentimentBadge> badges;
  final Set<String> savedIds;
  final String? expandedId;
  final ValueChanged<String> onToggleExpanded;
  final ValueChanged<String> onToggleSaved;
  final ValueChanged<String> onTokenTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in news) ...[
          _NewsCard(
            key: MarketNewsPage.newsCardKey(item.id),
            news: item,
            category: categories.firstWhere(
              (category) => category.id == item.category,
              orElse: () => categories.first,
            ),
            sentimentBadge: badges[item.sentiment]!,
            expanded: expandedId == item.id,
            saved: savedIds.contains(item.id),
            onToggleExpanded: () => onToggleExpanded(item.id),
            onToggleSaved: () => onToggleSaved(item.id),
            onTokenTap: onTokenTap,
          ),
          if (item != news.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}
