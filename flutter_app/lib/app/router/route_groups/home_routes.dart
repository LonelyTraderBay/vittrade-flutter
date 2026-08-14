import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/responsive/home_responsive_entry.dart';
import 'package:vit_trade_flutter/features/news/presentation/pages/news_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

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
        // Web has its own router boundary now; its dedicated page composition
        // is delivered in P7. Keep this compatibility page explicit until
        // that surface is complete.
        AppSurface.web => HomePage(shellRenderMode: shellRenderMode),
        null => HomeResponsiveEntry(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.news,
      name: AppRouteNames.sc047News,
      builder: (_, _) => NewsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
