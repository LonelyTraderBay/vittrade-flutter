part of '../app_router.dart';

GoRouter createAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
  AppSurface? surface,
}) {
  final config = appConfig ?? AppConfig.current;
  return GoRouter(
    initialLocation: initialLocation ?? _defaultInitialLocation,
    // SEC-S45: route không khớp -> trang lỗi tiếng Việt thay ErrorScreen
    // mặc định tiếng Anh của go_router.
    errorBuilder: (context, state) => const VitRouteErrorPage(),
    // GĐ4-F1 kill-switch: redirect toàn cục sang 1 trong 2 trang gate khi
    // maintenanceMode/forceUpdateRequired bật, và tự đưa người dùng ra khỏi
    // gate khi cả 2 cờ đều tắt (không nhốt user ở lại trang gate).
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
      if (onMaintenanceGate || onForceUpdateGate) {
        return AppRoutePaths.home;
      }
      return null;
    },
    routes: [
      ...topLevelRoutes(shellRenderMode, surface: surface),
      _appShellRoute(shellRenderMode, surface: surface),
    ],
  );
}

ShellRoute _appShellRoute(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return ShellRoute(
    builder: (context, state, child) {
      final activeDestination = _activeDestinationForPath(state.uri.path);
      return Consumer(
        builder: (context, ref, _) {
          final notificationBadgeCount = ref.watch(
            notificationUnreadCountProvider,
          );
          final statusBarTime = shellRenderMode.usesVisualQaFrame
              ? _visualQaStatusBarTimeForUri(state.uri)
              : null;
          void onDestinationSelected(VitBottomNavDestination destination) {
            context.go(destination.routePath);
          }

          final appShell = switch (surface) {
            AppSurface.phone => PhoneAppShell(
              renderMode: shellRenderMode,
              currentPath: state.uri.path,
              activeDestination: activeDestination,
              notificationBadgeCount: notificationBadgeCount,
              statusBarTime: statusBarTime,
              onDestinationSelected: onDestinationSelected,
              child: child,
            ),
            AppSurface.tablet => TabletAppShell(
              renderMode: shellRenderMode,
              activeDestination: activeDestination,
              notificationBadgeCount: notificationBadgeCount,
              statusBarTime: statusBarTime,
              onDestinationSelected: onDestinationSelected,
              child: child,
            ),
            AppSurface.web => WebAppShell(
              renderMode: shellRenderMode,
              activeDestination: activeDestination,
              notificationBadgeCount: notificationBadgeCount,
              statusBarTime: statusBarTime,
              onDestinationSelected: onDestinationSelected,
              child: child,
            ),
            null => VitAppShell(
              renderMode: shellRenderMode,
              currentPath: state.uri.path,
              activeDestination: activeDestination,
              notificationBadgeCount: notificationBadgeCount,
              statusBarTime: statusBarTime,
              onDestinationSelected: onDestinationSelected,
              child: child,
            ),
          };

          if (!shellRenderMode.usesVisualQaFrame) return appShell;
          return VitPhoneFrame(child: appShell);
        },
      );
    },
    routes: [
      ...homeRoutes(shellRenderMode, surface: surface),
      ...marketsRoutes(shellRenderMode, surface: surface),
      ...predictionRoutes(shellRenderMode),
      ...marketPairRoutes(shellRenderMode),
      ...tradeComplianceRoutes(shellRenderMode),
      ...tradeCopyRoutes(shellRenderMode),
      ...tradeBotsRoutes(shellRenderMode),
      // NOTE: `tradeTerminalRoutes` must stay BEFORE `tradeRoutes`: the
      // terminal group registers literal `/trade/...` paths (risk-management,
      // execution-quality, advanced-tools, ...) that would otherwise be
      // shadowed by the parameterized `/trade/:pairId` route at the end of
      // `tradeRoutes` (go_router matches in declaration order).
      ...tradeTerminalRoutes(shellRenderMode),
      ...tradeRoutes(shellRenderMode, surface: surface),
      ...adminRoutes(shellRenderMode),
      // ADR-012: P2P family route groups
      // (marketplace → orders → account → security → dispute).
      ...p2pMarketplaceRoutes(shellRenderMode),
      ...p2pOrdersRoutes(shellRenderMode),
      ...p2pAccountRoutes(shellRenderMode, surface: surface),
      ...p2pSecurityRoutes(shellRenderMode, surface: surface),
      ...p2pDisputeRoutes(shellRenderMode, surface: surface),
      ...supportRoutes(shellRenderMode),
      ...launchpadRoutes(shellRenderMode),
      ...arenaCoreRoutes(shellRenderMode),
      ...utilityRoutes(shellRenderMode),
      ...earnStakingRoutes(shellRenderMode),
      ...earnSavingsRoutes(shellRenderMode),
      ...arenaExtendedRoutes(shellRenderMode),
      ...dcaRoutes(shellRenderMode),
      ...walletRoutes(shellRenderMode, surface: surface),
      ...profileRoutes(shellRenderMode, surface: surface),
      ...discoveryAndReferralRoutes(shellRenderMode),
      ...navigationPlaceholderRoutes,
    ],
  );
}
