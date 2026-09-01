import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/ab_test_dashboard_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/analytics_dashboard_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/funnel_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/internal_surface_gate.dart';

List<RouteBase> adminRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.admin,
      name: AppRouteNames.sc180AdminHome,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.admin,
        child: buildSurfaceAwareTabletRoute(
          context: context,
          surface: surface,
          semanticIdentifier: 'SC-180',
          title: 'Quản trị hệ thống',
          subtitle: 'Quản trị · KPI · vận hành',
          description:
              'Theo dõi vận hành và chỉ số quản trị trong giao diện Tablet.',
          backPath: AppRoutePaths.home,
          actionLabel: 'Mở báo cáo quản trị',
          icon: Icons.admin_panel_settings_outlined,
          fallback: AdminHomePage(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminAnalytics,
      name: AppRouteNames.sc181AnalyticsDashboard,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminAnalytics,
        child: buildSurfaceAwareTabletRoute(
          context: context,
          surface: surface,
          semanticIdentifier: 'SC-181',
          title: 'Phân tích quản trị',
          subtitle: 'Quản trị · phân tích · dữ liệu',
          description: 'Đối chiếu chỉ số và xu hướng vận hành trên Tablet.',
          backPath: AppRoutePaths.admin,
          actionLabel: 'Lọc dữ liệu',
          icon: Icons.analytics_outlined,
          fallback: AnalyticsDashboardPage(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminAbtests,
      name: AppRouteNames.sc182AbTestDashboard,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminAbtests,
        child: buildSurfaceAwareTabletRoute(
          context: context,
          surface: surface,
          semanticIdentifier: 'SC-182',
          title: 'Bảng điều khiển A/B test',
          subtitle: 'Quản trị · thử nghiệm · kết quả',
          description: 'Theo dõi thử nghiệm và kết quả phân tích trên Tablet.',
          backPath: AppRoutePaths.admin,
          actionLabel: 'Xem kết quả thử nghiệm',
          icon: Icons.science_outlined,
          fallback: ABTestDashboardPage(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminFunnels,
      name: AppRouteNames.sc183FunnelDashboard,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminFunnels,
        child: buildSurfaceAwareTabletRoute(
          context: context,
          surface: surface,
          semanticIdentifier: 'SC-183',
          title: 'Phân tích phễu',
          subtitle: 'Quản trị · phễu · chuyển đổi',
          description: 'Phân tích các bước chuyển đổi và điểm rơi trong phễu.',
          backPath: AppRoutePaths.admin,
          actionLabel: 'Lọc phễu',
          icon: Icons.filter_alt_outlined,
          fallback: FunnelDashboardPage(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.adminSettings,
      name: AppRouteNames.sc410AdminSettings,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.admin,
        routePath: AppRoutePaths.adminSettings,
        child: buildSurfaceAwareTabletRoute(
          context: context,
          surface: surface,
          semanticIdentifier: 'SC-410',
          title: 'Cài đặt quản trị',
          subtitle: 'Quản trị · quyền · cấu hình',
          description: 'Rà soát quyền và cấu hình quản trị trước khi lưu.',
          backPath: AppRoutePaths.admin,
          actionLabel: 'Xem trước cài đặt',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi cài đặt quản trị',
          icon: Icons.settings_outlined,
          fallback: AdminSettingsPage(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
  ];
}
