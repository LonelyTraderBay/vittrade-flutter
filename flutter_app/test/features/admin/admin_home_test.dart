import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/ab_test_dashboard_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/funnel_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpAdminHomePage(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.admin),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-180 mock repository exposes admin BE draft', () async {
    final snapshot = await const MockAdminRepository().getHome();

    expect(snapshot.endpoint, '/api/mobile/admin/admin');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.adminMetrics.totalEvents, 0);
    expect(snapshot.adminMetrics.totalTests, 5);
    expect(snapshot.adminMetrics.totalFunnels, 5);
    expect(snapshot.quickStats.length, 3);
    expect(snapshot.liveStats.length, 3);
    expect(snapshot.dashboards.length, 3);
    expect(snapshot.analyticsEvents, isEmpty);
    expect(snapshot.funnels, isEmpty);
    expect(snapshot.experiments, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        AdminScreenState.loading,
        AdminScreenState.empty,
        AdminScreenState.error,
        AdminScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-180 renders admin dashboard baseline', (tester) async {
    await pumpAdminHomePage(tester);

    expect(find.byType(AdminHomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Admin Dashboard'), findsOneWidget);
    expect(find.text('DCA Analytics & Monitoring'), findsOneWidget);
    expect(find.text('Real-Time Metrics'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Tạm dừng'), findsOneWidget);
    expect(find.text('Live Event Stream'), findsOneWidget);
    expect(find.text('Không có sự kiện mới'), findsOneWidget);
    await tester.ensureVisible(find.text('Dashboards'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboards'), findsOneWidget);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
    expect(find.text('A/B Test Dashboard'), findsOneWidget);
    expect(find.text('Funnel Dashboard'), findsOneWidget);
  });

  testWidgets('SC-180 supports live pause state', (tester) async {
    await pumpAdminHomePage(tester);

    await tester.tap(find.byKey(AdminHomePage.pauseKey));
    await tester.pumpAndSettle();

    expect(find.text('PAUSED'), findsOneWidget);
    expect(find.text('Tiếp tục'), findsOneWidget);
  });

  testWidgets('SC-180 navigation edges open safe placeholders', (tester) async {
    await pumpAdminHomePage(tester);

    await tester.tap(find.byKey(AdminHomePage.settingsKey));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHomePage), findsNothing);
    expect(find.text('Admin Settings'), findsOneWidget);

    await pumpAdminHomePage(tester);
    await tester.ensureVisible(
      find.byKey(AdminHomePage.dashboardKey('analytics')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdminHomePage.dashboardKey('analytics')));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHomePage), findsNothing);
    expect(find.text('Analytics Dashboard'), findsOneWidget);

    await pumpAdminHomePage(tester);
    await tester.ensureVisible(
      find.byKey(AdminHomePage.dashboardKey('abtests')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdminHomePage.dashboardKey('abtests')));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHomePage), findsNothing);
    expect(find.byType(ABTestDashboardPage), findsOneWidget);
    expect(find.text('A/B Test Dashboard'), findsOneWidget);

    await pumpAdminHomePage(tester);
    await tester.ensureVisible(
      find.byKey(AdminHomePage.dashboardKey('funnels')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdminHomePage.dashboardKey('funnels')));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHomePage), findsNothing);
    expect(find.byType(FunnelDashboardPage), findsOneWidget);
    expect(find.text('Funnel Analytics'), findsOneWidget);
  });
}
