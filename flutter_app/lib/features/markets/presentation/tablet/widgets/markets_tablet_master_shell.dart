import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_header.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_master_list.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_navigation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_status_content.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Terminal master-detail shell cho Markets tablet (SC-008): danh sách cặp
/// luôn hiện trong cột master khung trái (search + chips danh mục «Yêu thích
/// » đứng đầu + sort 3 cột), còn detail pane bên phải render route đang
/// hoạt động — tổng quan `/markets` hay phân tích `/pair/:id`... — qua
/// [StatefulNavigationShell]. Navigation vẫn là `context.go` thường nên
/// deep link và nút back hệ thống hoạt động y như trước.
///
/// Widths theo idiom đã kiểm chứng của tablet standard (R4–R8): tại/ngưỡng
/// [TabletDashboardWidths.twoColumnMinWidth] thì cặp master/detail được cap
/// và căn giữa thành một khối (master cố định 400 + detail Expanded); dưới
/// ngưỡng shell rơi về một cột — hub xếp master trên overview pane, sub-route
/// chiếm toàn chiều rộng (pane tự có back header). Shell sở hữu header cố
/// định (R9); panes không tự render top chrome.
class MarketsTabletMasterShell extends ConsumerWidget {
  const MarketsTabletMasterShell({
    super.key,
    required this.navigationShell,
    required this.currentPath,
  });

  final StatefulNavigationShell navigationShell;
  final String currentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(marketListSnapshotProvider);
    final lastUpdatedLabel = ref.watch(
      marketListStateControllerProvider.select(
        (state) => state.snapshot.lastUpdatedLabel,
      ),
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thị trường: danh sách cặp và phân tích chi tiết',
      semanticIdentifier: 'SC-008',
      child: Column(
        children: [
          MarketListHeader(
            onNavigate: (path) => context.go(path),
            lastUpdatedLabel: lastUpdatedLabel,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide =
                    constraints.maxWidth >=
                    TabletDashboardWidths.twoColumnMinWidth;
                return wide
                    ? _buildWideShell(context, ref, snapshotAsync)
                    : _buildNarrowShell(context, ref, snapshotAsync);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideShell(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<MarketListSnapshot> snapshotAsync,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth:
              TabletDashboardWidths.primaryColumnMaxWidth +
              TabletDashboardWidths.secondaryColumnMaxWidth +
              TabletDashboardWidths.columnGutter,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TabletDashboardWidths.outerHorizontalMargin,
            vertical: TabletDashboardWidths.blockVerticalGap,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: TabletDashboardWidths.secondaryColumnMaxWidth,
                child: _masterColumn(context, ref, snapshotAsync),
              ),
              const SizedBox(width: TabletDashboardWidths.columnGutter),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowShell(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<MarketListSnapshot> snapshotAsync,
  ) {
    // Single-column fallback. Hub route xếp master list trên overview pane
    // (mỗi phần tự scroll, bounded bởi Expanded riêng); sub-route chiếm toàn
    // chiều rộng và dựa vào back header của pane để quay lại — cạnh một menu
    // 400px sẽ không còn chiều cao đủ dùng cho detail dưới ngưỡng tablet.
    final onHubRoute = currentPath == AppRoutePaths.markets;
    if (!onHubRoute) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TabletDashboardWidths.outerHorizontalMargin,
          vertical: TabletDashboardWidths.blockVerticalGap,
        ),
        child: navigationShell,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletDashboardWidths.outerHorizontalMargin,
        vertical: TabletDashboardWidths.blockVerticalGap,
      ),
      child: Column(
        children: [
          Expanded(flex: 5, child: _masterColumn(context, ref, snapshotAsync)),
          const SizedBox(height: TabletDashboardWidths.columnGutter),
          Expanded(flex: 6, child: navigationShell),
        ],
      ),
    );
  }

  /// Cột master khung (idiom R7) — tự quản scroll của mình, panes của
  /// [navigationShell] tự quản scroll của chúng, kể cả khi snapshot chưa
  /// resolve, để skeleton không bao giờ tràn cột.
  Widget _masterColumn(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<MarketListSnapshot> snapshotAsync,
  ) {
    final menu = snapshotAsync.when(
      loading: () => const MarketsMasterSkeleton(),
      error: (error, stackTrace) => const MarketsMasterError(),
      data: (_) => MarketsMasterList(
        key: MarketsTabletKeys.masterList,
        selectedPairId: _selectedPairId(),
        // Master rows mở pane qua helper push/replace — back luôn về tổng
        // quan (đúng chuẩn master-detail mục back-stack), khác với
        // `context.go` của header actions (cross-tab).
        onNavigate: (path) => openMarketsDetailRoute(context, path),
        onRefresh: () => _refreshMarkets(ref),
      ),
    );
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      clip: true,
      padding: EdgeInsets.zero,
      child: menu,
    );
  }

  /// Suy cặp đang chọn từ route (`/pair/btcusdt/...` → `btcusdt`) —
  /// selection route-derived, không state cục bộ.
  String? _selectedPairId() {
    if (!currentPath.startsWith('/pair/')) return null;
    final segments = currentPath.split('/');
    return segments.length > 2 && segments[2].isNotEmpty ? segments[2] : null;
  }

  Future<void> _refreshMarkets(WidgetRef ref) async {
    ref.invalidate(marketListSnapshotProvider);
    await ref.read(marketListSnapshotProvider.future);
  }
}
