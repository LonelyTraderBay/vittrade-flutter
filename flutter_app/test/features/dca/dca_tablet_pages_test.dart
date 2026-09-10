// Batch test tablet các trang DCA (coverage 2026-09-10: dca_tablet_pages
// 55 dòng chưa phủ) — pump 4 route tablet thật.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/presentation/tablet/pages/dca_tablet_pages.dart';
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

  testWidgets('trang tổng quan DCA tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.dca);

    expect(find.byType(DcaOverviewTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang cấu hình rebalance DCA tablet render thật', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.dcaRebalanceConfig);

    expect(find.byType(DcaRebalanceConfigTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang dashboard rebalance DCA tablet render thật', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.dcaRebalanceDashboard);

    expect(find.byType(DcaRebalanceDashboardTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang cấu hình lịch DCA tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.dcaScheduleConfig);

    expect(find.byType(DcaScheduleConfigTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
