import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_proof_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2POrderProof(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pOrderProof('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-215 mock repository exposes P2P order proof BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getOrderProof('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-order-proof-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.order.id, 'p2p001');
    expect(snapshot.order.orderNumber, 'VT-P2P-20240223-001');
    expect(snapshot.order.totalVnd, 5070000);
    expect(snapshot.uploadTitle, 'Tải ảnh bằng chứng');
    expect(
      snapshot.tips,
      contains('Chụp toàn bộ màn hình giao dịch ngân hàng'),
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

  testWidgets('SC-215 renders P2P order proof baseline', (tester) async {
    await pumpP2POrderProof(tester);

    expect(find.byType(P2POrderProofPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bằng chứng thanh toán'), findsWidgets);
    expect(find.text('Đơn hàng - P2P'), findsOneWidget);
    expect(find.text('VT-P2P-20240223-001'), findsOneWidget);
    expect(find.text('5.070.000 VND'), findsOneWidget);
    expect(find.text('Tải ảnh bằng chứng'), findsOneWidget);
    expect(find.text('Chụp ảnh'), findsOneWidget);
    expect(find.text('Mở camera'), findsOneWidget);
    expect(find.text('Thư viện'), findsOneWidget);
    expect(find.text('Chọn từ ảnh'), findsOneWidget);
    expect(find.text('HƯỚNG DẪN CHỤP ẢNH'), findsOneWidget);
    expect(
      find.text(
        'Tải bằng chứng giả mạo là vi phạm nghiêm trọng và có thể dẫn đến khóa tài khoản vĩnh viễn.',
      ),
      findsOneWidget,
    );
    expect(find.text('Xác nhận (0 ảnh)'), findsOneWidget);
  });

  testWidgets('SC-215 upload proof enables CTA and remove resets state', (
    tester,
  ) async {
    await pumpP2POrderProof(tester);

    await tester.tap(find.byKey(P2POrderProofPage.cameraKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pumpAndSettle();

    expect(find.text('Đã tải (1/3)'), findsOneWidget);
    expect(find.text('Ảnh 1'), findsOneWidget);
    expect(find.text('Xác nhận (1 ảnh)'), findsOneWidget);

    await tester.tap(find.byKey(P2POrderProofPage.removeKey(0)));
    await tester.pumpAndSettle();

    expect(find.text('Đã tải (1/3)'), findsNothing);
    expect(find.text('Ảnh 1'), findsNothing);
    expect(find.text('Xác nhận (0 ảnh)'), findsOneWidget);
  });

  testWidgets('SC-215 confirm after upload returns to P2P order route', (
    tester,
  ) async {
    await pumpP2POrderProof(tester);

    await tester.tap(find.byKey(P2POrderProofPage.galleryKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(P2POrderProofPage.confirmKey));
    await tester.tap(find.byKey(P2POrderProofPage.confirmKey));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 340));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
  });
}
