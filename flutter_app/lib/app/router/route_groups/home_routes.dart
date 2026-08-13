import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/home/presentation/pages/responsive/home_responsive_entry.dart';
import 'package:vit_trade_flutter/features/news/presentation/pages/news_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> homeRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.sc007Home,
      builder: (_, _) => HomeResponsiveEntry(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.news,
      name: AppRouteNames.sc047News,
      builder: (_, _) => NewsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
