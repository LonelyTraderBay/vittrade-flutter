import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/bootstrap/responsive_surface_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/web/pages/home_web_page.dart';
import 'package:vit_trade_flutter/features/news/presentation/phone/pages/news_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_web_utility_page.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> homeRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.sc007Home,
      builder: (_, _) => switch (surface) {
        AppSurface.phone => HomePage(shellRenderMode: shellRenderMode),
        AppSurface.tablet => const HomeTabletPage(),
        AppSurface.web => const HomeWebPage(),
        null => ResponsiveSurfacePage(
          phoneBuilder: (_) => HomePage(shellRenderMode: shellRenderMode),
          tabletBuilder: (_) => const HomeTabletPage(),
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.news,
      name: AppRouteNames.sc047News,
      builder: (context, _) => switch (surface) {
        AppSurface.web => VitWebUtilityPage(
          semanticIdentifier: 'SC-047',
          title: 'Tin tức thị trường',
          subtitle: 'Tin tức · nghiên cứu · cập nhật',
          description:
              'Không gian Web riêng để theo dõi thông tin thị trường và các cập nhật quan trọng.',
          facts: const [
            VitWebUtilityFact(label: 'Nguồn tin', value: 'Đang cập nhật'),
            VitWebUtilityFact(
              label: 'Phạm vi',
              value: 'Thị trường và sản phẩm',
            ),
            VitWebUtilityFact(label: 'Trạng thái', value: 'Sẵn sàng theo dõi'),
          ],
          onBack: () => context.go(AppRoutePaths.home),
        ),
        AppSurface.phone ||
        AppSurface.tablet ||
        null => NewsPage(shellRenderMode: shellRenderMode),
      },
    ),
  ];
}
