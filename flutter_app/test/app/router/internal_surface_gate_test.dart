import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/internal_surface_gate.dart';

void main() {
  group('InternalSurfaceAccessPolicy', () {
    test('keeps customer release builds closed unless explicitly enabled', () {
      expect(
        InternalSurfaceAccessPolicy.allows(
          releaseMode: true,
          explicitEnable: false,
        ),
        isFalse,
      );
      expect(
        InternalSurfaceAccessPolicy.allows(
          releaseMode: true,
          explicitEnable: true,
        ),
        isTrue,
      );
      expect(
        InternalSurfaceAccessPolicy.allows(
          releaseMode: false,
          explicitEnable: false,
        ),
        isTrue,
      );
    });

    test('classifies admin developer and QA demo route surfaces', () {
      expect(
        InternalSurfaceAccessPolicy.kindForPath('/admin/analytics?range=7d'),
        InternalSurfaceKind.admin,
      );
      expect(
        InternalSurfaceAccessPolicy.kindForPath(AppRoutePaths.routeChecker),
        InternalSurfaceKind.developer,
      );
      expect(
        InternalSurfaceAccessPolicy.kindForPath(
          AppRoutePaths.performanceMonitor,
        ),
        InternalSurfaceKind.developer,
      );
      expect(
        InternalSurfaceAccessPolicy.kindForPath(AppRoutePaths.demoCopyCard),
        InternalSurfaceKind.qaDemo,
      );
      expect(
        InternalSurfaceAccessPolicy.isInternalPath(
          AppRoutePaths.tradePair('btcusdt'),
        ),
        isFalse,
      );
    });
  });
}
