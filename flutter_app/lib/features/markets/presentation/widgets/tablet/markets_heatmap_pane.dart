import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_panels.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_summary.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_heatmap_treemap.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Bản đồ thị trường (SC-013) — treemap + controls dùng lại
/// widget public của trang phone, khung ngoài do MarketsPaneScaffold sở hữu.
class MarketsHeatmapPane extends ConsumerStatefulWidget {
  const MarketsHeatmapPane({super.key});

  static const contentKey = Key('sc013_tablet_content');

  @override
  ConsumerState<MarketsHeatmapPane> createState() => _MarketsHeatmapPaneState();
}

class _MarketsHeatmapPaneState extends ConsumerState<MarketsHeatmapPane> {
  String _category = 'Tất cả';
  String _metric = '24h';
  String? _selectedCoinId;

  List<HeatmapCoin> _visibleCoins(MarketHeatmapSnapshot snapshot) {
    final coins = _category == 'Tất cả'
        ? snapshot.coins
        : snapshot.coins.where((coin) => coin.category == _category).toList();
    return [...coins]..sort((a, b) => b.marketCap.compareTo(a.marketCap));
  }

  double _changeFor(HeatmapCoin coin) {
    return _metric == '7d' ? coin.change7d : coin.change24h;
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(marketHeatmapSnapshotProvider);

    return MarketsPaneScaffold(
      title: 'Bản đồ thị trường',
      subtitle: 'Treemap vốn hóa · Biến động',
      scrollKey: MarketsHeatmapPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketHeatmapSnapshotProvider);
        await ref.read(marketHeatmapSnapshotProvider.future);
      },
      children: heatmapAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được bản đồ thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketHeatmapSnapshotProvider),
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
                  _selectedCoinId = _selectedCoinId == coin.id ? null : coin.id;
                });
              },
            ),
            const MarketHeatmapLegend(),
            if (selectedCoin != null)
              MarketHeatmapSelectedCoinCard(
                coin: selectedCoin,
                onDetail: () => context.go(
                  AppRoutePaths.pairDetail('${selectedCoin.id}usdt'),
                ),
              ),
            MarketHeatmapTrendPanels(coins: visibleCoins, metric: _metric),
          ];
        },
      ),
    );
  }
}
