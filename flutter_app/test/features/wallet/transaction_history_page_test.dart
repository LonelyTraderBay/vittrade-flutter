import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transaction_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpHistory(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-136 mock repository exposes wallet history BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getTransactionHistory();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-history');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.transactions, hasLength(6));
    expect(snapshot.transactions.first.id, 'tx001');
    expect(snapshot.transactions.first.asset, 'USDT');
    expect(snapshot.filters.map((item) => item.id), [
      'all',
      'deposit',
      'withdraw',
      'trade',
      'p2p',
    ]);
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-136 renders transaction history baseline in Wallet shell', (
    tester,
  ) async {
    await pumpHistory(tester);

    expect(find.byType(TransactionHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
    expect(
      find.text('Theo dõi nạp, rút và giao dịch · an toàn'),
      findsOneWidget,
    );
    expect(find.text('6 giao dịch'), findsOneWidget);
    expect(find.text('21/02/2024'), findsOneWidget);
    expect(find.text('Nạp USDT'), findsOneWidget);
    expect(find.text('+5,000.00 USDT'), findsOneWidget);
    expect(find.text('Hoàn thành'), findsWidgets);
  });

  testWidgets('SC-136 first viewport reaches first transaction row', (
    tester,
  ) async {
    await pumpHistory(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TransactionHistoryPage',
      semanticLabel: 'Lịch sử giao dịch - theo dõi nạp, rút an toàn',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TransactionHistoryPage.transactionKey('tx001')),
      routeName: 'TransactionHistoryPage',
      actionLabel: 'the first transaction row',
    );
  });

  testWidgets('SC-136 export action reads as a CSV request notice', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(TransactionHistoryPage.exportKey));
    await tester.pump();

    expect(
      find.text('Yêu cầu xuất CSV cho 6 giao dịch đã được ghi nhận'),
      findsOneWidget,
    );
  });

  testWidgets('SC-136 filter chips narrow the transaction list', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(TransactionHistoryPage.filterKey('withdraw').finder);
    await tester.pumpAndSettle();
    expect(find.text('1 giao dịch'), findsOneWidget);
    expect(find.text('Rút USDT'), findsOneWidget);
    expect(find.text('Nạp USDT'), findsNothing);

    await tester.tap(TransactionHistoryPage.filterKey('trade').finder);
    await tester.pumpAndSettle();
    expect(find.text('2 giao dịch'), findsOneWidget);
    expect(find.text('Mua BTC'), findsOneWidget);
    expect(find.text('Bán ETH'), findsOneWidget);
  });

  testWidgets('SC-136 rows navigate to SC-141 transaction detail', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(TransactionHistoryPage.transactionKey('tx001').finder);
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết giao dịch'), findsOneWidget);
    expect(find.text('+5,000.00 USDT'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
