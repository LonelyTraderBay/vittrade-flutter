import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_cancel_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_proof_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2POrder(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pOrder('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-216 mock repository exposes P2P order BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getOrder('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-order-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.order.id, 'p2p001');
    expect(snapshot.order.orderNumber, 'VT-P2P-20240223-001');
    expect(snapshot.order.escrowAmount, 200);
    expect(
      snapshot.paymentFields.map((field) => field.id),
      contains('content'),
    );
    expect(snapshot.timeline.length, 4);
    expect(
      snapshot.quickActions.map((action) => action.route),
      contains('/p2p/merchant/mc001'),
    );
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

  testWidgets('SC-216 renders P2P order payment baseline', (tester) async {
    await pumpP2POrder(tester);

    expect(find.byType(P2POrderPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
    expect(find.text('Đơn hàng - P2P'), findsOneWidget);
    expect(find.text('Chờ thanh toán'), findsWidgets);
    expect(find.text('14:59'), findsOneWidget);
    expect(find.text('Lưu ý an toàn giao dịch P2P'), findsOneWidget);
    expect(find.text('Escrow: 200.0000 USDT đã khóa'), findsOneWidget);
    expect(find.text('VT-P2P-20240223-001'), findsOneWidget);
    expect(find.text('5.070.000 VND'), findsWidgets);
    expect(find.text('Thông tin chuyển khoản'), findsOneWidget);
    expect(find.text('Mã QR chuyển khoản'), findsOneWidget);
    expect(find.text('Quét mã bằng app ngân hàng'), findsOneWidget);
    expect(find.text('VITTA P2P001'), findsWidgets);
    expect(find.text('Bằng chứng thanh toán'), findsOneWidget);
    expect(find.text('Tiến trình giao dịch'), findsOneWidget);
    expect(find.text('Nhắn tin'), findsOneWidget);
    expect(find.text('Đã thanh toán'), findsOneWidget);
    expect(find.text('Hủy đơn hàng'), findsOneWidget);
    expect(find.text('Mở khiếu nại'), findsOneWidget);
    expect(find.text('HÀNH ĐỘNG NHANH'), findsOneWidget);
  });

  testWidgets('SC-216 first viewport reaches escrow and payment controls', (
    tester,
  ) async {
    await pumpP2POrder(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-216 P2POrderPage',
      semanticLabel: 'Chi tiết đơn hàng P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderPage.escrowKey),
      routeName: 'SC-216 P2POrderPage',
      actionLabel: 'the escrow protection link',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.text('VT-P2P-20240223-001'),
      routeName: 'SC-216 P2POrderPage',
      actionLabel: 'the order summary',
      minVisibleHeight: 12,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderPage.copyAllKey),
      routeName: 'SC-216 P2POrderPage',
      actionLabel: 'the copy payment details action',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-216 copy, QR, and mark-paid state interactions work', (
    tester,
  ) async {
    await pumpP2POrder(tester);

    await tester.tap(find.byKey(P2POrderPage.copyAllKey));
    await tester.pump();
    expect(find.text('Đã copy!'), findsOneWidget);

    await tester.drag(
      find.byKey(P2POrderPage.contentKey),
      const Offset(0, -220),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2POrderPage.qrToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('Quét mã bằng app ngân hàng'), findsNothing);

    await tester.ensureVisible(find.byKey(P2POrderPage.markPaidKey));
    await tester.tap(find.byKey(P2POrderPage.markPaidKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã thanh toán - Chờ xác nhận'), findsOneWidget);
    expect(find.text('29:59'), findsOneWidget);
    expect(find.text('Đang chờ merchant xác nhận'), findsOneWidget);
    expect(find.text('Hủy đơn hàng'), findsNothing);
    expect(find.text('Chờ xác nhận'), findsOneWidget);
  });

  testWidgets('SC-216 wires proof, cancel, chat, and escrow routes', (
    tester,
  ) async {
    await pumpP2POrder(tester);

    await tester.ensureVisible(find.byKey(P2POrderPage.proofKey));
    await tester.tap(find.byKey(P2POrderPage.proofKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderProofPage), findsOneWidget);

    await pumpP2POrder(tester);
    await tester.ensureVisible(find.byKey(P2POrderPage.cancelKey));
    await tester.tap(find.byKey(P2POrderPage.cancelKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderCancelPage), findsOneWidget);

    await pumpP2POrder(tester);
    await tester.ensureVisible(find.byKey(P2POrderPage.chatKey));
    await tester.tap(find.byKey(P2POrderPage.chatKey));
    await tester.pumpAndSettle();
    expect(find.text('CryptoKing_VN'), findsOneWidget);

    await pumpP2POrder(tester);
    await tester.ensureVisible(find.byKey(P2POrderPage.escrowKey));
    await tester.tap(find.byKey(P2POrderPage.escrowKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PEscrowDetailPage), findsOneWidget);
  });
}
