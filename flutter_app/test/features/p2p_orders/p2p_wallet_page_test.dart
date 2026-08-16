import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_balance_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_fund_lock_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_transfer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PWallet(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pWallet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-264 mock repository exposes P2P wallet BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getWallet();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-wallet');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.totalUsdValue, 22793.70);
    expect(snapshot.balances.map((item) => item.asset), ['USDT', 'BTC', 'VND']);
    expect(snapshot.balanceFor('USDT').inEscrow, 3200);
    expect(snapshot.transactions, hasLength(4));
    expect(snapshot.historyRoute, AppRoutePaths.p2pWalletHistory);
    expect(snapshot.transferRoute, AppRoutePaths.p2pWalletTransfer);
    expect(snapshot.escrowBalanceRoute, AppRoutePaths.p2pEscrowBalance);
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

  testWidgets('SC-264 renders P2P wallet baseline', (tester) async {
    await pumpP2PWallet(tester);

    expect(find.byType(P2PWalletPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('P2P Wallet'), findsWidgets);
    expect(find.text('Ví · P2P'), findsOneWidget);
    expect(find.byKey(P2PWalletPage.heroKey), findsOneWidget);
    expect(find.text('\$22,793.70'), findsOneWidget);
    expect(find.byKey(P2PWalletPage.infoKey), findsOneWidget);
    expect(find.text('Tài sản'), findsOneWidget);
    expect(find.byKey(P2PWalletPage.balanceKey('USDT')), findsOneWidget);
    expect(find.text('16,150.50'), findsOneWidget);
    expect(find.text('0.06240000'), findsOneWidget);
    expect(find.text('57.600.000'), findsOneWidget);
    expect(find.byKey(P2PWalletPage.transactionsKey), findsOneWidget);
    expect(find.text('Giải phóng Escrow'), findsOneWidget);
    expect(find.text('+1,500.00 USDT'), findsOneWidget);
  });

  testWidgets('SC-264 first viewport reaches balances section', (tester) async {
    await pumpP2PWallet(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-264 P2PWalletPage',
      semanticLabel: 'Ví P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PWalletPage.balanceKey('USDT')),
      routeName: 'SC-264 P2PWalletPage',
      actionLabel: 'the first P2P wallet balance card',
    );
  });

  testWidgets('SC-264 toggles privacy and expands an asset breakdown', (
    tester,
  ) async {
    await pumpP2PWallet(tester);

    await tester.tap(find.byKey(P2PWalletPage.privacyKey));
    await tester.pumpAndSettle();

    expect(find.text('••••••'), findsOneWidget);

    await tester.tap(find.byKey(P2PWalletPage.balanceKey('USDT')));
    await tester.pumpAndSettle();

    expect(find.text('Khả dụng'), findsOneWidget);
    expect(find.text('12,450.50'), findsOneWidget);
    expect(find.text('Escrow'), findsOneWidget);
    expect(find.text('3,200.00'), findsOneWidget);
    expect(find.text('Locked'), findsOneWidget);
    expect(find.text('500.00'), findsOneWidget);
    expect(find.byKey(P2PWalletPage.depositKey('USDT')), findsOneWidget);
    expect(find.byKey(P2PWalletPage.withdrawKey('USDT')), findsOneWidget);
    expect(find.byKey(P2PWalletPage.escrowKey('USDT')), findsOneWidget);
  });

  testWidgets('SC-264 history action opens wallet history route', (
    tester,
  ) async {
    await pumpP2PWallet(tester);

    await tester.tap(find.byKey(P2PWalletPage.historyActionKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PFundLockHistoryPage), findsOneWidget);
    expect(find.text('Fund Lock History'), findsOneWidget);
  });

  testWidgets('SC-264 quick transfer opens transfer route with direction', (
    tester,
  ) async {
    await pumpP2PWallet(tester);

    await tester.tap(find.byKey(P2PWalletPage.transferFromMainKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PWalletTransferPage), findsOneWidget);
    expect(find.text('Từ'), findsOneWidget);
    expect(find.text('Main Wallet'), findsOneWidget);
    expect(find.text('P2P Wallet'), findsOneWidget);
  });

  testWidgets('SC-264 expanded actions open transfer and escrow details', (
    tester,
  ) async {
    await pumpP2PWallet(tester);

    await tester.tap(find.byKey(P2PWalletPage.balanceKey('BTC')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PWalletPage.withdrawKey('BTC')));
    await tester.pumpAndSettle();

    expect(find.byType(P2PWalletTransferPage), findsOneWidget);
    expect(find.text('Số dư: 0.05240000 BTC'), findsOneWidget);

    await pumpP2PWallet(tester);
    await tester.tap(find.byKey(P2PWalletPage.balanceKey('BTC')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PWalletPage.escrowKey('BTC')));
    await tester.pumpAndSettle();

    expect(find.byType(P2PEscrowBalancePage), findsOneWidget);
    expect(find.text('BTC 1'), findsOneWidget);
  });
}
