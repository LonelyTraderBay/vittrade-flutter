// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/news/presentation/phone/pages/news_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

List<RouteBase> homeRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.home,
      name: AppRouteNames.sc007Home,
      builder: (_, _) => HomePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.news,
      name: AppRouteNames.sc047News,
      builder: (context, _) => NewsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}
