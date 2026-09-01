import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/edit_profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/activity_log_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/api_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/api_key_create_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/device_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/kyc_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/widgets/profile_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/security_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/settings_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/sub_account_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/vip_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> profileRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.profile,
      name: AppRouteNames.sc156Profile,
      // Web surface composition is migrated in P7.
      builder: (_, _) => ProfilePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileEdit,
      name: AppRouteNames.sc157EditProfile,
      // Master-detail tablet renders the real edit pane beside the menu.
      builder: (_, _) => EditProfilePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileKyc,
      name: AppRouteNames.sc159Kyc,
      // Master-detail tablet renders the real KYC pane beside the menu.
      builder: (_, _) => KYCPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileSecurity,
      name: AppRouteNames.sc158Security,
      // Master-detail tablet renders the real security pane beside the
      // menu.
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileSettings,
      name: AppRouteNames.sc160Settings,
      // Master-detail tablet renders the real settings pane beside the
      // menu.
      builder: (_, _) => SettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileActivity,
      name: AppRouteNames.sc161ActivityLog,
      // Master-detail tablet renders the real activity pane beside the
      // menu.
      builder: (_, _) => ActivityLogPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileApi,
      name: AppRouteNames.sc163ApiManagement,
      // Master-detail tablet renders the real API pane beside the menu.
      builder: (_, _) => ApiManagementPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileApiCreate,
      name: AppRouteNames.sc162ApiKeyCreate,
      // Master-detail tablet renders the real create-key pane beside the
      // menu.
      builder: (_, _) => ApiKeyCreatePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileVip,
      name: AppRouteNames.sc164Vip,
      // Master-detail tablet renders the real VIP pane beside the menu.
      builder: (_, _) => VIPPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileDevices,
      name: AppRouteNames.sc165DeviceManagement,
      // Master-detail tablet renders the real devices pane beside the
      // menu.
      builder: (_, _) => DeviceManagementPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profileSubAccounts,
      name: AppRouteNames.sc166SubAccount,
      // Master-detail tablet renders the real sub-accounts pane beside the
      // menu.
      builder: (_, _) => SubAccountPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.profilePredictions,
      name: AppRouteNames.sc167ProfilePredictions,
      redirect: (_, _) => AppRoutePaths.marketsPredictionsPortfolio,
    ),
    GoRoute(
      path: AppRoutePaths.profileArena,
      name: AppRouteNames.sc168MyArena,
      redirect: (_, _) => AppRoutePaths.arenaMy,
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurity,
      name: AppRouteNames.sc413SettingsSecurity,
      // Same security content as /profile/security — the account menu's
      // «Bảo mật & 2FA» row routes here, so the master-detail tablet
      // renders the real pane instead of the old placeholder.
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurityBiometric,
      name: AppRouteNames.sc405SettingsSecurityBiometric,
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurityChangePassword,
      name: AppRouteNames.sc406SettingsSecurityChangePassword,
      builder: (_, _) => SecurityPage(shellRenderMode: shellRenderMode),
    ),
    ...profileOutgoingPlaceholders,
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Tài khoản',
      subtitle: 'Hồ sơ · bảo mật · cài đặt',
      description:
          'Không gian Web riêng cho hồ sơ, bảo mật, thiết bị và quyền truy cập tài khoản. Các thay đổi nhạy cảm luôn yêu cầu rà soát trước khi xác nhận.',
      backPath: AppRoutePaths.home,
      icon: Icons.manage_accounts_outlined,
    );
  }
  // Tablet master-detail (iPad-Settings style): one shell route keeps the
  // account menu framed beside whichever `/profile/...` sub-route is active.
  // Same paths/names/builders as the flat list — the GoRoute blocks stay
  // byte-compatible for the static route audits — only the tablet arm wraps
  // them; phone keeps the flat full-page navigation.
  if (surface == AppSurface.tablet) {
    return [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ProfileTabletMasterShell(
          navigationShell: navigationShell,
          currentPath: state.uri.path,
        ),
        branches: [StatefulShellBranch(routes: routes)],
      ),
    ];
  }
  return routes;
}
