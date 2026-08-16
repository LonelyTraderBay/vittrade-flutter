import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_dashboard_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpMyOrders(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pMyOrders,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-281 mock repository exposes my orders BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getMyOrders();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-my-orders');
    expect(snapshot.actionDraft, contains('POST /orders/:id/action'));
    expect(snapshot.title, 'Đơn P2P của tôi');
    expect(snapshot.subtitle, 'Đơn hàng · P2P');
    expect(snapshot.defaultTab, 'processing');
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Đang xử lý',
      'Hoàn tất',
      'Tranh chấp',
    ]);
    expect(snapshot.orders, hasLength(7));
    expect(snapshot.completedCount, 3);
    expect(snapshot.disputedCount, 1);
    expect(snapshot.completedVolume, 114860000);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.dashboardRoute, AppRoutePaths.p2pDashboard);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-281 renders processing orders baseline', (tester) async {
    await pumpMyOrders(tester);

    expect(find.byType(P2PMyOrdersPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đơn P2P của tôi'), findsOneWidget);
    expect(find.text('Đơn hàng · P2P'), findsOneWidget);
    expect(find.byKey(P2PMyOrdersPage.dashboardKey), findsOneWidget);
    expect(find.byKey(P2PMyOrdersPage.statsKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(P2PMyOrdersPage.statsKey),
        matching: find.text('7'),
      ),
      findsOneWidget,
    );
    expect(find.text('3'), findsOneWidget);
    expect(find.text('114.86M'), findsOneWidget);
    expect(find.text('Đang xử lý'), findsOneWidget);
    expect(find.text('Hoàn tất'), findsOneWidget);
    expect(find.text('Tranh chấp'), findsOneWidget);
    expect(find.byKey(P2PMyOrdersPage.searchKey), findsOneWidget);
    expect(find.byKey(P2PMyOrdersPage.sortKey), findsOneWidget);
    expect(find.byKey(P2PMyOrdersPage.orderKey('p2p001')), findsOneWidget);
    expect(find.byKey(P2PMyOrdersPage.orderKey('p2p002')), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('VIPTrader_HN'), findsOneWidget);
    expect(find.text('Chờ thanh toán'), findsOneWidget);
    expect(find.text('Đã thanh toán'), findsOneWidget);
  });

  testWidgets('SC-281 search, tab, and sort states update locally', (
    tester,
  ) async {
    await pumpMyOrders(tester);

    await tester.enterText(find.byType(TextField).first, 'VIP');
    await tester.pumpAndSettle();
    expect(find.text('VIPTrader_HN'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hoàn tất'));
    await tester.pumpAndSettle();
    expect(find.text('TradeMaster99'), findsOneWidget);
    expect(find.text('CoinHunter_HCM'), findsOneWidget);
    expect(find.text('FastTrade_SG'), findsOneWidget);

    await tester.tap(find.byKey(P2PMyOrdersPage.sortKey));
    await tester.pumpAndSettle();
    expect(find.text('BTCWhale_VN'), findsOneWidget);
    expect(find.text('Số tiền'), findsOneWidget);
  });

  testWidgets('SC-281 dashboard, order, and dispute navigation are wired', (
    tester,
  ) async {
    await pumpMyOrders(tester);

    await tester.tap(find.byKey(P2PMyOrdersPage.dashboardKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PDashboardPage), findsOneWidget);

    await pumpMyOrders(tester);
    await tester.tap(find.byKey(P2PMyOrdersPage.orderKey('p2p001')));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderPage), findsOneWidget);

    await pumpMyOrders(tester);
    await tester.tap(find.text('Tranh chấp'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PMyOrdersPage.orderKey('p2p006')));
    await tester.pumpAndSettle();
    expect(find.byType(P2PDisputeDetailPage), findsOneWidget);
  });

  testWidgets('SC-281 header back returns to P2P parent', (tester) async {
    await pumpMyOrders(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PMyOrdersPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}
