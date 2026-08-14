import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Router composition root của Web.
///
/// Web có route tree riêng ngay từ bootstrap. Page composition Web sẽ được
/// hoàn thiện theo bounded context ở P7; compatibility builders hiện tại chỉ
/// là trạng thái chuyển tiếp có kiểm soát.
GoRouter createWebAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  return createAppRouter(
    initialLocation: initialLocation,
    shellRenderMode: shellRenderMode,
    appConfig: appConfig,
    surface: AppSurface.web,
  );
}
