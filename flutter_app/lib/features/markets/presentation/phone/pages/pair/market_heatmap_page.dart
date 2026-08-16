import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_panels.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_summary.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_treemap.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketHeatmapPage extends ConsumerStatefulWidget {
  const MarketHeatmapPage({super.key, this.shellRenderMode});

  static const contentKey = MarketHeatmapKeys.content;
  static const metric24hKey = MarketHeatmapKeys.metric24h;
  static const metric7dKey = MarketHeatmapKeys.metric7d;
  static const detailButtonKey = MarketHeatmapKeys.detailButton;

  static Key categoryKey(String category) =>
      MarketHeatmapKeys.category(category);

  static Key tileKey(String id) => MarketHeatmapKeys.tile(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketHeatmapPage> createState() => _MarketHeatmapPageState();
}

class _MarketHeatmapPageState extends ConsumerState<MarketHeatmapPage> {
  String _category = 'Tất cả';
  String _metric = '24h';
  String? _selectedCoinId;

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(marketHeatmapSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bản đồ thị trường',
      semanticIdentifier: 'SC-013',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bản đồ thị trường',
            subtitle: 'Quét biến động · Markets',
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
                    key: MarketHeatmapPage.contentKey,
                    padding: MarketsSpacingTokens.marketScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: heatmapAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được bản đồ thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(marketHeatmapSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final visibleCoins = _visibleCoins(snapshot);
                          final selectedCoin = marketHeatmapFindCoin(
                            snapshot.coins,
                            _selectedCoinId,
                          );
                          final totalMarketCap = visibleCoins.fold<double>(
                            0,
                            (sum, coin) => sum + coin.marketCap,
                          );
                          final averageChange = visibleCoins.isEmpty
                              ? 0.0
                              : visibleCoins.fold<double>(
                                      0,
                                      (sum, coin) => sum + _changeFor(coin),
                                    ) /
                                    visibleCoins.length;
                          return [
                            MarketHeatmapSummaryStrip(
                              totalMarketCap: totalMarketCap,
                              averageChange: averageChange,
                              metric: _metric,
                              count: visibleCoins.length,
                            ),
                            MarketHeatmapControls(
                              metrics: snapshot.metrics,
                              activeMetric: _metric,
                              categories: snapshot.screenFilters.categories,
                              activeCategory: _category,
                              onMetricSelected: (value) {
                                setState(() {
                                  _metric = value;
                                  _selectedCoinId = null;
                                });
                              },
                              onCategorySelected: (value) {
                                setState(() {
                                  _category = value;
                                  _selectedCoinId = null;
                                });
                              },
                            ),
                            MarketHeatmapTreemap(
                              coins: visibleCoins,
                              totalMarketCap: totalMarketCap,
                              metric: _metric,
                              selectedCoinId: _selectedCoinId,
                              onCoinSelected: (coin) {
                                setState(() {
                                  _selectedCoinId = _selectedCoinId == coin.id
                                      ? null
                                      : coin.id;
                                });
                              },
                            ),
                            const MarketHeatmapLegend(),
                            if (selectedCoin != null)
                              MarketHeatmapSelectedCoinCard(
                                coin: selectedCoin,
                                onDetail: () => context.go(
                                  AppRoutePaths.pairDetail(
                                    '${selectedCoin.id}usdt',
                                  ),
                                ),
                              ),
                            MarketHeatmapTrendPanels(
                              coins: visibleCoins,
                              metric: _metric,
                            ),
                          ];
                        },
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

  List<HeatmapCoin> _visibleCoins(MarketHeatmapSnapshot snapshot) {
    final coins = _category == 'Tất cả'
        ? snapshot.coins
        : snapshot.coins.where((coin) => coin.category == _category).toList();
    return [...coins]..sort((a, b) => b.marketCap.compareTo(a.marketCap));
  }

  double _changeFor(HeatmapCoin coin) {
    return _metric == '7d' ? coin.change7d : coin.change24h;
  }
}
