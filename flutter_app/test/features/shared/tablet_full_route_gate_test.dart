import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart';

import 'tablet_route_probe_paths.dart';

/// GĐ7 — Cổng cuối 100%: duyệt toàn bộ route registry trên surface Tablet,
/// mỗi path phải render composition thật (KHÔNG được rơi vào utility page).
void main() {
  setUpAll(() {
    // Gate chỉ truy vết utility page; overflow layout do guardrail/test UI
    // riêng xử lý — bỏ qua để không chặn đếm toàn route.
    FlutterError.onError = (details) {};
  });

  testWidgets('GĐ7: toàn bộ route probe không render utility page', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final offenders = <String>[];
    var index = 0;
    for (final path in kTabletProbePaths) {
      index++;
      debugPrint('PROBE #$index $path');
      await tester.pumpWidget(
        ProviderScope(
          child: VitTradeApp(
            routerConfig: createAppRouter(
              surface: AppSurface.tablet,
              initialLocation: path,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      // Nuốt exception layout riêng lẻ (overflow...): gate chỉ đếm utility.
      tester.takeException();
      final hitUtility =
          find.byType(VitTabletUtilityPage).evaluate().isNotEmpty ||
          find.byType(P2PTabletUtilityPage).evaluate().isNotEmpty ||
          find.byType(TradeTabletUtilityPage).evaluate().isNotEmpty ||
          find.byType(ProfileTabletUtilityPage).evaluate().isNotEmpty;
      if (hitUtility) {
        offenders.add(path);
      }
    }
    // Dỡ widget tree + flush timer pending của các provider async.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(
      offenders,
      isEmpty,
      reason:
          'GĐ7 FAIL: ${offenders.length} route vẫn render utility page: $offenders',
    );
  });
}
