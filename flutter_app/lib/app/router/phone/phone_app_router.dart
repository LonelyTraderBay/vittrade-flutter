import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_route_tree.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Router composition root của Phone.
///
/// Các route contract vẫn giữ nguyên; Phone lắp ráp route tree riêng ngay từ
/// composition root và không đi qua bộ điều phối đa surface.
GoRouter createPhoneAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
}) {
  return createPhoneRouteTree(
    initialLocation: initialLocation,
    shellRenderMode: shellRenderMode,
    appConfig: appConfig,
  );
}
