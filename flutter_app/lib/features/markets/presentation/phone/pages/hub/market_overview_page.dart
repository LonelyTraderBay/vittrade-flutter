import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/app/theme/market_icon_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';

part 'market_overview_page_hero_stats_widgets.dart';
part 'market_overview_page_movers_sectors_widgets.dart';
part 'market_overview_page_history_tools_widgets.dart';

const _marketPrimary = AppColors.primary;
const _sectorPurple = AppColors.accent;
const _btcOrange = AppAssetColors.btc;
const _ethPrimary = AppAssetColors.eth;

class MarketOverviewPage extends ConsumerWidget {
  const MarketOverviewPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc009_market_overview_scroll_content');
  static const quickMoversKey = Key('sc009_quick_movers');
  static const quickSectorsKey = Key('sc009_quick_sectors');
  static const quickHeatmapKey = Key('sc009_quick_heatmap');
  static const topGainersKey = Key('sc009_top_gainers_header');
  static const topLosersKey = Key('sc009_top_losers_header');
  static const allSectorsKey = Key('sc009_all_sectors');
  static const watchlistToolKey = Key('sc009_tool_watchlist');
  static const alertsToolKey = Key('sc009_tool_alerts');
  static const heatmapToolKey = Key('sc009_tool_heatmap');
  static const marketListToolKey = Key('sc009_tool_market_list');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(marketOverviewSnapshotProvider);
    final lastUpdatedLabel = overviewAsync.value?.lastUpdatedLabel ?? '...';
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tổng quan thị trường',
      semanticIdentifier: 'SC-009',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tổng quan thị trường',
            subtitle: 'Dữ liệu tham khảo · Cập nhật $lastUpdatedLabel',
            showBack: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.markets,
              mode: BackNavigationMode.historyThenFallback,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: VitInsetScrollView(
                    key: contentKey,
                    bottomInset: bottomInset,
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: overviewAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được tổng quan thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(marketOverviewSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          _MarketCapHero(stats: snapshot.globalStats),
                          _StatsGrid(stats: snapshot.globalStats),
                          const _QuickNavigation(),
                          _MoversGrid(movers: snapshot.movers),
                          _SentimentGrid(
                            stats: snapshot.globalStats,
                            breadth: snapshot.marketBreadth,
                          ),
                          _SectorPerformance(sectors: snapshot.sectors),
                          _FearGreedHistory(points: snapshot.fearGreedHistory),
                          const _MarketTools(),
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
