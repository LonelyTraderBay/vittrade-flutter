import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_card.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_comparison_table.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_controls.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_detail_summary.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_sector_distribution.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketSectorsPage extends ConsumerStatefulWidget {
  const MarketSectorsPage({
    super.key,
    this.shellRenderMode,
    this.selectedSectorId,
  });

  static const contentKey = marketSectorsContentKey;
  static const detailContentKey = marketSectorDetailContentKey;
  static const timeframe24hKey = marketSectorTimeframe24hKey;
  static const timeframe7dKey = marketSectorTimeframe7dKey;
  static const timeframe30dKey = marketSectorTimeframe30dKey;
  static const sortPerformanceKey = marketSectorSortPerformanceKey;
  static const sortMarketCapKey = marketSectorSortMarketCapKey;
  static const sortCoinCountKey = marketSectorSortCoinCountKey;
  static const comparisonKey = marketSectorComparisonKey;

  static Key sectorKey(String id) => marketSectorKey(id);

  final ShellRenderMode? shellRenderMode;
  final String? selectedSectorId;

  @override
  ConsumerState<MarketSectorsPage> createState() => _MarketSectorsPageState();
}

class _MarketSectorsPageState extends ConsumerState<MarketSectorsPage> {
  String _timeframe = '24h';
  String _sort = 'performance';

  @override
  Widget build(BuildContext context) {
    final sectorsAsync = ref.watch(marketSectorsSnapshotProvider);
    final sectorsValue = sectorsAsync.value;
    final lastUpdatedLabel = sectorsValue?.lastUpdatedLabel ?? '...';
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? MarketsSpacingTokens.marketSectorsVisualBottomExtra
            : MarketsSpacingTokens.marketSectorsNativeBottomExtra);
    final selectedSector = sectorsValue == null
        ? null
        : findMarketSector(sectorsValue.sectors, widget.selectedSectorId);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: selectedSector == null
          ? 'Ngành thị trường'
          : 'Chi tiết ngành thị trường',
      semanticIdentifier: 'SC-011',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: selectedSector?.nameVi ?? 'Ngành thị trường',
            subtitle: selectedSector == null
                ? 'Phân bổ vốn hóa · Cập nhật $lastUpdatedLabel'
                : '${selectedSector.coinCount} coin · Cập nhật $lastUpdatedLabel',
            showBack: true,
            onBack: () {
              if (selectedSector != null) {
                context.go(AppRoutePaths.marketsSectors);
                return;
              }
              context.go(AppRoutePaths.markets);
            },
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
                    key: selectedSector == null
                        ? MarketSectorsPage.contentKey
                        : MarketSectorsPage.detailContentKey,
                    padding: MarketsSpacingTokens.marketSectorsScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.defaultPadding,
                      gap: VitContentGap.defaultGap,
                      children: sectorsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được ngành thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(marketSectorsSnapshotProvider),
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
                                  MarketSectorDistributionCard(
                                    sectors: snapshot.sectors,
                                  ),
                                  MarketSectorControls(
                                    timeframes: snapshot.timeframes,
                                    activeTimeframe: _timeframe,
                                    sortOptions:
                                        snapshot.screenFilters.sortOptions,
                                    activeSort: _sort,
                                    onTimeframeSelected: (value) {
                                      setState(() => _timeframe = value);
                                    },
                                    onSortSelected: (value) {
                                      setState(() => _sort = value);
                                    },
                                  ),
                                  for (final sector in visibleSectors)
                                    MarketSectorCard(
                                      sector: sector,
                                      change: marketSectorChangeFor(
                                        sector,
                                        _timeframe,
                                      ),
                                      onTap: () => context.go(
                                        '${AppRoutePaths.marketsSectors}?id=${sector.id}',
                                      ),
                                    ),
                                  MarketSectorComparisonTable(
                                    key: MarketSectorsPage.comparisonKey,
                                    sectors: visibleSectors,
                                  ),
                                  MarketSectorDataRefreshFooter(
                                    count: snapshot.sectors.length,
                                    label: snapshot.lastUpdatedLabel,
                                  ),
                                ]
                              : [
                                  MarketSectorDetailSummary(
                                    sector: selectedSector,
                                  ),
                                  MarketSectorTopCoinsSection(
                                    sector: selectedSector,
                                    coins: coinsForMarketSector(
                                      selectedSector,
                                      snapshot,
                                    ),
                                    onTap: (coin) => context.go(
                                      AppRoutePaths.pairDetail(
                                        '${coin.id}usdt',
                                      ),
                                    ),
                                  ),
                                  MarketSectorComparisonTable(
                                    sectors: visibleSectors,
                                    highlightedSectorId: selectedSector.id,
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
}
