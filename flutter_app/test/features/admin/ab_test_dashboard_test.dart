import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/ab_test_dashboard_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpAbTests(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminAbtests,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-182 mock repository exposes A/B tests BE draft', () async {
    final snapshot = await const MockAdminRepository().getAbTests();

    expect(snapshot.endpoint, '/api/mobile/admin/admin-abtests');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.activeTests, 5);
    expect(snapshot.completedTests, 0);
    expect(snapshot.tests.length, 5);
    expect(snapshot.tests.first.id, 'dca_wallet_shortcut_v1');
    expect(snapshot.tests.first.variants.length, 2);
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

  testWidgets('SC-182 renders A/B test dashboard baseline', (tester) async {
    await pumpAbTests(tester);

    expect(find.byType(ABTestDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('A/B Test Dashboard'), findsOneWidget);
    expect(find.text('Test Results & Analysis'), findsOneWidget);
    expect(find.text('Tests đang chạy'), findsOneWidget);
    expect(find.text('Có kết quả'), findsOneWidget);
    expect(find.text('Tất cả A/B Tests'), findsOneWidget);
    expect(find.text('Wallet Shortcut Design'), findsOneWidget);
    expect(find.text('dca_wallet_shortcut_v1'), findsOneWidget);
    expect(find.text('Variant FULL'), findsOneWidget);
    expect(find.text('Variant COMPACT'), findsOneWidget);
  });

  testWidgets('SC-182 supports expanded state and back route', (tester) async {
    await pumpAbTests(tester);

    await tester.tap(
      find.byKey(ABTestDashboardPage.testKey('dca_wallet_shortcut_v1')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Z-Score'), findsOneWidget);
    expect(find.text('P-Value'), findsOneWidget);
    expect(find.text('Cần thêm dữ liệu'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHomePage), findsOneWidget);
  });
}
