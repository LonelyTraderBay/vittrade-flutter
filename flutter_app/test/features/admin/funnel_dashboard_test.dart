import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/data/admin_repository.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/funnel_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpFunnels(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminFunnels,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-183 mock repository exposes funnel BE draft', () async {
    final snapshot = await const MockAdminRepository().getFunnels();

    expect(snapshot.endpoint, '/api/mobile/admin/admin-funnels');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.totalSessions, 0);
    expect(snapshot.completedSessions, 0);
    expect(snapshot.funnels.length, 5);
    expect(snapshot.funnels.first.id, 'wallet_to_creation');
    expect(snapshot.funnels.first.steps.length, 6);
    expect(snapshot.analyticsEvents, isEmpty);
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

  testWidgets('SC-183 renders funnel dashboard baseline', (tester) async {
    await pumpFunnels(tester);

    expect(find.byType(FunnelDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Funnel Analytics'), findsOneWidget);
    expect(find.text('Conversion Funnel Tracking'), findsOneWidget);
    expect(find.text('Chọn funnel'), findsOneWidget);
    expect(find.text('Wallet Discovery → Plan Creation'), findsOneWidget);
    expect(find.text('Asset Detail → Plan Creation'), findsOneWidget);
    expect(find.text('Phiên'), findsOneWidget);
    expect(find.text('Tỷ lệ hoàn thành'), findsOneWidget);
    expect(find.text('Funnel Waterfall'), findsOneWidget);
    expect(find.text('Wallet Page View'), findsWidgets);
  });

  testWidgets('SC-183 first viewport reaches funnel selector', (tester) async {
    await pumpFunnels(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-183 FunnelDashboardPage',
      semanticLabel: 'Bảng phân tích phễu chuyển đổi',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(FunnelDashboardPage.selectorKey('wallet_to_creation')),
      routeName: 'SC-183 FunnelDashboardPage',
      actionLabel: 'the primary funnel selector',
    );
  });

  testWidgets('SC-183 supports selector state and back route', (tester) async {
    await pumpFunnels(tester);

    await tester.tap(
      find.byKey(FunnelDashboardPage.selectorKey('plan_activation')),
    );
    await tester.pumpAndSettle();

    expect(find.text('First Execution'), findsWidgets);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(AdminHomePage), findsOneWidget);
  });
}
