import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_history_master_list.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shell master–detail cho Lịch sử giao dịch trên tablet (SC-136) — idioms
/// "analysis split view" của chuẩn Tablet-Adaptive: master là danh sách
/// làm việc (bộ lọc + thẻ giao dịch) ghim trong khung 308dp, pane chi tiết
/// render route `/wallet/transaction/:txId` qua [StatefulNavigationShell].
/// Selection là route-derived (shell pattern rule 6); hub route
/// `/wallet/history` hiển thị empty state trong pane khi chưa chọn gì.
///
/// Ba tầng width (zero orientation dispatch): ≥900 tách đôi và căn giữa
/// theo cap 1224 như `VitTwoColumnTabletDashboard`; 680–899 (tablet dọc
/// thật) GIỮ split với cùng master 308; dưới 680 (window-resize) fallback
/// một cột — hub render danh sách toàn chiều rộng, sub-route render pane
/// toàn chiều rộng với back header riêng của pane.
class WalletTabletHistoryShell extends ConsumerWidget {
  const WalletTabletHistoryShell({
    super.key,
    required this.navigationShell,
    required this.currentPath,
  });

  final StatefulNavigationShell navigationShell;
  final String currentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(walletTransactionHistoryProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử giao dịch trên tablet',
      semanticIdentifier: 'SC-136-TABLET',
      child: Column(
        children: [
          VitHeader(
            title: 'Lịch sử giao dịch',
            subtitle: 'Theo dõi nạp, rút và giao dịch · Ví',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                if (width >= TabletDashboardWidths.twoColumnMinWidth) {
                  return _buildSplitShell(
                    snapshotAsync,
                    maxBlockWidth:
                        TabletDashboardWidths.primaryColumnMaxWidth +
                        TabletDashboardWidths.secondaryColumnMaxWidth +
                        TabletDashboardWidths.columnGutter,
                  );
                }
                if (width >= TabletDashboardWidths.masterDetailSplitMinWidth) {
                  return _buildSplitShell(snapshotAsync);
                }
                return _buildNarrowShell(snapshotAsync);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitShell(
    AsyncValue<WalletTransactionHistorySnapshot> snapshotAsync, {
    double? maxBlockWidth,
  }) {
    Widget block = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletDashboardWidths.outerHorizontalMargin,
        vertical: TabletDashboardWidths.blockVerticalGap,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: TabletDashboardWidths.masterDetailMasterWidth,
            child: _masterColumn(snapshotAsync),
          ),
          const SizedBox(width: TabletDashboardWidths.columnGutter),
          Expanded(child: navigationShell),
        ],
      ),
    );
    if (maxBlockWidth != null) {
      block = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBlockWidth),
          child: block,
        ),
      );
    }
    return block;
  }

  Widget _buildNarrowShell(
    AsyncValue<WalletTransactionHistorySnapshot> snapshotAsync,
  ) {
    // Hub route: danh sách chiếm toàn chiều rộng thay cho pane trống.
    if (currentPath == AppRoutePaths.walletHistory) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TabletDashboardWidths.outerHorizontalMargin,
          vertical: TabletDashboardWidths.blockVerticalGap,
        ),
        child: _masterColumn(snapshotAsync),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletDashboardWidths.outerHorizontalMargin,
        vertical: TabletDashboardWidths.blockVerticalGap,
      ),
      child: navigationShell,
    );
  }

  /// Master column khung (R7): card inner owns trọn 12dp inset, content
  /// full-bleed; tự sở hữu scroll trong khi snapshot đang tải.
  Widget _masterColumn(
    AsyncValue<WalletTransactionHistorySnapshot> snapshotAsync,
  ) {
    final list = SingleChildScrollView(
      child: snapshotAsync.when(
        loading: () => const _MasterListSkeleton(),
        error: (error, stackTrace) => const _MasterListError(),
        data: (snapshot) => WalletHistoryMasterList(
          snapshot: snapshot,
          currentPath: currentPath,
        ),
      ),
    );
    return VitCard(
      key: WalletTabletHistoryShell.masterListKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      clip: true,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: list,
    );
  }

  static Key get masterListKey => const Key('sc136_wallet_history_master_list');
}

class _MasterListSkeleton extends StatelessWidget {
  const _MasterListSkeleton();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList();
  }
}

/// Pane chi tiết mang error state đầy đủ; master chỉ cần giữ hành động
/// được khi snapshot lỗi.
class _MasterListError extends StatelessWidget {
  const _MasterListError();

  @override
  Widget build(BuildContext context) {
    return const VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      children: [
        VitEmptyState(
          title: 'Không tải được lịch sử',
          message: 'Thử lại từ pane chi tiết hoặc quay lại ví.',
          icon: Icons.receipt_long_outlined,
        ),
      ],
    );
  }
}
