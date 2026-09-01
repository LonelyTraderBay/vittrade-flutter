import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/market_icon_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/research/market_news_page_sections.dart';
part '../../../widgets/research/market_news_page_common.dart';

const _marketPrimary = AppColors.primary;
const _marketSpace = AppSpacing.x2;
const _marketTinySpace = AppSpacing.x1;
const _marketVisualScrollClearance = 112.0;
const _marketNativeScrollClearance = 72.0;
const _newsIconSize = 34.0;
const _newsIconGlyph = 18.0;
const _marketSaveIconSize = 20.0;

class MarketNewsPage extends ConsumerStatefulWidget {
  const MarketNewsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc022_market_news_scroll_content');
  static const categoryAllKey = Key('sc022_category_all');
  static const categoryBreakingKey = Key('sc022_category_breaking');
  static const sentimentBullishKey = Key('sc022_sentiment_bullish');
  static const sentimentBearishKey = Key('sc022_sentiment_bearish');

  static Key newsCardKey(String id) => Key('sc022_news_$id');
  static Key saveKey(String id) => Key('sc022_save_$id');
  static Key tokenKey(String token) => Key('sc022_token_$token');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketNewsPage> createState() => _MarketNewsPageState();
}

class _MarketNewsPageState extends ConsumerState<MarketNewsPage> {
  String _category = 'all';
  MarketNewsSentiment? _sentimentFilter;
  final Set<String> _savedIds = <String>{};
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(
      marketNewsSnapshotProvider((
        category: _category,
        sentiment: _sentimentFilter,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _marketVisualScrollClearance
            : _marketNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tin thị trường',
      semanticIdentifier: 'SC-022',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tin thị trường',
            subtitle: 'Tin tức · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: MarketNewsPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: newsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được tin thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketNewsSnapshotProvider((
                                category: _category,
                                sentiment: _sentimentFilter,
                              )),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          if (snapshot.breakingNews.isNotEmpty &&
                              _category == 'all')
                            _BreakingNewsCard(
                              news: snapshot.breakingNews.first,
                            ),
                          _CategoryFilters(
                            categories: snapshot.categories,
                            activeCategory: _category,
                            onSelected: (value) => setState(() {
                              _category = value;
                            }),
                          ),
                          _SentimentFilters(
                            badges: snapshot.sentimentBadges,
                            active: _sentimentFilter,
                            onSelected: (value) => setState(() {
                              _sentimentFilter = _sentimentFilter == value
                                  ? null
                                  : value;
                            }),
                          ),
                          if (snapshot.news.isEmpty)
                            _NewsEmptyState(
                              onReset: () => setState(() {
                                _category = 'all';
                                _sentimentFilter = null;
                              }),
                            )
                          else
                            _NewsFeed(
                              news: snapshot.news,
                              categories: snapshot.categories,
                              badges: snapshot.sentimentBadges,
                              savedIds: _savedIds,
                              expandedId: _expandedId,
                              onToggleExpanded: (id) => setState(() {
                                _expandedId = _expandedId == id ? null : id;
                              }),
                              onToggleSaved: (id) => setState(() {
                                if (_savedIds.contains(id)) {
                                  _savedIds.remove(id);
                                } else {
                                  _savedIds.add(id);
                                }
                              }),
                              onTokenTap: (token) => context.go(
                                AppRoutePaths.pairDetail(
                                  '${token.toLowerCase()}usdt',
                                ),
                              ),
                            ),
                          const VitBanner(
                            variant: VitBannerVariant.info,
                            icon: Icons.info_outline_rounded,
                            message: 'Tin tức chỉ mang tính tham khảo',
                            detail:
                                'Nội dung biên tập không phải khuyến nghị giao dịch. Kiểm tra nguồn trước khi quyết định.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
