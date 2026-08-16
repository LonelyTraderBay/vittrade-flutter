import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_data_viz_colors.dart';
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

part '../../../widgets/tools/market_correlations_tabs_widgets.dart';
part '../../../widgets/tools/market_correlations_matrix_widgets.dart';
part '../../../widgets/tools/market_correlations_pairs_widgets.dart';
part '../../../widgets/tools/market_correlations_diversification_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _corrVisualScrollClearance = 108;
const double _corrNativeScrollClearance = 72;
const double _corrChipGap = AppSpacing.x2;
const double _corrTimeframeChipHeight = AppSpacing.buttonCompact;
const double _corrMatrixGap = AppSpacing.x2;
const double _corrInfoTitleGap = AppSpacing.x1;
const double _corrBodyLineHeight = 1.25;
const double _corrInsightValueGap = AppSpacing.x1;
const double _corrInsightSubGap = AppSpacing.x1;
const double _corrRecommendationTitleGap = AppSpacing.x1;
const double _corrHeroLabelGap = AppSpacing.x1;
const double _corrHeroProgressGap = AppSpacing.x2;
const double _corrHeroProgressHeight = 6;
const double _corrHeroScaleGap = AppSpacing.x1;
const double _corrMetricValueGap = AppSpacing.x1;
const double _corrScoreBarHeight = 6;

class MarketCorrelationsPage extends ConsumerStatefulWidget {
  const MarketCorrelationsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc026_correlations_scroll_content');
  static const matrixTabKey = Key('sc026_tab_matrix');
  static const pairsTabKey = Key('sc026_tab_pairs');
  static const diversifyTabKey = Key('sc026_tab_diversify');
  static const timeframe7dKey = Key('sc026_timeframe_7d');
  static const timeframe30dKey = Key('sc026_timeframe_30d');
  static const timeframe90dKey = Key('sc026_timeframe_90d');
  static const sortHighKey = Key('sc026_sort_high');
  static const sortLowKey = Key('sc026_sort_low');
  static const matrixCardKey = Key('sc026_matrix_card');

  static Key pairKey(String pair) => Key('sc026_pair_$pair');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketCorrelationsPage> createState() =>
      _MarketCorrelationsPageState();
}

class _MarketCorrelationsPageState
    extends ConsumerState<MarketCorrelationsPage> {
  String _tab = 'matrix';
  MarketCorrelationTimeframe _timeframe = MarketCorrelationTimeframe.d7;
  CorrelationSortOrder _sortOrder = CorrelationSortOrder.high;

  @override
  Widget build(BuildContext context) {
    final correlationsAsync = ref.watch(
      marketCorrelationsSnapshotProvider((
        timeframe: _timeframe,
        sortOrder: _sortOrder,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _corrVisualScrollClearance
            : _corrNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tương quan thị trường',
      semanticIdentifier: 'SC-026',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tương quan thị trường',
            subtitle: 'Tương quan · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CorrelationTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: MarketCorrelationsPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: correlationsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được tương quan thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketCorrelationsSnapshotProvider((
                                timeframe: _timeframe,
                                sortOrder: _sortOrder,
                              )),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _TimeframeChips(
                            timeframe: _timeframe,
                            onSelected: (value) =>
                                setState(() => _timeframe = value),
                          ),
                          if (_tab == 'matrix') ...[
                            _MatrixCard(snapshot: snapshot),
                            const _CorrelationLegend(),
                            const _MatrixInfoCard(),
                            _QuickInsights(
                              score: snapshot.diversificationScore,
                            ),
                            _RecommendationCard(
                              recommendation:
                                  snapshot.diversificationScore.recommendation,
                            ),
                          ] else if (_tab == 'pairs') ...[
                            _SortChips(
                              sortOrder: _sortOrder,
                              onSelected: (value) =>
                                  setState(() => _sortOrder = value),
                            ),
                            for (
                              var index = 0;
                              index < snapshot.pairs.length;
                              index += 1
                            )
                              _PairCorrelationRow(
                                key: MarketCorrelationsPage.pairKey(
                                  '${snapshot.pairs[index].assetA}-${snapshot.pairs[index].assetB}',
                                ),
                                rank: index + 1,
                                pair: snapshot.pairs[index],
                                timeframe: _timeframe,
                                maxValue: _maxCorrelation(snapshot),
                              ),
                          ] else ...[
                            _DiversificationHero(
                              score: snapshot.diversificationScore,
                            ),
                            _DiversificationMetrics(
                              score: snapshot.diversificationScore,
                            ),
                            const VitSectionHeader(
                              title: 'So sánh theo thời gian',
                              accentColor: AppColors.accent,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                              variant: VitSectionHeaderVariant.accentBar,
                            ),
                            _TimeframeScoreCard(sortOrder: _sortOrder),
                            const _CorrelationDisclaimer(),
                          ],
                          const VitBanner(
                            variant: VitBannerVariant.info,
                            icon: Icons.info_outline_rounded,
                            message: 'Tương quan chỉ mang tính tham khảo',
                            detail:
                                'Không phải khuyến nghị phân bổ. Quá khứ không đảm bảo kết quả tương lai.',
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

  double _maxCorrelation(MarketCorrelationsSnapshot snapshot) {
    return snapshot.pairs
        .map((pair) => _correlationValueFor(pair, _timeframe))
        .reduce((a, b) => a > b ? a : b);
  }
}
