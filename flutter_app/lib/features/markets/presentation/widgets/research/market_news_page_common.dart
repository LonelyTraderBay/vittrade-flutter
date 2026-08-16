part of '../../phone/pages/research/market_news_page.dart';

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    super.key,
    required this.news,
    required this.category,
    required this.sentimentBadge,
    required this.expanded,
    required this.saved,
    required this.onToggleExpanded,
    required this.onToggleSaved,
    required this.onTokenTap,
  });

  final MarketNewsItem news;
  final MarketNewsCategory category;
  final MarketNewsSentimentBadge sentimentBadge;
  final bool expanded;
  final bool saved;
  final VoidCallback onToggleExpanded;
  final VoidCallback onToggleSaved;
  final ValueChanged<String> onTokenTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: news.isBreaking
          ? AppColors.sell.withValues(alpha: .18)
          : null,
      clip: true,
      child: Column(
        children: [
          VitCard(
            onTap: onToggleExpanded,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: EdgeInsets.zero,
            borderColor: AppColors.transparent,
            child: Padding(
              padding: AppSpacing.cardPaddingCompact,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NewsIcon(item: news, category: category),
                  const SizedBox(width: _marketSpace),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NewsTags(
                          news: news,
                          category: category,
                          sentimentBadge: sentimentBadge,
                        ),
                        const SizedBox(height: _marketTinySpace),
                        Text(
                          news.title,
                          maxLines: expanded ? 4 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            height: AppTextStyles.body.height,
                          ),
                        ),
                        const SizedBox(height: _marketTinySpace),
                        _NewsMeta(news: news),
                      ],
                    ),
                  ),
                  const SizedBox(width: _marketTinySpace),
                  VitCard(
                    key: MarketNewsPage.saveKey(news.id),
                    onTap: onToggleSaved,
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.standard,
                    padding: EdgeInsets.zero,
                    borderColor: AppColors.transparent,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
                      child: Icon(
                        saved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: _marketSaveIconSize,
                        color: saved ? _marketPrimary : AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            _ExpandedNewsDetails(news: news, onTokenTap: onTokenTap),
        ],
      ),
    );
  }
}

class _NewsIcon extends StatelessWidget {
  const _NewsIcon({required this.item, required this.category});

  final MarketNewsItem item;
  final MarketNewsCategory category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.color.resolve().withValues(alpha: .08),
      borderRadius: AppRadii.mdRadius,
      child: SizedBox(
        width: _newsIconSize,
        height: _newsIconSize,
        child: Icon(
          MarketIconTokens.icon(item.icon),
          size: _newsIconGlyph,
          color: item.iconColor.resolve(),
        ),
      ),
    );
  }
}

class _NewsTags extends StatelessWidget {
  const _NewsTags({
    required this.news,
    required this.category,
    required this.sentimentBadge,
  });

  final MarketNewsItem news;
  final MarketNewsCategory category;
  final MarketNewsSentimentBadge sentimentBadge;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _marketTinySpace,
      runSpacing: _marketTinySpace,
      children: [
        if (news.isBreaking)
          const _TagPill(label: 'NÓNG', color: AppColors.sell, strong: true),
        _TagPill(
          label: category.label,
          color: category.color.resolve(),
          strong: true,
        ),
        _TagPill(
          label: sentimentBadge.label,
          color: sentimentBadge.color.resolve(),
          icon: _sentimentIcon(news.sentiment),
        ),
      ],
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.color,
    this.icon,
    this.strong = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: strong ? .16 : .08),
      borderRadius: AppRadii.xsRadius,
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
            if (icon != null) ...[
              Icon(icon, size: AppSpacing.x3, color: color),
              const SizedBox(width: _marketTinySpace),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: strong ? AppTextStyles.bold : AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsMeta extends StatelessWidget {
  const _NewsMeta({required this.news});

  final MarketNewsItem news;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.micro.copyWith(color: AppColors.text3);
    return Row(
      children: [
        Flexible(
          child: Text(
            news.source,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        _MetaSeparator(style: style),
        const Icon(
          Icons.schedule_rounded,
          size: AppSpacing.x3,
          color: AppColors.text3,
        ),
        const SizedBox(width: _marketTinySpace),
        Flexible(
          child: Text(
            news.timeAgo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        _MetaSeparator(style: style),
        Flexible(
          child: Text(
            news.readTime,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _MetaSeparator extends StatelessWidget {
  const _MetaSeparator({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.x1,
        end: AppSpacing.x1,
      ),
      child: Text('•', style: style),
    );
  }
}

class _ExpandedNewsDetails extends StatelessWidget {
  const _ExpandedNewsDetails({required this.news, required this.onTokenTap});

  final MarketNewsItem news;
  final ValueChanged<String> onTokenTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: SharedSpacingTokens.homeDividerHeight),
        Padding(
          padding: AppSpacing.cardPaddingCompact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.summary,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppTextStyles.caption.height,
                ),
              ),
              const SizedBox(height: _marketSpace),
              Wrap(
                spacing: _marketTinySpace,
                runSpacing: _marketTinySpace,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Liên quan:',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  for (final token in news.relatedTokens)
                    VitCard(
                      key: MarketNewsPage.tokenKey(token),
                      onTap: () => onTokenTap(token),
                      variant: VitCardVariant.ghost,
                      radius: VitCardRadius.standard,
                      padding: EdgeInsets.zero,
                      borderColor: AppColors.transparent,
                      clip: true,
                      child: DecoratedBox(
                        decoration: const ShapeDecoration(
                          color: AppColors.surface2,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.mdRadius,
                            side: BorderSide(color: AppColors.borderSolid),
                          ),
                        ),
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
                              Text(
                                token,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(width: _marketTinySpace),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: AppSpacing.x3,
                                color: AppColors.text3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewsEmptyState extends StatelessWidget {
  const _NewsEmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          const Icon(
            Icons.article_outlined,
            size: _newsIconSize,
            color: AppColors.text3,
          ),
          const SizedBox(height: _marketSpace),
          Text(
            'Không có tin tức phù hợp',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _marketSpace),
          VitCard(
            onTap: onReset,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: EdgeInsets.zero,
            borderColor: AppColors.transparent,
            clip: true,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: _marketPrimary.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.x3,
                  AppSpacing.x2,
                  AppSpacing.x3,
                  AppSpacing.x2,
                ),
                child: Text(
                  'Xem tất cả',
                  style: AppTextStyles.caption.copyWith(
                    color: _marketPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _sentimentIcon(MarketNewsSentiment sentiment) {
  return switch (sentiment) {
    MarketNewsSentiment.bullish => Icons.trending_up_rounded,
    MarketNewsSentiment.neutral => Icons.remove_rounded,
    MarketNewsSentiment.bearish => Icons.trending_down_rounded,
  };
}
