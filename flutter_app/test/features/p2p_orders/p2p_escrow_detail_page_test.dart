import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PEscrowDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pEscrow('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-246 mock repository exposes escrow detail BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getEscrowDetail('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-escrow-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.orderId, 'p2p001');
    expect(snapshot.order.orderNumber, 'VT-P2P-20240223-001');
    expect(snapshot.escrowAddress, startsWith('0x579bdf'));
    expect(snapshot.maskedAddress, '0x579bdf...9bdf13');
    expect(snapshot.signers, hasLength(3));
    expect(snapshot.signedCount, 1);
    expect(snapshot.timeline, hasLength(5));
    expect(snapshot.parentRoute, AppRoutePaths.p2pOrder('p2p001'));
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

  testWidgets('SC-246 renders escrow detail baseline in P2P shell', (
    tester,
  ) async {
    await pumpP2PEscrowDetail(tester);

    expect(find.byType(P2PEscrowDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết Escrow'), findsOneWidget);
    expect(find.text('Escrow · P2P'), findsOneWidget);
    expect(find.byKey(P2PEscrowDetailPage.heroKey), findsOneWidget);
    expect(find.text('Đang khóa — Bảo vệ giao dịch'), findsOneWidget);
    expect(find.text('200.0000 USDT (5.070.000 VND)'), findsOneWidget);
    expect(find.byKey(P2PEscrowDetailPage.addressKey), findsOneWidget);
    expect(find.text('0x579bdf...9bdf13'), findsOneWidget);
    expect(find.byKey(P2PEscrowDetailPage.multisigKey), findsOneWidget);
    expect(find.text('Multi-Signature (1/3)'), findsOneWidget);
    expect(find.text('VitTrade Platform'), findsOneWidget);
    expect(find.text('Đã ký'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PEscrowDetailPage.orderInfoKey));
    expect(find.text('Thông tin đơn hàng'), findsOneWidget);
    expect(find.text('VT-P2P-20240223-001'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PEscrowDetailPage.securityKey));
    expect(find.text('Tiến trình Escrow'), findsOneWidget);
    expect(find.text('Escrow được tạo'), findsOneWidget);
    expect(find.text('Chờ thanh toán fiat'), findsOneWidget);
    expect(find.text('Bảo vệ bởi VitTrade Escrow'), findsOneWidget);
  });

  testWidgets('SC-246 supports address reveal, copy, explorer and order link', (
    tester,
  ) async {
    await pumpP2PEscrowDetail(tester);

    await tester.tap(find.byKey(P2PEscrowDetailPage.revealKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('0x579bdf13579'), findsOneWidget);

    await tester.tap(find.byKey(P2PEscrowDetailPage.copyKey));
    await tester.pumpAndSettle();
    expect(find.byKey(P2PEscrowDetailPage.feedbackKey), findsOneWidget);
    expect(find.text('Đã copy địa chỉ escrow'), findsOneWidget);

    await tester.tap(find.byKey(P2PEscrowDetailPage.explorerKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã mở Blockchain Explorer'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PEscrowDetailPage.orderLinkKey));
    await tester.tap(find.byKey(P2PEscrowDetailPage.orderLinkKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderPage), findsOneWidget);
  });

  testWidgets('SC-246 back returns to source order', (tester) async {
    await pumpP2PEscrowDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2POrderPage), findsOneWidget);
  });
}
