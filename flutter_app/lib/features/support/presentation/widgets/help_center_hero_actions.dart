part of '../phone/pages/help_center_page.dart';

class _HelpHero extends StatelessWidget {
  const _HelpHero({
    required this.snapshot,
    required this.controller,
    required this.onChanged,
  });

  final HelpCenterSnapshot snapshot;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: SupportSpacingTokens.supportCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppModuleAccents.support,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextDim,
              height: SupportSpacingTokens.supportLineHeightBody,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          VitSearchBar(
            key: HelpCenterPage.searchKey,
            controller: controller,
            placeholder: snapshot.searchHint,
            variant: VitSearchBarVariant.compact,
            onChanged: onChanged,
            onClear: () => onChanged(''),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.chatRoute, required this.ticketRoute});

  final String chatRoute;
  final String ticketRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            key: HelpCenterPage.chatActionKey,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat hỗ trợ',
            color: AppColors.buy,
            onTap: () => context.go(chatRoute),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _QuickActionButton(
            key: HelpCenterPage.ticketActionKey,
            icon: Icons.support_agent_rounded,
            label: 'Gửi ticket',
            color: AppModuleAccents.support,
            onTap: () => context.go(ticketRoute),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconLabelCard(
      icon: icon,
      label: label,
      accentColor: color,
      padding: SupportSpacingTokens.supportQuickCardPadding,
      onTap: onTap,
    );
  }
}

List<Widget> _helpCenterPageChildren({
  required HelpCenterSnapshot snapshot,
  required List<HelpArticleDraft> articles,
  required TextEditingController searchController,
  required String query,
  required String? selectedCategoryId,
  required String? expandedArticleId,
  required String sectionTitle,
  required ValueChanged<String> onSearchChanged,
  required ValueChanged<String> onCategorySelected,
  required ValueChanged<String> onArticleToggle,
  required VoidCallback onRetry,
}) {
  return switch (snapshot.screenState) {
    SupportScreenState.loading => [
      const VitSkeletonList(key: HelpCenterPage.loadingKey, rows: 4),
    ],
    SupportScreenState.error => [
      VitErrorState(
        key: HelpCenterPage.errorKey,
        title: 'Không tải được trung tâm trợ giúp',
        message: 'Kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
    ],
    SupportScreenState.empty ||
    SupportScreenState.offline when snapshot.articles.isEmpty => [
      const VitEmptyState(
        key: HelpCenterPage.emptyKey,
        title: 'Chưa có bài viết trợ giúp',
        message: 'Nội dung hướng dẫn sẽ được cập nhật tại đây.',
        icon: Icons.menu_book_outlined,
      ),
    ],
    _ => _helpCenterReadySections(
      snapshot: snapshot,
      articles: articles,
      searchController: searchController,
      query: query,
      selectedCategoryId: selectedCategoryId,
      expandedArticleId: expandedArticleId,
      sectionTitle: sectionTitle,
      onSearchChanged: onSearchChanged,
      onCategorySelected: onCategorySelected,
      onArticleToggle: onArticleToggle,
    ),
  };
}

List<Widget> _helpCenterReadySections({
  required HelpCenterSnapshot snapshot,
  required List<HelpArticleDraft> articles,
  required TextEditingController searchController,
  required String query,
  required String? selectedCategoryId,
  required String? expandedArticleId,
  required String sectionTitle,
  required ValueChanged<String> onSearchChanged,
  required ValueChanged<String> onCategorySelected,
  required ValueChanged<String> onArticleToggle,
}) {
  return [
    _HelpHero(
      snapshot: snapshot,
      controller: searchController,
      onChanged: onSearchChanged,
    ),
    _QuickActions(
      chatRoute: snapshot.chatRoute,
      ticketRoute: snapshot.ticketRoute,
    ),
    if (query.isEmpty)
      _CategorySection(
        categories: snapshot.categories,
        selectedCategoryId: selectedCategoryId,
        onSelected: onCategorySelected,
      ),
    _ArticleSection(
      title: sectionTitle,
      articles: articles,
      categories: snapshot.categories,
      expandedArticleId: expandedArticleId,
      onToggle: onArticleToggle,
    ),
  ];
}
