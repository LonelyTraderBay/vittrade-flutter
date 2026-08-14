import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/orders_history_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpOrderReceipt(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeOrderReceipt,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-051 mock repository exposes order receipt BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getOrderReceipt();
    final receipt = snapshot.receipt;

    expect(snapshot.trade.pair.symbol, 'BTC/USDT');
    expect(receipt.orderId, 'ORD-98EH1ZT2');
    expect(receipt.symbol, 'BTC/USDT');
    expect(receipt.side, TradeOrderSide.buy);
    expect(receipt.orderType, 'Giới hạn');
    expect(receipt.price, 67543.21);
    expect(receipt.amount, .015);
    expect(receipt.total, 1013.15);
    expect(receipt.fee, .96);
    expect(receipt.status, TradeReceiptStatus.submitted);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=order'));
    expect(snapshot.supportRoute, contains('ORD-98EH1ZT2'));
    expect(receipt.tpPrice, 72000);
    expect(receipt.slPrice, 65000);
    expect(receipt.estimatedFill, '< 2 phút');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-051 renders receipt inside the Trade shell', (tester) async {
    await pumpOrderReceipt(tester);

    expect(find.byType(OrderReceiptPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết lệnh'), findsOneWidget);
    expect(find.text('Đặt lệnh thành công!'), findsOneWidget);
    expect(find.text('Lệnh Mua BTC/USDT đang được xử lý'), findsOneWidget);
    expect(find.text('Tóm tắt khớp lệnh'), findsOneWidget);
    expect(find.text('Kiểm soát rủi ro'), findsOneWidget);
    expect(find.text('ORD-98EH1ZT2'), findsOneWidget);
    expect(find.text('Giới hạn'), findsOneWidget);
    expect(find.text('\$67,543.21'), findsOneWidget);
    expect(find.text('0.015000 BTC'), findsOneWidget);
    expect(find.text('\$1,013.15'), findsOneWidget);
    expect(find.text('Take Profit'), findsOneWidget);
    expect(find.text('Stop Loss'), findsOneWidget);
    expect(find.byKey(OrderReceiptPage.copyOrderIdKey), findsOneWidget);
    expect(find.byKey(OrderReceiptPage.openActionsKey), findsOneWidget);
    expect(find.byKey(OrderReceiptPage.supportKey), findsOneWidget);
  });

  testWidgets('SC-051 first viewport reaches receipt id', (tester) async {
    await pumpOrderReceipt(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'OrderReceiptPage',
      semanticLabel: 'Chi tiết lệnh giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.text('ORD-98EH1ZT2'),
      minVisibleHeight: 12,
      targetLabel: 'trade receipt order id',
      reason:
          'Order receipt should expose the actual order id above the bottom '
          'navigation on the QA phone viewport.',
    );
  });

  testWidgets('SC-051 status badge opens orders history', (tester) async {
    await pumpOrderReceipt(tester);

    await tester.tap(find.byKey(OrderReceiptPage.openOrdersKey));
    await tester.pumpAndSettle();

    expect(find.byType(OrdersHistoryPage), findsOneWidget);
  });

  testWidgets('SC-051 continue trading navigates to BTC pair trade', (
    tester,
  ) async {
    await pumpOrderReceipt(tester);

    await tester.ensureVisible(find.byKey(OrderReceiptPage.openActionsKey));
    await tester.tap(find.byKey(OrderReceiptPage.openActionsKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OrderReceiptPage.continueTradingKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.text('BTC/USDT'), findsWidgets);

    // Drop the tree then flush mock network timers before binding teardown.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('SC-051 share button keeps the receipt in place', (tester) async {
    await pumpOrderReceipt(tester);

    await tester.ensureVisible(find.byKey(OrderReceiptPage.openActionsKey));
    await tester.tap(find.byKey(OrderReceiptPage.openActionsKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OrderReceiptPage.shareKey));
    await tester.pumpAndSettle();

    expect(find.byType(OrderReceiptPage), findsOneWidget);
    expect(find.text('Đã chia sẻ'), findsOneWidget);
  });

  testWidgets('SC-051 support opens contextual order support', (tester) async {
    await pumpOrderReceipt(tester);

    await tester.ensureVisible(find.byKey(OrderReceiptPage.supportKey));
    await tester.tap(find.byKey(OrderReceiptPage.supportKey));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Trading order receipt support'), findsOneWidget);
    expect(find.text('ORD-98EH1ZT2'), findsOneWidget);
  });
}
