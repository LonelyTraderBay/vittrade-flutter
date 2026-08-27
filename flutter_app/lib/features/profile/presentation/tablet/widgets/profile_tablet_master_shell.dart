import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_master_menu.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_status_content.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Master-detail shell for the Profile tablet surface (SC-156) — the
/// route-based "settings split view": the account menu stays permanently
/// visible in a framed master column while the active `/profile/...`
/// sub-route renders into the detail pane beside it through
/// [StatefulNavigationShell]. Built by the tablet arm of
/// `profileRoutes()`'s `StatefulShellRoute` — navigation stays ordinary
/// `context.go`, so deep links and the system back button keep working
/// exactly as before.
///
/// Widths follow the tablet standard's proven idioms (R4–R8), in three
/// tiers: at/above [TabletDashboardWidths.twoColumnMinWidth] the
/// menu/detail pair is capped and centered as one block (master fixed 308 +
/// detail Expanded — the cap stays 1224, so the slim menu hands its width
/// straight to the pane), mirroring `VitTwoColumnTabletDashboard`'s outer
/// cap; between [TabletDashboardWidths.masterDetailSplitMinWidth] and that
/// tier — real-tablet portrait — the shell KEEPS the split with the same
/// slim master column (308), iPad-Settings portrait semantics, so rotation
/// relayouts sizes without ever changing the composition or swapping to
/// full-page pushes; below the split threshold (window-resize territory)
/// it falls back to a single column — menu stacked above the overview pane
/// on the hub route, detail pane full-width with its own back header on
/// sub-routes. The shell owns the fixed header (R9); panes never render
/// their own top chrome.
class ProfileTabletMasterShell extends ConsumerWidget {
  const ProfileTabletMasterShell({
    super.key,
    required this.navigationShell,
    required this.currentPath,
  });

  final StatefulNavigationShell navigationShell;
  final String currentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(profileSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trang tài khoản: hồ sơ cá nhân, giới thiệu bạn bè và VIP',
      semanticIdentifier: 'SC-156',
      child: Column(
        children: [
          const VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Tài khoản',
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                if (width >= TabletDashboardWidths.twoColumnMinWidth) {
                  return _buildSplitShell(
                    snapshotAsync,
                    masterWidth: TabletDashboardWidths.masterDetailMasterWidth,
                    maxBlockWidth:
                        TabletDashboardWidths.primaryColumnMaxWidth +
                        TabletDashboardWidths.secondaryColumnMaxWidth +
                        TabletDashboardWidths.columnGutter,
                  );
                }
                if (width >= TabletDashboardWidths.masterDetailSplitMinWidth) {
                  return _buildSplitShell(
                    snapshotAsync,
                    masterWidth: TabletDashboardWidths.masterDetailMasterWidth,
                  );
                }
                return _buildNarrowShell(snapshotAsync);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// The split composition shared by both split tiers: framed master
  /// column of [masterWidth] + gutter + detail [Expanded]. [maxBlockWidth]
  /// caps and centers the pair on the wide tier (R8); the portrait tier
  /// passes null — its width is already the viewport's, and centering a
  /// 704dp block would only add dead margins around a split that should
  /// fill edge to edge.
  Widget _buildSplitShell(
    AsyncValue<ProfileSnapshot> snapshotAsync, {
    required double masterWidth,
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
          SizedBox(width: masterWidth, child: _masterColumn(snapshotAsync)),
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

  Widget _buildNarrowShell(AsyncValue<ProfileSnapshot> snapshotAsync) {
    // Single-column fallback — only below masterDetailSplitMinWidth
    // (window-resize territory; real tablets keep the split even in
    // portrait). The hub route stacks the menu above the overview pane
    // (each independently scrollable, bounded by its own Expanded); a
    // sub-route takes the full width and relies on its pane's own back
    // header to return.
    final onHubRoute = currentPath == AppRoutePaths.profile;
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
          Expanded(flex: 5, child: _masterColumn(snapshotAsync)),
          const SizedBox(height: TabletDashboardWidths.columnGutter),
          Expanded(flex: 6, child: navigationShell),
        ],
      ),
    );
  }

  /// The framed master column (R7 framing idiom). Owns its scroll —
  /// [navigationShell]'s panes own theirs — including while the snapshot
  /// resolves, so the skeleton can never overflow the column's flex share.
  Widget _masterColumn(AsyncValue<ProfileSnapshot> snapshotAsync) {
    final menu = SingleChildScrollView(
      child: snapshotAsync.when(
        loading: () => const _MasterMenuSkeleton(),
        error: (error, stackTrace) => const _MasterMenuError(),
        data: (snapshot) =>
            ProfileMasterMenu(snapshot: snapshot, selectedRoute: currentPath),
      ),
    );
    return VitCard(
      key: ProfileTabletKeys.masterMenu,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      clip: true,
      padding: EdgeInsets.zero,
      child: menu,
    );
  }
}

class _MasterMenuSkeleton extends StatelessWidget {
  const _MasterMenuSkeleton();

  @override
  Widget build(BuildContext context) {
    return const VitPageContent(
      rhythm: VitPageRhythm.compact,
      padding: VitContentPadding.compact,
      children: [VitSectionSkeleton(), VitSectionSkeleton()],
    );
  }
}

/// The overview pane carries the full error state; the menu column only
/// needs to stay actionable when the snapshot fails.
class _MasterMenuError extends StatelessWidget {
  const _MasterMenuError();

  @override
  Widget build(BuildContext context) {
    return const VitPageContent(
      rhythm: VitPageRhythm.compact,
      padding: VitContentPadding.compact,
      children: [
        VitEmptyState(
          title: 'Không tải được menu',
          message: 'Kéo để làm mới ở phần tổng quan.',
          icon: Icons.menu_open_rounded,
        ),
      ],
    );
  }
}
