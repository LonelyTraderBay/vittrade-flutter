import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/orders_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpOrdersHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeOrdersHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-050 mock repository exposes orders history BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getOrdersHistory();

    expect(snapshot.trade.pairs, hasLength(3));
    expect(snapshot.openOrders, hasLength(4));
    expect(snapshot.historyOrders, hasLength(5));
    expect(snapshot.openOrders.first.symbol, 'BTC/USDT');
    expect(snapshot.openOrders[1].status, TradeOrderStatus.partial);
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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

    final result = await repo.submitOrderAction(
      orderId: 'ord-open-001',
      action: 'cancel',
    );
    expect(result.status, 'success');
    expect(result.action, 'cancel');
  });

  testWidgets('SC-050 renders open orders inside the Trade shell', (
    tester,
  ) async {
    await pumpOrdersHistory(tester);

    expect(find.byType(OrdersHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử lệnh'), findsOneWidget);
    expect(find.text('Lịch sử lệnh · Spot'), findsOneWidget);
    expect(find.textContaining('Lệnh mở'), findsOneWidget);
    expect(find.textContaining('(4)'), findsWidgets);
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('MUA'), findsWidgets);
    expect(find.text('Đang mở'), findsWidgets);
    expect(find.text('\$65,000.00'), findsOneWidget);
    expect(find.text('Hủy lệnh'), findsWidgets);
  });

  testWidgets('SC-050 switches history tab and filters locally', (
    tester,
  ) async {
    await pumpOrdersHistory(tester);

    await tester.tap(find.byKey(OrdersHistoryPage.historyTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã khớp'), findsWidgets);
    expect(find.text('Đã hủy'), findsWidgets);

    await tester.tap(find.byKey(OrdersHistoryPage.filterKey('sell')));
    await tester.pumpAndSettle();

    expect(find.text('BÁN'), findsWidgets);
    expect(
      find.byKey(OrdersHistoryPage.orderKey('ord-history-002')),
      findsOneWidget,
    );
    expect(
      find.byKey(OrdersHistoryPage.orderKey('ord-history-001')),
      findsNothing,
    );
  });

  testWidgets('SC-050 first viewport reaches first open order', (tester) async {
    await pumpOrdersHistory(tester);

    expectFirstViewportVisible(
      tester,
      find.byKey(OrdersHistoryPage.orderKey('ord-open-001')),
      targetLabel: 'the first open order row',
      minVisibleHeight: 48,
    );
  });

  testWidgets('SC-050 cancel action uses the order action draft', (
    tester,
  ) async {
    await pumpOrdersHistory(tester);

    await tester.tap(find.byKey(OrdersHistoryPage.cancelFirstOrderKey));
    // GD4 Cụm F3: cancelOrder giờ Future<T> (submitOrderAction) — chờ hết
    // đường ghi thay vì chỉ 1 frame.
    await tester.pumpAndSettle();

    expect(find.byType(OrdersHistoryPage), findsOneWidget);
    expect(find.text('Hủy lệnh'), findsWidgets);
  });
}
