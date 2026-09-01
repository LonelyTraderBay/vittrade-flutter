import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

part '../../../widgets/research/social_sentiment_tabs_widgets.dart';
part '../../../widgets/research/social_sentiment_overview_widgets.dart';
part '../../../widgets/research/social_sentiment_token_widgets.dart';
part '../../../widgets/research/social_sentiment_trends_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _sentimentVisualScrollClearance = 108;
const double _sentimentNativeScrollClearance = 72;
const double _sentimentHeroHeaderGap = AppSpacing.x2;
const double _sentimentHeroScoreGap = AppSpacing.x2;
const double _sentimentHeroGaugeGap = AppSpacing.x2;
const double _sentimentHeroGaugeHeight = 6;
const double _sentimentHeroLegendGap = AppSpacing.x1;
const double _sentimentStatGap = AppSpacing.x2;
const double _sentimentStatIcon = AppSpacing.iconSm;
const double _sentimentStatIconGap = AppSpacing.x1;
const double _sentimentStatValueGap = AppSpacing.x1;
const double _sentimentStatSubGap = AppSpacing.x1;
const double _sentimentDominanceTitleGap = AppSpacing.x2;
const double _sentimentDominanceBarHeight = 14;
const double _sentimentDominanceLegendGap = AppSpacing.x3;
const double _sentimentLegendDot = AppSpacing.x2;
const double _sentimentLegendGap = AppSpacing.x1;
const double _sentimentTimelineTimeWidth = 52;
const double _sentimentTimelineTimeGap = AppSpacing.x2;
const double _sentimentTimelineScoreGap = AppSpacing.x2;
const double _sentimentTimelineScoreWidth = 24;
const double _sentimentTimelineBarHeight = 5;
const double _sentimentListGap = AppSpacing.x2;
const double _sentimentAvatarLg = AppSpacing.buttonCompact;
const double _sentimentAvatarMd = 34;
const double _sentimentRowGap = AppSpacing.x2;
const double _sentimentStatusDot = AppSpacing.x2;
const double _sentimentSortGap = AppSpacing.x2;
const double _sentimentSplitBarHeight = 5;
const double _sentimentTokenMetricGap = AppSpacing.x2;
const double _sentimentTopicGap = AppSpacing.x2;
const int _sentimentHeatmapCrossAxisCount = 4;
const double _sentimentHeatmapGap = 6;
const double _sentimentHeatmapAspectRatio = 1.05;
const double _sentimentLeaderboardGap = AppSpacing.x2;
const double _sentimentLeaderboardRowGap = AppSpacing.x2;
const double _sentimentLeaderboardRankWidth = 16;
const double _sentimentVelocitySymbolWidth = 42;
const double _sentimentVelocityBarHeight = 5;
const double _sentimentVelocityGap = AppSpacing.x2;
const double _sentimentVelocityValueWidth = 50;
const EdgeInsetsGeometry _sentimentHeroPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsGeometry _sentimentHeroScorePadding =
    EdgeInsetsDirectional.only(bottom: AppSpacing.x1);
const EdgeInsetsGeometry _sentimentStatPadding = EdgeInsetsDirectional.all(
  AppSpacing.x2,
);
const EdgeInsetsGeometry _sentimentDominancePadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsGeometry _sentimentTimelinePadding =
    EdgeInsetsDirectional.fromSTEB(
      AppSpacing.x3,
      AppSpacing.x2,
      AppSpacing.x3,
      AppSpacing.x2,
    );
const EdgeInsetsGeometry _sentimentTimelineRowPadding =
    EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x1);
const EdgeInsetsGeometry _sentimentRowPadding = EdgeInsetsDirectional.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x2,
);
const EdgeInsetsGeometry _sentimentSortChipPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsGeometry _sentimentTokenDetailPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsGeometry _sentimentTopicCardPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsGeometry _sentimentLeaderboardRowPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsGeometry _sentimentVelocityRowPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );

class SocialSentimentPage extends ConsumerStatefulWidget {
  const SocialSentimentPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc020_social_sentiment_scroll_content');
  static const overviewTabKey = Key('sc020_tab_overview');
  static const tokenTabKey = Key('sc020_tab_token');
  static const trendsTabKey = Key('sc020_tab_trends');
  static const timelineCardKey = Key('sc020_timeline_card');

  static Key sortKey(MarketSentimentSort sort) =>
      Key('sc020_sort_${sort.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SocialSentimentPage> createState() =>
      _SocialSentimentPageState();
}

class _SocialSentimentPageState extends ConsumerState<SocialSentimentPage> {
  String _tab = 'overview';
  MarketSentimentSort _sortBy = MarketSentimentSort.sentiment;

  @override
  Widget build(BuildContext context) {
    final sentimentAsync = ref.watch(
      marketSocialSentimentSnapshotProvider(_sortBy),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _sentimentVisualScrollClearance
            : _sentimentNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tâm lý thị trường',
      semanticIdentifier: 'SC-020',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tâm lý thị trường',
            subtitle: 'Tâm lý xã hội · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SentimentTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: SocialSentimentPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: sentimentAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được tâm lý thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketSocialSentimentSnapshotProvider(_sortBy),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          if (_tab == 'overview') ...[
                            _SentimentHero(global: snapshot.global),
                            _SentimentStats(global: snapshot.global),
                            _SocialDominanceCard(global: snapshot.global),
                            const VitSectionHeader(
                              title: 'Diễn biến 7 ngày',
                              accentColor: _marketPrimary,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                              variant: VitSectionHeaderVariant.accentBar,
                            ),
                            _TimelineCard(points: snapshot.timeline),
                            const VitSectionHeader(
                              title: 'Xu hướng nóng',
                              accentColor: AppColors.warn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                              variant: VitSectionHeaderVariant.accentBar,
                            ),
                            _TrendingList(
                              tokens: snapshot.trendingTokens.take(4).toList(),
                            ),
                          ] else if (_tab == 'token') ...[
                            _SentimentSortChips(
                              active: _sortBy,
                              onSelected: (value) => setState(() {
                                _sortBy = value;
                              }),
                            ),
                            for (final token in snapshot.tokens)
                              _TokenDetailCard(token: token),
                          ] else ...[
                            _TopicCloud(tokens: snapshot.tokens),
                            const VitSectionHeader(
                              title: 'Bản đồ tâm lý',
                              accentColor: AppColors.accent,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                              variant: VitSectionHeaderVariant.accentBar,
                            ),
                            _SentimentHeatmap(tokens: snapshot.tokens),
                            _TrendLeaderboards(tokens: snapshot.tokens),
                            const VitSectionHeader(
                              title: 'Tốc độ đề cập (24h)',
                              accentColor: AppAssetColors.cyanChain,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                              variant: VitSectionHeaderVariant.accentBar,
                            ),
                            _MentionVelocity(tokens: snapshot.tokens),
                          ],
                          const VitBanner(
                            variant: VitBannerVariant.info,
                            icon: Icons.info_outline_rounded,
                            message: 'Chỉ số tâm lý chỉ mang tính tham khảo',
                            detail:
                                'Không phải khuyến nghị giao dịch. Dữ liệu xã hội có thể trễ hoặc thiên lệch.',
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
