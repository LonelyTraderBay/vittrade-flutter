part of '../phone/pages/news_page.dart';

List<Widget> _newsPageChildren({
  required NewsScreenSnapshot snapshot,
  required NewsArticleType? activeType,
  required VoidCallback onRetry,
  required ValueChanged<NewsArticle> onArticleTap,
}) {
  return switch (snapshot.screenState) {
    NewsScreenState.loading => [
      const VitSkeletonList(key: NewsPage.loadingKey, rows: 4),
    ],
    NewsScreenState.error => [
      VitErrorState(
        key: NewsPage.errorKey,
        title: 'Không tải được tin tức',
        message: 'Kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
    ],
    NewsScreenState.empty ||
    NewsScreenState.offline when snapshot.articles.isEmpty => [
      VitEmptyState(
        key: NewsPage.emptyKey,
        icon: Icons.newspaper_rounded,
        title: 'Không có tin tức nào',
        message: activeType == null
            ? 'Hãy quay lại sau để xem cập nhật mới.'
            : 'Không có tin thuộc danh mục đã chọn.',
      ),
    ],
    _ => _newsFeedSections(snapshot: snapshot, onArticleTap: onArticleTap),
  };
}

List<Widget> _newsFeedSections({
  required NewsScreenSnapshot snapshot,
  required ValueChanged<NewsArticle> onArticleTap,
}) {
  return [
    if (snapshot.pinnedArticles.isNotEmpty)
      VitPageSection(
        density: VitDensity.compact,
        children: [
          VitModuleSectionHeader(
            title: 'GHIM (${snapshot.pinnedArticles.length})',
            accentColor: AppColors.primary,
            density: VitDensity.compact,
          ),
          for (final article in snapshot.pinnedArticles)
            _NewsArticleCard(
              key: NewsPage.articleCardKey(article.id),
              article: article,
              pinned: true,
              onTap: () => onArticleTap(article),
            ),
        ],
      ),
    if (snapshot.normalArticles.isNotEmpty)
      VitPageSection(
        density: VitDensity.compact,
        children: [
          const VitModuleSectionHeader(
            title: 'TIN TỨC KHÁC',
            accentColor: AppColors.text2,
            density: VitDensity.compact,
          ),
          for (final article in snapshot.normalArticles)
            _NewsArticleCard(
              key: NewsPage.articleCardKey(article.id),
              article: article,
              onTap: () => onArticleTap(article),
            ),
        ],
      ),
  ];
}

class _NewsFilterBar extends StatelessWidget {
  const _NewsFilterBar({
    required this.activeType,
    required this.filters,
    required this.onSelected,
  });

  final NewsArticleType? activeType;
  final List<NewsArticleType> filters;
  final ValueChanged<NewsArticleType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: NewsSpacingTokens.newsFilterBarHeight,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: NewsSpacingTokens.newsFilterBarPadding,
          children: [
            VitFilterChip(
              key: NewsPage.filterAllKey,
              label: 'Tất cả',
              active: activeType == null,
              color: AppColors.primary,
              padding: NewsSpacingTokens.newsFilterChipPadding,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: AppSpacing.x3),
            for (final type in filters) ...[
              VitFilterChip(
                key: NewsPage.filterKey(type),
                label: '${type.emoji}  ${type.label}',
                active: activeType == type,
                color: type.color,
                padding: NewsSpacingTokens.newsFilterChipPadding,
                onTap: () => onSelected(type),
              ),
              const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewsArticleCard extends StatelessWidget {
  const _NewsArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.pinned = false,
  });

  final NewsArticle article;
  final VoidCallback onTap;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return VitCard(
      width: double.infinity,
      variant: pinned ? VitCardVariant.inner : VitCardVariant.standard,
      borderColor: pinned
          ? AppColors.primary.withValues(alpha: .28)
          : AppColors.cardBorder,
      density: VitDensity.compact,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeAvatar(type: type),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ArticleMeta(article: article, pinned: pinned),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Text(
                      article.title,
                      style: AppTextStyles.body.copyWith(
                        height: NewsSpacingTokens.newsTitleLineHeight,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      article.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: NewsSpacingTokens.newsSummaryLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              const Padding(
                padding: NewsSpacingTokens.newsChevronPadding,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: NewsSpacingTokens.newsChevronIconSize,
                ),
              ),
            ],
          ),
          if (article.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.formFieldLabelGap,
              children: [
                for (final tag in article.tags)
                  VitStatusPill(
                    label: tag,
                    status: VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                    icon: Icons.sell_outlined,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ArticleMeta extends StatelessWidget {
  const _ArticleMeta({required this.article, required this.pinned});

  final NewsArticle article;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x1,
      children: [
        if (pinned)
          const Icon(
            Icons.push_pin_rounded,
            size: NewsSpacingTokens.newsSheetCalendarIconSize,
            color: AppColors.primary,
          ),
        VitAccentPill(
          label: type.label,
          accentColor: type.color,
          size: VitStatusPillSize.sm,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: NewsSpacingTokens.newsCalendarIconSize,
              color: AppColors.text3,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              article.publishedAtLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: NewsSpacingTokens.newsLineHeightTight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeAvatar extends StatelessWidget {
  const _TypeAvatar({required this.type});

  final NewsArticleType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: NewsSpacingTokens.newsArticleAvatarSize,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: type.color.withValues(alpha: .18),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Text(type.emoji, style: AppTextStyles.sectionTitleSm),
        ),
      ),
    );
  }
}
