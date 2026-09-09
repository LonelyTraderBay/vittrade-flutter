import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/news_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

/// Bố cục tablet của Tin tức & Thông báo (SC-047): chip lọc loại tin +
/// danh sách bài dạng hàng rộng (mở rộng xem nội dung), resolve snapshot
/// theo filter như trang phone.
class NewsTabletPage extends ConsumerStatefulWidget {
  const NewsTabletPage({super.key});

  static const contentKey = Key('sc047_tablet_content');

  @override
  ConsumerState<NewsTabletPage> createState() => _NewsTabletPageState();
}

class _NewsTabletPageState extends ConsumerState<NewsTabletPage> {
  NewsArticleType? _activeType;
  String? _expandedId;

  NewsScreenSnapshot _resolve(
    NewsScreenSnapshot snapshot,
    NewsArticleType? activeType,
  ) {
    if (activeType == null) return snapshot;
    return NewsScreenSnapshot(
      articles: [
        for (final article in snapshot.articles)
          if (article.type == activeType) article,
      ],
      pinnedArticles: [
        for (final article in snapshot.pinnedArticles)
          if (article.type == activeType) article,
      ],
      normalArticles: [
        for (final article in snapshot.normalArticles)
          if (article.type == activeType) article,
      ],
      newsReferenceData: snapshot.newsReferenceData,
      screenState: snapshot.screenState,
      supportedStates: snapshot.supportedStates,
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawSnapshot = ref.watch(newsSnapshotProvider);
    final showBack = context.canPop();
    final resolved = rawSnapshot.value == null
        ? null
        : _resolve(rawSnapshot.value!, _activeType);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tin tức & Thông báo',
      semanticIdentifier: 'SC-047',
      child: Column(
        children: [
          VitHeader(
            title: 'Tin tức & Thông báo',
            subtitle: 'Sản phẩm · bảo trì · niêm yết',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.home,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: rawSnapshot.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được tin tức',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(newsSnapshotProvider),
                ),
              ),
              data: (_) {
                final snapshot = resolved!;
                return VitTabletSectionBody(
                  contentKey: NewsTabletPage.contentKey,
                  children: [
                    Wrap(
                      spacing: TabletSpacingTokens.x3,
                      runSpacing: TabletSpacingTokens.x2,
                      children: [
                        for (final type in snapshot.newsReferenceData.filters)
                          VitFilterChip(
                            label: type.label,
                            active: _activeType == type,
                            onTap: () => setState(() {
                              _activeType = _activeType == type ? null : type;
                            }),
                            color: AppColors.primary,
                          ),
                      ],
                    ),

                    if (snapshot.articles.isEmpty)
                      const VitEmptyState(
                        icon: Icons.newspaper_rounded,
                        title: 'Khong co tin phu hop',
                        message: 'Thu bo loc loai tin.',
                      )
                    else
                      VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.zeroInsets,
                        clip: true,
                        child: Column(
                          children: [
                            for (final article in snapshot.articles)
                              _ArticleTile(
                                article: article,
                                expanded: _expandedId == article.id,
                                onToggle: () => setState(() {
                                  _expandedId = _expandedId == article.id
                                      ? null
                                      : article.id;
                                }),
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.article,
    required this.expanded,
    required this.onToggle,
  });

  final NewsArticle article;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: TabletSpacingTokens.tilePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    maxLines: expanded ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x3),
                if (article.isPinned)
                  const Icon(
                    Icons.push_pin_rounded,
                    size: TabletSpacingTokens.iconSm,
                    color: AppColors.primary,
                  )
                else
                  Text(
                    article.publishedAtLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: TabletSpacingTokens.x2),
              Text(
                article.summary,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x2),
              if (article.tags.isNotEmpty)
                Text(
                  article.tags.join(' · '),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
