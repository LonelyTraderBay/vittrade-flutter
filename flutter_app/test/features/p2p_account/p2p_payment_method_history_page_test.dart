import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PPaymentMethodHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pPaymentMethodHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-236 mock repository exposes payment history BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getPaymentMethodHistory();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-payment-method-history');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
    );
    expect(snapshot.totalTransactions, 45);
    expect(snapshot.totalVolume, 1250000000);
    expect(snapshot.successRate, 96.5);
    expect(snapshot.transactions, hasLength(4));
    expect(snapshot.transactions.first.orderId, '#45892');
    expect(snapshot.transactions.last.status, 'cancelled');
    expect(snapshot.contractNotes, contains('High-risk action'));
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

  testWidgets('SC-236 renders payment history baseline', (tester) async {
    await pumpP2PPaymentMethodHistory(tester);

    expect(find.byType(P2PPaymentMethodHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử thanh toán'), findsOneWidget);
    expect(find.text('Thanh toán · P2P'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('Giao dịch'), findsWidgets);
    expect(find.text('1.250M'), findsOneWidget);
    expect(find.text('Tổng khối lượng'), findsOneWidget);
    expect(find.text('96.5%'), findsOneWidget);
    expect(find.text('Thành công'), findsOneWidget);
    expect(find.text('#45892'), findsOneWidget);
    expect(find.text('#45880'), findsOneWidget);
    expect(find.text('#45870'), findsOneWidget);
    expect(find.text('#45860'), findsOneWidget);
    expect(find.text('36.000.000'), findsOneWidget);
    expect(find.text('24.000.000'), findsOneWidget);
    expect(find.text('16.800.000'), findsOneWidget);
    expect(find.text('25.000.000'), findsOneWidget);
    expect(find.text('Đã hủy'), findsOneWidget);
  });

  testWidgets('SC-236 first viewport reaches stats and first transaction', (
    tester,
  ) async {
    await pumpP2PPaymentMethodHistory(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-236 P2PPaymentMethodHistoryPage',
      semanticLabel: 'Lịch sử thanh toán P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.text('45'),
      routeName: 'SC-236 P2PPaymentMethodHistoryPage',
      actionLabel: 'the payment history totals',
      minVisibleHeight: 18,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PPaymentMethodHistoryPage.txKey('1')),
      routeName: 'SC-236 P2PPaymentMethodHistoryPage',
      actionLabel: 'the first payment history transaction',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-236 header back returns to payment methods list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodHistory(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });
}
