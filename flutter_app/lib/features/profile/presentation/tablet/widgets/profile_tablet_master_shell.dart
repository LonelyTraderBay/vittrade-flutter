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
/// Widths follow the tablet standard's proven idioms (R4–R8): at/above
/// [TabletDashboardWidths.twoColumnMinWidth] the menu/detail pair is capped
/// and centered as one block (master fixed 400 + detail Expanded), mirroring
/// `VitTwoColumnTabletDashboard`'s outer cap; below it the shell falls back
/// to a single column — the menu stacked above the overview pane on the hub
/// route, and the detail pane full-width (with its own back header) on
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
                final wide =
                    constraints.maxWidth >=
                    TabletDashboardWidths.twoColumnMinWidth;
                return wide
                    ? _buildWideShell(snapshotAsync)
                    : _buildNarrowShell(snapshotAsync);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideShell(AsyncValue<ProfileSnapshot> snapshotAsync) {
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
                child: _masterColumn(snapshotAsync),
              ),
              const SizedBox(width: TabletDashboardWidths.columnGutter),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowShell(AsyncValue<ProfileSnapshot> snapshotAsync) {
    // Single-column fallback. The hub route stacks the menu above the
    // overview pane (each independently scrollable, bounded by its own
    // Expanded); a sub-route takes the full width and relies on its pane's
    // own back header to return — beside a 400px menu there would be no
    // usable detail height left below the tablet threshold.
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
