part of '../phone/pages/help_center_page.dart';

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<HelpCategoryDraft> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HelpCenterPage.categoriesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Danh mục',
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        GridView.builder(
          padding: AppSpacing.zeroInsets,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SupportSpacingTokens.supportCategoryGridColumns,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio:
                SupportSpacingTokens.supportCategoryGridAspectRatio,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryTile(
              category: category,
              selected: selectedCategoryId == category.id,
              onTap: () => onSelected(category.id),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final HelpCategoryDraft category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = _categoryColor(category.id);
    return VitCard(
      key: HelpCenterPage.categoryKey(category.id),
      radius: VitCardRadius.standard,
      borderColor: selected ? AppColors.primary40 : null,
      padding: SupportSpacingTokens.supportCardPadding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _categoryIcon(category.id),
            color: iconColor,
            size: SupportSpacingTokens.supportCategoryIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.primary : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            '${category.count} bài viết',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({
    required this.title,
    required this.articles,
    required this.categories,
    required this.expandedArticleId,
    required this.onToggle,
  });

  final String title;
  final List<HelpArticleDraft> articles;
  final List<HelpCategoryDraft> categories;
  final String? expandedArticleId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HelpCenterPage.articlesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        if (articles.isEmpty)
          const VitEmptyState(
            key: HelpCenterPage.emptyKey,
            title: 'Không tìm thấy bài viết',
            message: 'Thử tìm kiếm bằng từ khóa khác hoặc chọn danh mục khác.',
            icon: Icons.search_off_rounded,
          )
        else
          Column(
            children: [
              for (var i = 0; i < articles.length; i++) ...[
                if (i > 0)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _ArticleTile(
                  article: articles[i],
                  category: categories.firstWhere(
                    (category) => category.id == articles[i].categoryId,
                  ),
                  expanded: expandedArticleId == articles[i].id,
                  onTap: () => onToggle(articles[i].id),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.article,
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final HelpArticleDraft article;
  final HelpCategoryDraft category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = _categoryColor(category.id);
    return VitCard(
      key: HelpCenterPage.articleKey(article.id),
      radius: VitCardRadius.standard,
      padding: SupportSpacingTokens.supportQuickCardPadding,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _categoryIcon(category.id),
            color: iconColor,
            size: SupportSpacingTokens.supportArticleIcon,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: expanded ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      color: AppColors.text3,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      _compactViews(article.views),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    article.summary,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: SupportSpacingTokens.supportLineHeightBody,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          AnimatedRotation(
            turns: expanded ? .25 : 0,
            duration: const Duration(milliseconds: 160),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _categoryIcon(String id) => switch (id) {
  'getting-started' => Icons.rocket_launch_rounded,
  'trading' => Icons.bar_chart_rounded,
  'deposit-withdraw' => Icons.account_balance_wallet_rounded,
  'security' => Icons.lock_rounded,
  'p2p' => Icons.handshake_rounded,
  'kyc' => Icons.assignment_rounded,
  'fees' => Icons.diamond_rounded,
  'api' => Icons.bolt_rounded,
  _ => Icons.help_outline_rounded,
};

Color _categoryColor(String id) => switch (id) {
  'getting-started' => AppColors.sell,
  'trading' => AppColors.buy,
  'deposit-withdraw' => AppColors.warn,
  'security' => AppModuleAccents.support,
  'p2p' => AppColors.buy,
  'kyc' => AppColors.sell,
  'fees' => AppColors.primarySoft,
  'api' => AppModuleAccents.support,
  _ => AppColors.text2,
};

String _compactViews(int value) =>
    VitFormat.compactSuffix(value, stripTrailingZero: true);
