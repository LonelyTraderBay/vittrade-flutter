import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_fund_lock_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpFundLockHistory(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pWalletFundLockHistory,
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

  test('SC-262 mock repository exposes fund lock history BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getFundLockHistory();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-wallet-fund-lock-history');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.records, hasLength(4));
    expect(snapshot.lockCount, 2);
    expect(snapshot.records.first.amount, 1500);
    expect(snapshot.records.first.reason, 'Order #45892 created');
    expect(snapshot.parentRoute, AppRoutePaths.p2pWallet);
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

  test('SC-263 alias repository uses wallet-history endpoint', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getFundLockHistory(walletHistoryAlias: true);

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-wallet-history');
    expect(snapshot.emptyTitle, 'Chưa có lịch sử ví P2P');
    expect(snapshot.records, hasLength(4));
  });

  testWidgets('SC-262 renders fund lock history baseline', (tester) async {
    await pumpFundLockHistory(tester);

    expect(find.byType(P2PFundLockHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Fund Lock History'), findsOneWidget);
    expect(find.text('Escrow · P2P'), findsOneWidget);
    expect(find.byKey(P2PFundLockHistoryPage.heroKey), findsOneWidget);
    expect(find.text('Lịch sử khóa tiền'), findsOneWidget);
    expect(find.text('4 giao dịch gần đây'), findsOneWidget);
    expect(find.byKey(P2PFundLockHistoryPage.listKey), findsOneWidget);
    expect(find.text('1,500.00 USDT'), findsOneWidget);
    expect(find.text('Khóa'), findsNWidgets(2));
    expect(find.text('1,000.00 USDT'), findsOneWidget);
    expect(find.text('Mở'), findsNWidgets(2));
    expect(find.text('0.01000000 BTC'), findsOneWidget);
    expect(find.text('12.000.000 VND'), findsOneWidget);
    expect(find.text('Order #45892 created'), findsOneWidget);
    expect(find.text('2026-03-05 14:20'), findsOneWidget);
  });

  testWidgets('SC-263 alias route renders the same fund lock screen', (
    tester,
  ) async {
    await pumpFundLockHistory(
      tester,
      initialLocation: AppRoutePaths.p2pWalletHistory,
    );

    expect(find.byType(P2PFundLockHistoryPage), findsOneWidget);
    expect(find.text('Fund Lock History'), findsOneWidget);
    expect(find.text('Order #45850 released'), findsOneWidget);
  });

  testWidgets('SC-262 back returns to P2P wallet route safely', (tester) async {
    await pumpFundLockHistory(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PFundLockHistoryPage), findsNothing);
    expect(find.text('P2P Wallet'), findsOneWidget);
  });
}
