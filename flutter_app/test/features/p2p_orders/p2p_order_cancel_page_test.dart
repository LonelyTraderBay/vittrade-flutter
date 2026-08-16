import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_cancel_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2POrderCancel(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pOrderCancel('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-214 mock repository exposes P2P order cancel BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getOrderCancel('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-order-cancel-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.order.id, 'p2p001');
    expect(snapshot.order.orderNumber, 'VT-P2P-20240223-001');
    expect(snapshot.reasons, contains('Không muốn giao dịch nữa'));
    expect(snapshot.warningTitle, 'Lưu ý quan trọng');
    expect(snapshot.contractNotes, contains('escrow'));
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

  testWidgets('SC-214 renders P2P order cancel baseline', (tester) async {
    await pumpP2POrderCancel(tester);

    expect(find.byType(P2POrderCancelPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hủy đơn hàng'), findsWidgets);
    expect(find.text('Đơn hàng - P2P'), findsOneWidget);
    expect(find.text('THÔNG TIN ĐƠN HÀNG'), findsOneWidget);
    expect(find.text('VT-P2P-20240223-001'), findsOneWidget);
    expect(find.text('Mua 200.0000 USDT'), findsOneWidget);
    expect(find.text('5.070.000 VND'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('Lý do hủy'), findsOneWidget);
    expect(find.text('Không muốn giao dịch nữa'), findsOneWidget);
    expect(find.text('Lưu ý quan trọng'), findsOneWidget);
    expect(find.text('Quay lại'), findsOneWidget);
    expect(find.text('Xác nhận hủy'), findsOneWidget);
  });

  testWidgets('SC-214 first viewport reaches reason and actions', (
    tester,
  ) async {
    await pumpP2POrderCancel(tester);
    final firstReason = (await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getOrderCancel('p2p001')).reasons.first;

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-214 P2POrderCancelPage',
      semanticLabel: 'Hủy đơn hàng P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.text('VT-P2P-20240223-001'),
      routeName: 'SC-214 P2POrderCancelPage',
      actionLabel: 'the order summary',
      minVisibleHeight: 18,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderCancelPage.reasonKey(firstReason)),
      routeName: 'SC-214 P2POrderCancelPage',
      actionLabel: 'the first cancel reason',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderCancelPage.backKey),
      routeName: 'SC-214 P2POrderCancelPage',
      actionLabel: 'the safe return action',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-214 requires reason before cancel action submits', (
    tester,
  ) async {
    await pumpP2POrderCancel(tester);

    await tester.ensureVisible(find.byKey(P2POrderCancelPage.confirmKey));
    await tester.tap(find.byKey(P2POrderCancelPage.confirmKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderCancelPage), findsOneWidget);

    await tester.tap(
      find.byKey(P2POrderCancelPage.reasonKey('Không muốn giao dịch nữa')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(P2POrderCancelPage.confirmKey));
    await tester.tap(find.byKey(P2POrderCancelPage.confirmKey));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 380));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
  });

  testWidgets('SC-214 back action returns to P2P order route', (tester) async {
    await pumpP2POrderCancel(tester);

    await tester.ensureVisible(find.byKey(P2POrderCancelPage.backKey));
    await tester.tap(find.byKey(P2POrderCancelPage.backKey));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
  });
}
