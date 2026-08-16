import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_balance_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PEscrowBalance(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pEscrowBalance,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-245 mock repository exposes escrow balance BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getEscrowBalance();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-escrow-balance');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.selectedAsset, 'USDT');
    expect(snapshot.assets, hasLength(3));
    expect(snapshot.assetBalance('USDT').totalAmount, 3200);
    expect(snapshot.ordersFor('USDT'), hasLength(3));
    expect(
      snapshot.ordersFor('USDT').last.status,
      P2PEscrowOrderStatus.dispute,
    );
    expect(snapshot.helpBullets, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.contractNotes, contains('High-risk action'));
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-245 renders USDT escrow balance in P2P shell', (
    tester,
  ) async {
    await pumpP2PEscrowBalance(tester);

    expect(find.byType(P2PEscrowBalancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Escrow Balance'), findsOneWidget);
    expect(find.text('Escrow · P2P'), findsOneWidget);
    expect(find.byKey(P2PEscrowBalancePage.heroKey), findsOneWidget);
    expect(find.text('3 đơn hàng đang giữ tiền'), findsOneWidget);
    expect(find.byKey(P2PEscrowBalancePage.infoKey), findsOneWidget);
    expect(find.text('Escrow là gì?'), findsOneWidget);
    expect(find.byKey(P2PEscrowBalancePage.tabsKey), findsOneWidget);
    expect(find.text('USDT 3'), findsOneWidget);
    expect(find.byKey(P2PEscrowBalancePage.ordersKey), findsOneWidget);
    expect(find.text('#P2P-45892'), findsOneWidget);
    expect(find.text('#P2P-45870'), findsOneWidget);
    expect(find.text('Tranh chấp'), findsOneWidget);
    expect(find.textContaining('Đơn hàng đang tranh chấp'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PEscrowBalancePage.helpKey));
    expect(find.text('Khi nào tiền được giải phóng?'), findsOneWidget);
    expect(find.textContaining('Bán crypto'), findsOneWidget);
  });

  testWidgets('SC-245 supports query asset and tab state changes', (
    tester,
  ) async {
    await pumpP2PEscrowBalance(
      tester,
      initialLocation: '${AppRoutePaths.p2pEscrowBalance}?asset=BTC',
    );

    expect(find.text('BTC 1'), findsOneWidget);
    expect(find.text('#P2P-45860'), findsOneWidget);
    expect(find.text('0.01000000 BTC'), findsWidgets);

    await tester.tap(find.text('VND 1'));
    await tester.pumpAndSettle();

    expect(find.text('#P2P-45850'), findsOneWidget);
    expect(find.text('MUA'), findsOneWidget);
    expect(find.text('Chờ release'), findsOneWidget);
  });

  testWidgets('SC-245 invalid query asset falls back to default escrow asset', (
    tester,
  ) async {
    await pumpP2PEscrowBalance(
      tester,
      initialLocation: '${AppRoutePaths.p2pEscrowBalance}?asset=DOGE',
    );

    expect(find.byType(P2PEscrowBalancePage), findsOneWidget);
    expect(find.text('USDT 3'), findsOneWidget);
    expect(find.text('#P2P-45892'), findsOneWidget);
  });

  testWidgets('SC-245 order tap uses canonical P2P order route', (
    tester,
  ) async {
    await pumpP2PEscrowBalance(tester);

    await tester.tap(find.text('#P2P-45892'));
    await tester.pumpAndSettle();

    expect(find.byType(P2POrderPage), findsOneWidget);
  });

  testWidgets('SC-245 back returns to P2P home route', (tester) async {
    await pumpP2PEscrowBalance(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsAtLeastNWidgets(1));
  });
}
