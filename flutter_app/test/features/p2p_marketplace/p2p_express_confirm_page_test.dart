import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_express_confirm_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PExpressConfirm(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pExpressConfirm,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-210 mock repository exposes P2P Express Confirm BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getExpressConfirm();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-express-confirm');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.ad.id, 'ad001');
    expect(snapshot.order.id, 'p2p001');
    expect(snapshot.paymentMethod, 'Vietcombank');
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

  testWidgets('SC-210 renders P2P Express confirm baseline', (tester) async {
    await pumpP2PExpressConfirm(tester);

    expect(find.byType(P2PExpressConfirmPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác nhận mua nhanh'), findsOneWidget);
    expect(find.text('Express - P2P'), findsOneWidget);
    expect(find.text('Express Mua'), findsOneWidget);
    expect(find.text('Loại giao dịch'), findsOneWidget);
    expect(find.text('Số lượng'), findsOneWidget);
    expect(find.text('0.00 USDT'), findsWidgets);
    expect(find.text('25.350 VND/USDT'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsWidgets);
    expect(find.text('Escrow'), findsOneWidget);
    expect(find.text('Hủy bỏ'), findsOneWidget);
    expect(find.text('Xác nhận'), findsOneWidget);
  });

  testWidgets('SC-210 first viewport reaches escrow and confirm actions', (
    tester,
  ) async {
    await pumpP2PExpressConfirm(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-210 P2PExpressConfirmPage',
      semanticLabel: 'Xác nhận giao dịch nhanh P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.text('CryptoKing_VN').first,
      routeName: 'SC-210 P2PExpressConfirmPage',
      actionLabel: 'the selected merchant summary',
      minVisibleHeight: 16,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PExpressConfirmPage.cancelKey),
      routeName: 'SC-210 P2PExpressConfirmPage',
      actionLabel: 'the cancel confirmation action',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PExpressConfirmPage.confirmKey),
      routeName: 'SC-210 P2PExpressConfirmPage',
      actionLabel: 'the final confirm action after trade details',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-210 query params drive sell state and payment method', (
    tester,
  ) async {
    await pumpP2PExpressConfirm(
      tester,
      initialLocation:
          '${AppRoutePaths.p2pExpressConfirm}?type=sell&asset=USDT&fiat=5070000&crypto=200&adId=ad004&payment=BIDV',
    );

    expect(find.text('Xác nhận bán nhanh'), findsOneWidget);
    expect(find.text('Express Bán'), findsOneWidget);
    expect(find.text('Bán'), findsOneWidget);
    expect(find.text('200.00 USDT'), findsWidgets);
    expect(find.text('5.070.000 VND'), findsOneWidget);
    expect(find.text('VIPTrader_HN'), findsWidgets);
    expect(find.text('BIDV'), findsOneWidget);
  });

  testWidgets('SC-210 confirm CTA opens the canonical P2P order route', (
    tester,
  ) async {
    await pumpP2PExpressConfirm(tester);

    await tester.tap(find.byKey(P2PExpressConfirmPage.confirmKey));
    await tester.pump();
    expect(find.text('Đang tạo đơn...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
  });

  testWidgets('SC-210 cancel CTA returns to the P2P parent route', (
    tester,
  ) async {
    await pumpP2PExpressConfirm(tester);

    await tester.tap(find.byKey(P2PExpressConfirmPage.cancelKey));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsOneWidget);
  });
}
