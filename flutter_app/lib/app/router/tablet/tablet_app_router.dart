import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_route_tree.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Router composition root của Tablet.
///
/// Cây route này chỉ lắp ráp page/pane Tablet và utility Tablet. Phone/Web
/// được giữ ở composition root riêng, còn path/name/redirect dùng manifest
/// trung lập để không làm đứt deep-link contract.
GoRouter createTabletAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  final config = appConfig ?? AppConfig.current;
  TabletSpacingTokens.tabletSurfaceActive = true;
  return GoRouter(
    initialLocation: initialLocation ?? _defaultInitialLocation,
    errorBuilder: (context, state) => const TabletRouteErrorPage(),
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
    routes: buildTabletRouteTree(shellRenderMode: shellRenderMode),
  );
}

const String _initialRouteFromEnvironment = String.fromEnvironment(
  'INITIAL_ROUTE',
);

String get _defaultInitialLocation => _initialRouteFromEnvironment.isEmpty
    ? AppRoutePaths.home
    : _initialRouteFromEnvironment;
