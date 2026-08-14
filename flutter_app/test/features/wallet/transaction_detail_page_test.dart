import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transaction_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDetail(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
    String transactionId = 'tx001',
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletTransaction(transactionId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-141 mock repository exposes transaction detail BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getTransactionDetail('tx001');

    expect(snapshot.transaction?.id, 'tx001');
    expect(snapshot.transaction?.asset, 'USDT');
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-transaction-tx001');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
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

  testWidgets('SC-141 renders transaction detail baseline in Wallet shell', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(TransactionDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Chi tiết giao dịch'), findsOneWidget);
    expect(find.text('Lịch sử · Wallet'), findsOneWidget);
    expect(find.text('Nạp tiền'), findsOneWidget);
    expect(find.text('+5,000.00 USDT'), findsOneWidget);
    expect(find.text('Hoàn thành'), findsWidgets);
    expect(find.text('Tiến trình'), findsOneWidget);
    expect(find.text('Mã giao dịch (TxID)'), findsOneWidget);
    expect(find.text('TRC20'), findsOneWidget);
    expect(find.text('Xem trên Explorer'), findsOneWidget);
  });

  testWidgets('SC-141 first viewport reaches TxID copy action', (tester) async {
    await pumpDetail(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TransactionDetailPage',
      semanticLabel: 'Chi tiết giao dịch',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TransactionDetailPage.copyTxIdKey),
      routeName: 'TransactionDetailPage',
      actionLabel: 'the transaction copy action',
    );
  });

  testWidgets('SC-141 copy action shows inline confirmation', (tester) async {
    await pumpDetail(tester, viewport: VitFirstViewport.minimumPhone);

    await tester.ensureVisible(
      find.byKey(TransactionDetailPage.copyTxIdKey).first,
    );
    await tester.tap(find.byKey(TransactionDetailPage.copyTxIdKey).first);
    await tester.pumpAndSettle();

    expect(find.text('Đã sao chép'), findsOneWidget);
  });

  testWidgets('SC-141 missing transaction uses shared empty state', (
    tester,
  ) async {
    await pumpDetail(tester, transactionId: 'missing-tx');

    expect(find.text('Không tìm thấy giao dịch'), findsOneWidget);
    expect(
      find.text('Kiểm tra lại lịch sử ví hoặc quay lại danh sách giao dịch.'),
      findsOneWidget,
    );
    expect(find.text('Quay lại lịch sử'), findsOneWidget);
  });

  testWidgets('SC-141 support action navigates to placeholder safely', (
    tester,
  ) async {
    await pumpDetail(tester);

    await tester.ensureVisible(find.byKey(TransactionDetailPage.supportKey));
    await tester.tap(find.byKey(TransactionDetailPage.supportKey));
    await tester.pumpAndSettle();

    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);
    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Wallet transaction support'), findsOneWidget);
    expect(find.text('tx001'), findsOneWidget);
  });
}
