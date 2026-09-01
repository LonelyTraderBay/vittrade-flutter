import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/admin_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/arena_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/auth_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/dca_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/earn_savings_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/earn_staking_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/home_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/launchpad_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/markets_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/p2p_account_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/p2p_dispute_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/p2p_marketplace_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/p2p_orders_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/p2p_security_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/predictions_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/profile_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/support_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/trade_bots_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/trade_compliance_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/trade_copy_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/trade_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/trade_terminal_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/utility_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/wallet_routes.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/router/visual_qa_route_metadata.dart';
import 'package:vit_trade_flutter/app/shell/phone/phone_app_shell.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';

const String _initialRouteFromEnvironment = String.fromEnvironment(
  'INITIAL_ROUTE',
);

String get _phoneDefaultInitialLocation => _initialRouteFromEnvironment.isEmpty
    ? AppRoutePaths.home
    : _initialRouteFromEnvironment;

/// Builds the complete Phone route tree without importing the Tablet or Web
/// presentation trees. Route groups below use the Phone builders directly.
GoRouter createPhoneRouteTree({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  final config = appConfig ?? AppConfig.current;
  TabletSpacingTokens.tabletSurfaceActive = false;
  return GoRouter(
    initialLocation: initialLocation ?? _phoneDefaultInitialLocation,
    errorBuilder: (context, state) => const VitRouteErrorPage(),
    redirect: (context, state) {
      final path = state.uri.path;
      final onMaintenanceGate = path == AppRoutePaths.maintenanceGate;
      final onForceUpdateGate = path == AppRoutePaths.forceUpdateGate;
      if (config.maintenanceMode) {
        return onMaintenanceGate ? null : AppRoutePaths.maintenanceGate;
      }
      if (config.forceUpdateRequired) {
        return onForceUpdateGate ? null : AppRoutePaths.forceUpdateGate;
      }
      if (onMaintenanceGate || onForceUpdateGate) return AppRoutePaths.home;
      return null;
    },
    routes: [
      ...topLevelRoutes(shellRenderMode),
      ShellRoute(
        builder: (context, state, child) => _PhoneRouteShell(
          renderMode: shellRenderMode,
          currentPath: state.uri.path,
          child: child,
        ),
        routes: [
          ...homeRoutes(shellRenderMode),
          ...marketsRoutes(shellRenderMode),
          ...predictionRoutes(shellRenderMode),
          ...marketPairRoutes(shellRenderMode),
          ...tradeComplianceRoutes(shellRenderMode),
          ...tradeCopyRoutes(shellRenderMode),
          ...tradeBotsRoutes(shellRenderMode),
          ...tradeTerminalRoutes(shellRenderMode),
          ...tradeRoutes(shellRenderMode),
          ...adminRoutes(shellRenderMode),
          ...p2pMarketplaceRoutes(shellRenderMode),
          ...p2pOrdersRoutes(shellRenderMode),
          ...p2pAccountRoutes(shellRenderMode),
          ...p2pSecurityRoutes(shellRenderMode),
          ...p2pDisputeRoutes(shellRenderMode),
          ...supportRoutes(shellRenderMode),
          ...launchpadRoutes(shellRenderMode),
          ...arenaCoreRoutes(shellRenderMode),
          ...utilityRoutes(shellRenderMode),
          ...earnStakingRoutes(shellRenderMode),
          ...earnSavingsRoutes(shellRenderMode),
          ...arenaExtendedRoutes(shellRenderMode),
          ...dcaRoutes(shellRenderMode),
          ...walletRoutes(shellRenderMode),
          ...profileRoutes(shellRenderMode),
          ...discoveryAndReferralRoutes(shellRenderMode),
          ...navigationPlaceholderRoutes,
        ],
      ),
    ],
  );
}

class _PhoneRouteShell extends ConsumerWidget {
  const _PhoneRouteShell({
    required this.renderMode,
    required this.currentPath,
    required this.child,
  });

  final ShellRenderMode renderMode;
  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationBadgeCount = ref.watch(notificationUnreadCountProvider);
    final activeDestination = activeDestinationForPath(currentPath);
    final statusBarTime = renderMode.usesVisualQaFrame ? '23:27' : null;

    void onDestinationSelected(VitBottomNavDestination destination) {
      context.go(destination.routePath);
    }

    final shell = PhoneAppShell(
      renderMode: renderMode,
      currentPath: currentPath,
      activeDestination: activeDestination,
      notificationBadgeCount: notificationBadgeCount,
      statusBarTime: statusBarTime,
      onDestinationSelected: onDestinationSelected,
      child: child,
    );
    return renderMode.usesVisualQaFrame ? VitPhoneFrame(child: shell) : shell;
  }
}
