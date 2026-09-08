import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_card.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_comparison_table.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_controls.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_detail_summary.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_distribution.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Ngành thị trường (SC-011) — nội dung transcribe từ trang
/// phone (toàn bộ widget public), khung ngoài do MarketsPaneScaffold sở hữu.
class MarketsSectorsPane extends ConsumerStatefulWidget {
  const MarketsSectorsPane({super.key, this.selectedSectorId});

  static const contentKey = Key('sc011_tablet_content');

  final String? selectedSectorId;

  @override
  ConsumerState<MarketsSectorsPane> createState() => _MarketsSectorsPaneState();
}

class _MarketsSectorsPaneState extends ConsumerState<MarketsSectorsPane> {
  String _timeframe = '24h';
  String _sort = 'performance';

  @override
  Widget build(BuildContext context) {
    final sectorsAsync = ref.watch(marketSectorsSnapshotProvider);
    final sectorsValue = sectorsAsync.value;
    final selectedSector = sectorsValue == null
        ? null
        : findMarketSector(sectorsValue.sectors, widget.selectedSectorId);

    return MarketsPaneScaffold(
      title: selectedSector?.nameVi ?? 'Ngành thị trường',
      subtitle: 'Phân bổ vốn hóa · Ngành',
      scrollKey: MarketsSectorsPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketSectorsSnapshotProvider);
        await ref.read(marketSectorsSnapshotProvider.future);
      },
      children: sectorsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được ngành thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketSectorsSnapshotProvider),
          ),
        ],
        data: (snapshot) {
          final visibleSectors = visibleMarketSectors(
            snapshot,
            sort: _sort,
            timeframe: _timeframe,
          );
          return selectedSector == null
              ? [
                  MarketSectorDistributionCard(sectors: snapshot.sectors),
                  MarketSectorControls(
                    timeframes: snapshot.timeframes,
                    activeTimeframe: _timeframe,
                    sortOptions: snapshot.screenFilters.sortOptions,
                    activeSort: _sort,
                    onTimeframeSelected: (value) =>
                        setState(() => _timeframe = value),
                    onSortSelected: (value) => setState(() => _sort = value),
                  ),
                  for (final sector in visibleSectors)
                    MarketSectorCard(
                      sector: sector,
                      change: marketSectorChangeFor(sector, _timeframe),
                      onTap: () => context.go(
                        '${AppRoutePaths.marketsSectors}?id=${sector.id}',
                      ),
                    ),
                  MarketSectorComparisonTable(
                    key: MarketsSectorsPane.contentKey,
                    sectors: visibleSectors,
                  ),
                  MarketSectorDataRefreshFooter(
                    count: snapshot.sectors.length,
                    label: snapshot.lastUpdatedLabel,
                  ),
                ]
              : [
                  MarketSectorDetailSummary(sector: selectedSector),
                  MarketSectorTopCoinsSection(
                    sector: selectedSector,
                    coins: coinsForMarketSector(selectedSector, snapshot),
                    onTap: (coin) =>
                        context.go(AppRoutePaths.pairDetail('${coin.id}usdt')),
                  ),
                  MarketSectorComparisonTable(
                    sectors: visibleSectors,
                    highlightedSectorId: selectedSector.id,
                  ),
                ];
        },
      ),
    );
  }
}
