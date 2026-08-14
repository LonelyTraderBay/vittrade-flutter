import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/claim/launchpad_batch_claim_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_abi_diff_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_address_book_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_bridge_compare_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_bridge_order_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_contract_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/claim/launchpad_claim_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_dca_builder_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_detail_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_event_log_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_gas_tracker_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_ido_bridge_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_limit_orders_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_multisig_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_notif_sound_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_performance_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_portfolio_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_rebalance_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_risk_analytics_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_staking_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/bridge/launchpad_swap_aggregator_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/tools/launchpad_webhooks_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> launchpadRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.launchpad,
      name: AppRouteNames.sc295Launchpad,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc295Launchpad,
        fallback: LaunchpadPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadPortfolio,
      name: AppRouteNames.sc296LaunchpadPortfolio,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc296LaunchpadPortfolio,
        fallback: LaunchpadPortfolioPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadPerformance,
      name: AppRouteNames.sc297LaunchpadPerformance,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc297LaunchpadPerformance,
        fallback: LaunchpadPerformancePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadStaking,
      name: AppRouteNames.sc298LaunchpadStaking,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc298LaunchpadStaking,
        fallback: LaunchpadStakingPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadIdoBridgeSample,
      name: AppRouteNames.sc299LaunchpadIdoBridge,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc299LaunchpadIdoBridge,
        fallback: LaunchpadIdoBridgePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadContractSample,
      name: AppRouteNames.sc300LaunchpadContract,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc300LaunchpadContract,
        fallback: LaunchpadContractPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadReceiptSub001,
      name: AppRouteNames.sc301LaunchpadReceipt,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc301LaunchpadReceipt,
        fallback: LaunchpadReceiptPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadClaimReceiptPos001,
      name: AppRouteNames.sc302LaunchpadClaimReceipt,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc302LaunchpadClaimReceipt,
        fallback: LaunchpadClaimReceiptPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadBatchClaim,
      name: AppRouteNames.sc304LaunchpadBatchClaim,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc304LaunchpadBatchClaim,
        fallback: LaunchpadBatchClaimPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadBridgeCompare,
      name: AppRouteNames.sc305LaunchpadBridgeCompare,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc305LaunchpadBridgeCompare,
        fallback: LaunchpadBridgeComparePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadNotifSound,
      name: AppRouteNames.sc306LaunchpadNotifSound,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc306LaunchpadNotifSound,
        fallback: LaunchpadNotifSoundPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadEventLog,
      name: AppRouteNames.sc307LaunchpadEventLog,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc307LaunchpadEventLog,
        fallback: LaunchpadEventLogPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadAbiDiff,
      name: AppRouteNames.sc308LaunchpadAbiDiff,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc308LaunchpadAbiDiff,
        fallback: LaunchpadAbiDiffPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadAddressBook,
      name: AppRouteNames.sc309LaunchpadAddressBook,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc309LaunchpadAddressBook,
        fallback: LaunchpadAddressBookPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadWebhooks,
      name: AppRouteNames.sc310LaunchpadWebhooks,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc310LaunchpadWebhooks,
        fallback: LaunchpadWebhooksPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadGasTracker,
      name: AppRouteNames.sc311LaunchpadGasTracker,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc311LaunchpadGasTracker,
        fallback: LaunchpadGasTrackerPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadRebalance,
      name: AppRouteNames.sc312LaunchpadRebalance,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc312LaunchpadRebalance,
        fallback: LaunchpadRebalancePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadMultisig,
      name: AppRouteNames.sc313LaunchpadMultisig,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc313LaunchpadMultisig,
        fallback: LaunchpadMultisigPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadSwapAggregator,
      name: AppRouteNames.sc314LaunchpadSwapAggregator,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc314LaunchpadSwapAggregator,
        fallback: LaunchpadSwapAggregatorPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadLimitOrders,
      name: AppRouteNames.sc315LaunchpadLimitOrders,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc315LaunchpadLimitOrders,
        fallback: LaunchpadLimitOrdersPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadDcaBuilder,
      name: AppRouteNames.sc316LaunchpadDcaBuilder,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc316LaunchpadDcaBuilder,
        fallback: LaunchpadDcaBuilderPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadRiskAnalytics,
      name: AppRouteNames.sc317LaunchpadRiskAnalytics,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc317LaunchpadRiskAnalytics,
        fallback: LaunchpadRiskAnalyticsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadSample,
      name: AppRouteNames.sc318LaunchpadDetail,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc318LaunchpadDetail,
        fallback: LaunchpadDetailPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.launchpadBridgeOrderTx001,
      name: AppRouteNames.sc303LaunchpadBridgeOrder,
      builder: (context, _) => _tabletLaunchpadRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc303LaunchpadBridgeOrder,
        fallback: LaunchpadBridgeOrderPage(shellRenderMode: shellRenderMode),
      ),
    ),
    ...launchpadOutgoingPlaceholders,
  ];
}

Widget _tabletLaunchpadRoute({
  required BuildContext context,
  required AppSurface? surface,
  required String semanticIdentifier,
  required Widget fallback,
}) {
  return buildSurfaceAwareTabletRoute(
    context: context,
    surface: surface,
    semanticIdentifier: semanticIdentifier,
    title: 'Launchpad',
    subtitle: 'Quản trị tài sản phát hành trên Tablet',
    description:
        'Không gian Tablet để theo dõi dự án, giao dịch phát hành và các công cụ Launchpad.',
    backPath: AppRoutePaths.launchpad,
    fallback: fallback,
    icon: Icons.rocket_launch_outlined,
  );
}
