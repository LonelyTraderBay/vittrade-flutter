import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/announcements_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/help_center_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/support_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> supportRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.support,
      name: AppRouteNames.sc294Support,
      builder: (context, state) => buildSurfaceAwareTabletRoute(
        context: context,
        surface: surface,
        semanticIdentifier: 'SC-294',
        title: 'Hỗ trợ VitTrade',
        subtitle: 'Hỗ trợ · yêu cầu · trạng thái',
        description:
            'Tìm đúng kênh hỗ trợ và theo dõi yêu cầu trong bố cục Tablet rõ ràng.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Mở yêu cầu hỗ trợ',
        icon: Icons.support_agent_outlined,
        fallback: SupportPage(
          shellRenderMode: shellRenderMode,
          supportContext: ProductSupportContext.fromQuery(
            state.uri.queryParameters,
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.supportHelp,
      name: AppRouteNames.sc292HelpCenter,
      builder: (context, _) => buildSurfaceAwareTabletRoute(
        context: context,
        surface: surface,
        semanticIdentifier: 'SC-292',
        title: 'Trung tâm trợ giúp',
        subtitle: 'Hướng dẫn · câu hỏi · hỗ trợ',
        description:
            'Tra cứu hướng dẫn và câu trả lời theo nhóm nội dung trong giao diện Tablet.',
        backPath: AppRoutePaths.support,
        actionLabel: 'Mở chủ đề trợ giúp',
        icon: Icons.help_center_outlined,
        fallback: HelpCenterPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.supportAnnouncements,
      name: AppRouteNames.sc293Announcements,
      builder: (context, _) => buildSurfaceAwareTabletRoute(
        context: context,
        surface: surface,
        semanticIdentifier: 'SC-293',
        title: 'Thông báo hệ thống',
        subtitle: 'Thông báo · cập nhật · chính sách',
        description:
            'Theo dõi thông báo sản phẩm, cập nhật hệ thống và chính sách mới nhất.',
        backPath: AppRoutePaths.support,
        actionLabel: 'Lọc thông báo',
        icon: Icons.campaign_outlined,
        fallback: AnnouncementsPage(shellRenderMode: shellRenderMode),
      ),
    ),
  ];
}
