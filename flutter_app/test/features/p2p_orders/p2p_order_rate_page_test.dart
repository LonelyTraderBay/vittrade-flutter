import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_rate_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2POrderRate(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pOrderRate('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-213 mock repository exposes P2P order rate BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getOrderRate('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-order-rate-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.order.id, 'p2p001');
    expect(snapshot.order.merchant, 'CryptoKing_VN');
    expect(snapshot.quickTags.length, 6);
    expect(snapshot.quickTags.first.iconKey, 'speed');
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

  testWidgets('SC-213 renders P2P order rating initial baseline', (
    tester,
  ) async {
    await pumpP2POrderRate(tester);

    expect(find.byType(P2POrderRatePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đánh giá giao dịch'), findsOneWidget);
    expect(find.text('Đánh giá · P2P'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('Mua 200.0000 USDT - 5.070.000'), findsOneWidget);
    expect(find.text('Bạn đánh giá merchant này thế nào?'), findsOneWidget);
    expect(find.byKey(P2POrderRatePage.starKey(5)), findsOneWidget);
    expect(find.text('Bỏ qua'), findsOneWidget);
    expect(find.text('Gửi đánh giá'), findsOneWidget);
    expect(find.text('Nhận xét nhanh'), findsNothing);
  });

  testWidgets('SC-213 first viewport reaches rating actions', (tester) async {
    await pumpP2POrderRate(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-213 P2POrderRatePage',
      semanticLabel: 'Đánh giá giao dịch P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderRatePage.starKey(5)),
      routeName: 'SC-213 P2POrderRatePage',
      actionLabel: 'the 5-star rating control',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderRatePage.submitKey),
      routeName: 'SC-213 P2POrderRatePage',
      actionLabel: 'the submit rating action',
      minVisibleHeight: 40,
    );

    await tester.tap(find.byKey(P2POrderRatePage.starKey(5)));
    await tester.pumpAndSettle();

    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderRatePage.tagKey('Giao dịch nhanh')),
      routeName: 'SC-213 P2POrderRatePage',
      actionLabel: 'the first quick feedback tag',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-213 rating unlocks tags, review, and submit success', (
    tester,
  ) async {
    await pumpP2POrderRate(tester);

    await tester.tap(find.byKey(P2POrderRatePage.starKey(5)));
    await tester.pumpAndSettle();

    expect(find.text('Xuất sắc!'), findsOneWidget);
    expect(find.text('Nhận xét nhanh'), findsOneWidget);
    expect(find.text('Giao dịch nhanh'), findsOneWidget);
    expect(find.byKey(P2POrderRatePage.reviewKey), findsOneWidget);

    await tester.tap(find.byKey(P2POrderRatePage.tagKey('Giao dịch nhanh')));
    await tester.enterText(
      find.byKey(P2POrderRatePage.reviewKey),
      'Fast and clear escrow flow.',
    );
    await tester.ensureVisible(find.byKey(P2POrderRatePage.submitKey));
    await tester.tap(find.byKey(P2POrderRatePage.submitKey));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Cảm ơn bạn!'), findsOneWidget);
    expect(
      find.text('Đánh giá của bạn giúp cộng đồng giao dịch an toàn hơn.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-213 skip returns to P2P order route', (tester) async {
    await pumpP2POrderRate(tester);

    await tester.tap(find.byKey(P2POrderRatePage.skipKey));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết đơn hàng'), findsOneWidget);
  });
}
