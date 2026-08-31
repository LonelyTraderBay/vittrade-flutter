import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

typedef SurfaceRouterFactory = GoRouter Function();

/// Composition-root host cho ba router độc lập.
///
/// Host chỉ chọn factory theo surface và tạo router một lần ở bootstrap. Nó
/// không tự theo dõi kích thước cửa sổ và không được gọi lại trong `build()`;
/// việc đó giúp giữ nguyên location/stack khi layout thay đổi.
final class SurfaceRouterHost {
  const SurfaceRouterHost({
    required this.phoneRouter,
    required this.tabletRouter,
    required this.webRouter,
  });

  final SurfaceRouterFactory phoneRouter;
  final SurfaceRouterFactory tabletRouter;
  final SurfaceRouterFactory webRouter;

  GoRouter createRouter(AppSurface surface) {
    // 2026-09-01 tách token phone/tablet: chốt cờ surface cho spacing
    // token (VitDensity card padding) đúng lúc bootstrap chọn router.
    TabletSpacingTokens.tabletSurfaceActive = surface == AppSurface.tablet;
    return switch (surface) {
      AppSurface.phone => phoneRouter(),
      AppSurface.tablet => tabletRouter(),
      AppSurface.web => webRouter(),
    };
  }
}
