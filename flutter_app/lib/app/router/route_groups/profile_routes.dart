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
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/widgets/profile_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_activity_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_api_create_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_api_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_devices_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_edit_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_security_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_settings_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_sub_accounts_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_vip_pane.dart';
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
      builder: (_, _) => switch (surface) {
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => ProfilePage(shellRenderMode: shellRenderMode),
        AppSurface.tablet => const ProfileTabletPage(),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileEdit,
      name: AppRouteNames.sc157EditProfile,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real edit pane beside the menu.
        AppSurface.tablet => const ProfileEditPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => EditProfilePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileKyc,
      name: AppRouteNames.sc159Kyc,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real KYC pane beside the menu.
        AppSurface.tablet => const ProfileKycPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => KYCPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSecurity,
      name: AppRouteNames.sc158Security,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real security pane beside the
        // menu.
        AppSurface.tablet => const ProfileSecurityPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => SecurityPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSettings,
      name: AppRouteNames.sc160Settings,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real settings pane beside the
        // menu.
        AppSurface.tablet => const ProfileSettingsPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => SettingsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileActivity,
      name: AppRouteNames.sc161ActivityLog,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real activity pane beside the
        // menu.
        AppSurface.tablet => const ProfileActivityPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => ActivityLogPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileApi,
      name: AppRouteNames.sc163ApiManagement,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real API pane beside the menu.
        AppSurface.tablet => const ProfileApiPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => ApiManagementPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileApiCreate,
      name: AppRouteNames.sc162ApiKeyCreate,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real create-key pane beside the
        // menu.
        AppSurface.tablet => const ProfileApiCreatePane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => ApiKeyCreatePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileVip,
      name: AppRouteNames.sc164Vip,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real VIP pane beside the menu.
        AppSurface.tablet => const ProfileVipPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => VIPPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileDevices,
      name: AppRouteNames.sc165DeviceManagement,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real devices pane beside the
        // menu.
        AppSurface.tablet => const ProfileDevicesPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => DeviceManagementPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSubAccounts,
      name: AppRouteNames.sc166SubAccount,
      builder: (_, _) => switch (surface) {
        // Master-detail tablet renders the real sub-accounts pane beside the
        // menu.
        AppSurface.tablet => const ProfileSubAccountsPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => SubAccountPage(shellRenderMode: shellRenderMode),
      },
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
      builder: (_, _) => switch (surface) {
        // Same security content as /profile/security — the account menu's
        // «Bảo mật & 2FA» row routes here, so the master-detail tablet
        // renders the real pane instead of the old placeholder.
        AppSurface.tablet => const ProfileSecurityPane(),
        AppSurface.phone ||
        AppSurface.web ||
        null => SecurityPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurityBiometric,
      name: AppRouteNames.sc405SettingsSecurityBiometric,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const ProfileTabletUtilityPage(
          semanticIdentifier: 'SC-405',
          title: 'Sinh trắc học',
          subtitle: 'Xác thực · thiết bị',
          description: 'Bật hoặc tắt xác thực sinh trắc học cho thiết bị này.',
          icon: Icons.fingerprint,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => SecurityPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.settingsSecurityChangePassword,
      name: AppRouteNames.sc406SettingsSecurityChangePassword,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const ProfileTabletUtilityPage(
          semanticIdentifier: 'SC-406',
          title: 'Đổi mật khẩu',
          subtitle: 'Mật khẩu · xác nhận',
          description:
              'Đặt mật khẩu mới và xác minh qua bước bảo mật tiếp theo.',
          icon: Icons.lock_outline_rounded,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => SecurityPage(shellRenderMode: shellRenderMode),
      },
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
