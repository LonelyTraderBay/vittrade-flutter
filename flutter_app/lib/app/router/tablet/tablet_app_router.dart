import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Router composition root của Tablet.
///
/// Root builders dùng page Tablet trực tiếp; các bounded context chưa migrate
/// vẫn được giữ compatibility để route parity không bị đứt trong P3–P6.
GoRouter createTabletAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  return createAppRouter(
    initialLocation: initialLocation,
    shellRenderMode: shellRenderMode,
    appConfig: appConfig,
    surface: AppSurface.tablet,
  );
}
