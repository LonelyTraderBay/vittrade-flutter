import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_security_pane.dart';
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
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-157',
          title: 'Chỉnh sửa hồ sơ',
          subtitle: 'Thông tin cá nhân · liên hệ',
          description:
              'Cập nhật thông tin hồ sơ trong bố cục Tablet rõ ràng, dễ rà soát trước khi lưu.',
          facts: const [
            ProfileTabletFact(
              label: 'Tên hiển thị',
              value: 'Người dùng VitTrade',
            ),
            ProfileTabletFact(label: 'Email', value: 'n•••@vittrade.vn'),
            ProfileTabletFact(
              label: 'Trạng thái',
              value: 'Đã xác minh',
              valueColor: AppColors.buy,
            ),
          ],
          actionLabel: 'Lưu hồ sơ',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận cập nhật hồ sơ',
        ),
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
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-160',
          title: 'Cài đặt tài khoản',
          subtitle: 'Thông báo · riêng tư · hiển thị',
          description:
              'Điều chỉnh các tùy chọn tài khoản với vùng nội dung rộng và các nhóm cài đặt rõ ràng.',
          facts: const [
            ProfileTabletFact(label: 'Thông báo giao dịch', value: 'Đang bật'),
            ProfileTabletFact(label: 'Ngôn ngữ', value: 'Tiếng Việt'),
            ProfileTabletFact(label: 'Thiết bị', value: 'Tablet'),
          ],
          actionLabel: 'Lưu cài đặt',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => SettingsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileActivity,
      name: AppRouteNames.sc161ActivityLog,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-161',
          title: 'Nhật ký hoạt động',
          subtitle: 'Đăng nhập · thay đổi · xác nhận',
          description:
              'Đối chiếu các hoạt động tài khoản gần đây và trạng thái xác nhận trên Tablet.',
          facts: const [
            ProfileTabletFact(label: 'Hoạt động hôm nay', value: '6'),
            ProfileTabletFact(
              label: 'Đăng nhập gần nhất',
              value: 'Hôm nay, 09:42',
            ),
            ProfileTabletFact(
              label: 'Cảnh báo',
              value: 'Không có',
              valueColor: AppColors.buy,
            ),
          ],
          actionLabel: 'Lọc nhật ký',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => ActivityLogPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileApi,
      name: AppRouteNames.sc163ApiManagement,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-163',
          title: 'Quản lý API',
          subtitle: 'Khóa API · quyền · hoạt động',
          description:
              'Rà soát các khóa API, phạm vi quyền và trạng thái truy cập trước khi quản lý.',
          facts: const [
            ProfileTabletFact(label: 'Khóa đang hoạt động', value: '2'),
            ProfileTabletFact(
              label: 'Quyền rút tiền',
              value: 'Đã khóa',
              valueColor: AppColors.buy,
            ),
            ProfileTabletFact(label: 'Lần sử dụng gần nhất', value: 'Hôm qua'),
          ],
          actionLabel: 'Mở quản lý API',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận quản lý API',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => ApiManagementPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileApiCreate,
      name: AppRouteNames.sc162ApiKeyCreate,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-162',
          title: 'Tạo khóa API',
          subtitle: 'Tên khóa · quyền truy cập · an toàn',
          description:
              'Chọn đúng phạm vi quyền và kiểm tra lại trước khi tạo khóa API mới.',
          facts: const [
            ProfileTabletFact(label: 'Tên khóa', value: 'Khóa mới'),
            ProfileTabletFact(label: 'Quyền mặc định', value: 'Đọc dữ liệu'),
            ProfileTabletFact(
              label: 'Quyền rút tiền',
              value: 'Tắt',
              valueColor: AppColors.buy,
            ),
          ],
          actionLabel: 'Xem trước khóa API',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận tạo khóa API',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => ApiKeyCreatePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileVip,
      name: AppRouteNames.sc164Vip,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-164',
          title: 'Thành viên VIP',
          subtitle: 'Cấp độ · đặc quyền · tiến độ',
          description:
              'Theo dõi cấp VIP, tiến độ và các đặc quyền dành riêng cho tài khoản.',
          facts: const [
            ProfileTabletFact(label: 'Cấp hiện tại', value: 'VIP 2'),
            ProfileTabletFact(label: 'Tiến độ', value: '68%'),
            ProfileTabletFact(
              label: 'Đặc quyền tiếp theo',
              value: 'Phí giao dịch ưu đãi',
              valueColor: AppColors.primary,
            ),
          ],
          actionLabel: 'Xem đặc quyền',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => VIPPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileDevices,
      name: AppRouteNames.sc165DeviceManagement,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-165',
          title: 'Quản lý thiết bị',
          subtitle: 'Thiết bị tin cậy · phiên đăng nhập',
          description:
              'Xem thiết bị đang truy cập và thu hồi phiên lạ sau khi kiểm tra thông tin.',
          facts: const [
            ProfileTabletFact(label: 'Thiết bị tin cậy', value: '3'),
            ProfileTabletFact(label: 'Phiên đang hoạt động', value: '2'),
            ProfileTabletFact(
              label: 'Cảnh báo mới',
              value: 'Không có',
              valueColor: AppColors.buy,
            ),
          ],
          actionLabel: 'Rà soát thiết bị',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận rà soát thiết bị',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => DeviceManagementPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSubAccounts,
      name: AppRouteNames.sc166SubAccount,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _profileTabletUtility(
          semanticIdentifier: 'SC-166',
          title: 'Tài khoản phụ',
          subtitle: 'Quyền truy cập · hạn mức · hoạt động',
          description:
              'Quản lý tài khoản phụ và phạm vi quyền trong một bảng điều khiển Tablet.',
          facts: const [
            ProfileTabletFact(label: 'Tài khoản phụ', value: '1'),
            ProfileTabletFact(
              label: 'Trạng thái',
              value: 'Đang hoạt động',
              valueColor: AppColors.buy,
            ),
            ProfileTabletFact(label: 'Quyền rút tiền', value: 'Đã khóa'),
          ],
          actionLabel: 'Mở tài khoản phụ',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận mở tài khoản phụ',
        ),
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
          description:
              'Kiểm tra lại phương thức xác thực và thông tin bảo vệ trước khi thay đổi cài đặt.',
          facts: [
            ProfileTabletFact(label: 'Phương thức hiện tại', value: 'Đang bật'),
            ProfileTabletFact(label: 'Thiết bị tin cậy', value: '3'),
            ProfileTabletFact(
              label: 'Bước tiếp theo',
              value: 'Xác nhận thay đổi',
              valueColor: AppColors.caution,
            ),
          ],
          actionLabel: 'Xem trước thay đổi',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi bảo mật',
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
              'Kiểm tra lại phương thức xác thực và thông tin bảo vệ trước khi thay đổi cài đặt.',
          facts: [
            ProfileTabletFact(label: 'Phương thức hiện tại', value: 'Đang bật'),
            ProfileTabletFact(label: 'Thiết bị tin cậy', value: '3'),
            ProfileTabletFact(
              label: 'Bước tiếp theo',
              value: 'Xác nhận thay đổi',
              valueColor: AppColors.caution,
            ),
          ],
          actionLabel: 'Xem trước thay đổi',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi bảo mật',
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

ProfileTabletUtilityPage _profileTabletUtility({
  required String semanticIdentifier,
  required String title,
  required String subtitle,
  required String description,
  required List<ProfileTabletFact> facts,
  String? actionLabel,
  bool requiresConfirmation = false,
  String? confirmationTitle,
}) {
  return ProfileTabletUtilityPage(
    semanticIdentifier: semanticIdentifier,
    title: title,
    subtitle: subtitle,
    description: description,
    facts: facts,
    actionLabel: actionLabel,
    requiresConfirmation: requiresConfirmation,
    confirmationTitle: confirmationTitle,
  );
}
