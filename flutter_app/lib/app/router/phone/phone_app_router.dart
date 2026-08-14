import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Router composition root của Phone.
///
/// Các route contract vẫn giữ nguyên; builder đã chọn trực tiếp Phone và
/// không chạy qua ResponsiveEntry.
GoRouter createPhoneAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  return createAppRouter(
    initialLocation: initialLocation,
    shellRenderMode: shellRenderMode,
    appConfig: appConfig,
    surface: AppSurface.phone,
  );
}
