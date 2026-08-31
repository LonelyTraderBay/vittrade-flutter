import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_chart.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_whale_alerts.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_chart_math.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_navigation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

part 'markets_pair_detail_pane_sections.dart';
part 'markets_pair_detail_pane_tables.dart';
part 'markets_pair_detail_pane_chart.dart';
part 'markets_pair_detail_pane_depth.dart';
part 'markets_pair_detail_pane_terminal.dart';
part 'markets_pair_detail_pane_painter.dart';

/// Ba khung nhìn của pane phân tích cặp — mirror `_PairView` của trang
/// Phone, đặt public để test tablet khóa theo key chuỗi. `depth` là khung
/// thứ tư thêm 2026-08-29 (P1 "một UI chi tiết coin hoàn chỉnh"): gom phân
/// tích độ sâu vào đúng pane của coin, thay link card điều hướng trang riêng.
enum MarketsPairView { chart, orderBook, trades, depth }

String marketsPairViewKey(MarketsPairView view) => switch (view) {
  MarketsPairView.chart => 'chart',
  MarketsPairView.orderBook => 'orderBook',
  MarketsPairView.trades => 'trades',
  MarketsPairView.depth => 'depth',
};

MarketsPairView marketsPairViewFromKey(String key) => switch (key) {
  'orderBook' => MarketsPairView.orderBook,
  'trades' => MarketsPairView.trades,
  'depth' => MarketsPairView.depth,
  _ => MarketsPairView.chart,
};

/// Detail pane phân tích cặp (SC-044) của Markets terminal master-detail:
/// nội dung port từ `PairDetailPage` Phone theo R2 (widget private của part
/// family Phone được viết lại thành public panel tablet ở `_sections`),
/// cùng provider `marketPairDetailSnapshotProvider(pairId)`. Render trong
/// detail column của shell — pane không tự vẽ top chrome, chỉ header riêng
/// với back dưới ngưỡng 2 cột.
class MarketsPairDetailPane extends ConsumerStatefulWidget {
  const MarketsPairDetailPane({super.key, required this.pairId});

  final String pairId;

  @override
  ConsumerState<MarketsPairDetailPane> createState() =>
      _MarketsPairDetailPaneState();
}

class _MarketsPairDetailPaneState extends ConsumerState<MarketsPairDetailPane> {
  MarketsPairView _activeView = MarketsPairView.chart;
  String _timeframe = '1H';
  final Set<String> _indicators = {'MA'};

  Future<void> _refresh() async {
    ref.invalidate(marketPairDetailSnapshotProvider(widget.pairId));
    await ref.read(marketPairDetailSnapshotProvider(widget.pairId).future);
  }

  void _goTrade(String side) {
    unawaited(
      context.push('${AppRoutePaths.tradePair(widget.pairId)}?side=$side'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      marketPairDetailSnapshotProvider(widget.pairId),
    );
    final favorite = ref.watch(
      marketListStateControllerProvider.select(
        (state) => state.favoriteIds.contains(widget.pairId),
      ),
    );

    return detailAsync.when(
      loading: () => MarketsPaneScaffold(
        title: widget.pairId.toUpperCase(),
        subtitle: 'Phân tích cặp giao dịch',
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.markets,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => MarketsPaneScaffold(
        title: widget.pairId.toUpperCase(),
        subtitle: 'Phân tích cặp giao dịch',
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.markets,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          VitErrorState(
            title: 'Không tải được chi tiết cặp',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
      ),
      data: (snapshot) {
        final pair = snapshot.pair;
        // Hướng 1 "Trading Desk": pane đủ rộng (≥ pairDeskSplitMinWidth)
        // tách 2 cột + dải đáy ghim; hẹp hơn giữ khuôn 1 cột 4 tab. Phân
        // nhánh theo CHIỀU RỘNG pane một lần ở đây — không đụng quy tắc
        // zero-orientation-dispatch (thay đổi kích thước window relayout,
        // không đổi composition theo hướng xoay).
        return LayoutBuilder(
          builder: (context, constraints) {
            final desk =
                constraints.maxWidth >=
                MarketsSpacingTokens.pairDeskSplitMinWidth;
            return MarketsPaneScaffold(
              title: pair.symbol,
              subtitle: 'Phân tích cặp giao dịch',
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.markets,
                mode: BackNavigationMode.historyThenFallback,
              ),
              onRefresh: _refresh,
              scrollKey: MarketsTabletKeys.pairPaneContent,
              headerActions: [
                VitHeaderActionItem(
                  key: MarketsTabletKeys.pairPaneFavorite,
                  type: favorite
                      ? VitHeaderActionType.favoriteOn
                      : VitHeaderActionType.favoriteOff,
                  tooltip: favorite
                      ? 'Bỏ theo dõi ${pair.symbol}'
                      : 'Theo dõi ${pair.symbol}',
                  onPressed: () => ref
                      .read(marketListStateControllerProvider.notifier)
                      .toggleFavorite(pair.id),
                ),
              ],
              footer: desk
                  ? _PairDeskFooter(
                      pair: pair,
                      onBuy: () => _goTrade('buy'),
                      onSell: () => _goTrade('sell'),
                    )
                  : null,
              // Terminal thuần: desk thay TOÀN BỘ vùng cuộn bằng grid cố
              // định (meta | chart/độ sâu | sổ lệnh + giao dịch | mini-tab).
              body: desk
                  ? _PairTerminalShell(
                      snapshot: snapshot,
                      activeView: _activeView,
                      onViewChanged: (view) =>
                          setState(() => _activeView = view),
                      timeframe: _timeframe,
                      indicators: _indicators,
                      workspace: _PairChartWorkspace(
                        series: snapshot.activeChartSeries,
                        pairId: pair.id,
                        positive: pair.change24h >= 0,
                        timeframe: _timeframe,
                        onTimeframeChanged: (value) =>
                            setState(() => _timeframe = value),
                        indicators: _indicators,
                        onIndicatorToggle: (value) => setState(() {
                          if (_indicators.contains(value)) {
                            _indicators.remove(value);
                          } else {
                            _indicators.add(value);
                          }
                        }),
                        onAdvanced: () => unawaited(
                          context.push(
                            AppRoutePaths.tradeAdvancedChart(pair.id),
                          ),
                        ),
                        desk: true,
                      ),
                    )
                  : null,
              children: [
                if (!desk) MarketsPairPriceOverviewPanel(pair: pair),
                if (!desk)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PairViewTabs(
                        activeView: _activeView,
                        onChanged: (view) => setState(() => _activeView = view),
                      ),
                      if (_activeView == MarketsPairView.chart)
                        _PairChartWorkspace(
                          series: snapshot.activeChartSeries,
                          pairId: pair.id,
                          positive: pair.change24h >= 0,
                          timeframe: _timeframe,
                          onTimeframeChanged: (value) =>
                              setState(() => _timeframe = value),
                          indicators: _indicators,
                          onIndicatorToggle: (value) => setState(() {
                            if (_indicators.contains(value)) {
                              _indicators.remove(value);
                            } else {
                              _indicators.add(value);
                            }
                          }),
                          onAdvanced: () => unawaited(
                            context.push(
                              AppRoutePaths.tradeAdvancedChart(pair.id),
                            ),
                          ),
                        )
                      else if (_activeView == MarketsPairView.orderBook)
                        MarketsPairOrderBookPanel(snapshot: snapshot)
                      else if (_activeView == MarketsPairView.trades)
                        MarketsPairTradesPanel(trades: snapshot.recentTrades)
                      else
                        _PairDepthWorkspace(pairId: widget.pairId),
                    ],
                  ),
                const _PairRiskWarning(),
                VitPageSection(
                  // 2 VitCard cách nhau đúng cardGap (13) — gap mặc định tight
                  // (8) từng ép sát 2 link card giữa các section gap 13.
                  customGap: TabletSpacingTokens.cardGap,
                  children: [
                    // Thứ tự bậc thông tin 2026-08-29: phân tích (Thông tin coin)
                    // đứng trước khuyến nghị giao dịch (Mua định kỳ); phân tích
                    // độ sâu đã gom thành tab "Độ sâu" của pane này.
                    MarketsPairLinkCard(
                      icon: Icons.info_outline_rounded,
                      iconColor: marketListPrimary,
                      title: 'Thông tin ${pair.baseAsset}',
                      subtitle: 'Tokenomics · On-chain · Dự án',
                      onTap: () => openMarketsDetailRoute(
                        context,
                        AppRoutePaths.pairInfo(pair.id),
                      ),
                    ),
                    MarketsPairLinkCard(
                      icon: Icons.repeat_rounded,
                      iconColor: AppColors.accent,
                      title: 'Mua định kỳ ${pair.baseAsset}',
                      subtitle: 'Tự động mua theo lịch · Giảm rủi ro biến động',
                      onTap: () => unawaited(context.push(AppRoutePaths.dca)),
                    ),
                  ],
                ),
                if (!desk)
                  _PairTradeCtas(
                    pairId: pair.id,
                    onBuy: () => _goTrade('buy'),
                    onSell: () => _goTrade('sell'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
