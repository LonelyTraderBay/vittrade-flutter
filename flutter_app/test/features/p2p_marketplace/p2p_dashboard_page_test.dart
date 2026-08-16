import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_dashboard_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-274 mock repository exposes dashboard BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDashboard();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-dashboard');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'P2P Dashboard');
    expect(snapshot.subtitle, 'Tổng quan · P2P');
    expect(snapshot.selectedFilter.id, '30d');
    expect(snapshot.selectedVolume, 385000000);
    expect(snapshot.filters, hasLength(3));
    expect(snapshot.weeklyVolume, hasLength(8));
    expect(snapshot.monthlyOrders, hasLength(6));
    expect(snapshot.assetDistribution, hasLength(5));
    expect(snapshot.topMerchants, hasLength(5));
    expect(snapshot.recentActivity, hasLength(5));
    expect(snapshot.quickActions, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.myOrdersRoute, AppRoutePaths.p2pMyOrders);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-274 renders dashboard baseline', (tester) async {
    await pumpDashboard(tester);

    expect(find.byType(P2PDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('P2P Dashboard'), findsOneWidget);
    expect(find.text('Tổng quan · P2P'), findsOneWidget);
    expect(find.byKey(P2PDashboardPage.filterKey), findsOneWidget);
    expect(find.text('7 ngày'), findsOneWidget);
    expect(find.text('30 ngày'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.byKey(P2PDashboardPage.volumeHeroKey), findsOneWidget);
    expect(find.text('Tổng Volume (30 ngày)'), findsOneWidget);
    expect(find.text('₫385M'), findsOneWidget);
    expect(find.byKey(P2PDashboardPage.metricsKey), findsOneWidget);
    expect(find.text('Đơn hoàn thành'), findsOneWidget);
    expect(find.text('64'), findsOneWidget);
    expect(find.text('Tỷ lệ hoàn thành'), findsAtLeastNWidgets(1));
    expect(find.text('82.1%'), findsAtLeastNWidgets(1));
    expect(find.text('Lợi nhuận Spread'), findsOneWidget);
    expect(find.text('₫1.85M'), findsOneWidget);
    expect(find.byKey(P2PDashboardPage.weeklyChartKey), findsOneWidget);
    expect(find.text('Volume theo tuần'), findsOneWidget);
  });

  testWidgets('SC-274 supports time filter state', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(P2PDashboardPage.filterChipKey('7d').finder);
    await tester.pumpAndSettle();

    expect(find.text('Tổng Volume (7 ngày)'), findsOneWidget);
  });

  testWidgets('SC-274 first viewport reaches weekly volume chart', (
    tester,
  ) async {
    await pumpDashboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-274 P2PDashboardPage',
      semanticLabel: 'Tổng quan P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PDashboardPage.weeklyChartKey),
      targetLabel: 'the weekly volume chart preview',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-274 navigation edges use safe P2P routes', (tester) async {
    await pumpDashboard(tester);

    await tester.ensureVisible(find.byKey(P2PDashboardPage.myOrdersKey));
    await tester.tap(find.byKey(P2PDashboardPage.myOrdersKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PDashboardPage), findsNothing);
    expect(find.byType(P2PMyOrdersPage), findsOneWidget);
  });

  testWidgets('SC-274 header back returns to P2P parent', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PDashboardPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
