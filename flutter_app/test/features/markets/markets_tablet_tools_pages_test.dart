// Batch test tablet các trang công cụ Markets (coverage 2026-09-10:
// advanced_charts_pane 71 + correlations_pane 71 dòng chưa phủ — các pane
// này hiện chỉ được phủ bởi golden test vốn tự skip trên Linux CI).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('trang biểu đồ nâng cao tablet render pane thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.marketsAdvancedCharts);

    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang tương quan thị trường tablet render pane thật', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.marketsCorrelations);

    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
