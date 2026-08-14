import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/bootstrap/surface_router_host.dart';

void main() {
  group('AppSurfaceResolver', () {
    test('ưu tiên Web khi chạy trên Web', () {
      expect(
        AppSurfaceResolver.resolve(viewportWidth: 360, isWeb: true),
        AppSurface.web,
      );
    });

    test('chọn Phone dưới breakpoint Tablet', () {
      expect(
        AppSurfaceResolver.resolve(viewportWidth: 599, isWeb: false),
        AppSurface.phone,
      );
    });

    test('chọn Tablet tại breakpoint và trên breakpoint', () {
      expect(
        AppSurfaceResolver.resolve(viewportWidth: 600, isWeb: false),
        AppSurface.tablet,
      );
      expect(
        AppSurfaceResolver.resolve(viewportWidth: 1180, isWeb: false),
        AppSurface.tablet,
      );
    });
  });

  test('SurfaceRouterHost gọi đúng factory theo surface', () {
    var phoneCalls = 0;
    var tabletCalls = 0;
    var webCalls = 0;
    final router = GoRouter(routes: const <RouteBase>[]);
    addTearDown(router.dispose);

    final host = SurfaceRouterHost(
      phoneRouter: () {
        phoneCalls++;
        return router;
      },
      tabletRouter: () {
        tabletCalls++;
        return router;
      },
      webRouter: () {
        webCalls++;
        return router;
      },
    );

    expect(host.createRouter(AppSurface.phone), same(router));
    expect(host.createRouter(AppSurface.tablet), same(router));
    expect(host.createRouter(AppSurface.web), same(router));
    expect(phoneCalls, 1);
    expect(tabletCalls, 1);
    expect(webCalls, 1);
  });
}
