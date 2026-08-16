import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_reviews_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PReviews(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pReviews,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-231 mock repository exposes P2P reviews BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getReviews();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-reviews');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.receivedReviews, hasLength(3));
    expect(snapshot.givenReviews, hasLength(2));
    expect(snapshot.receivedReviews.first.fromUser, 'VIPTrader_HN');
    expect(snapshot.receivedReviews.first.rating, 5);
    expect(snapshot.receivedReviews[1].reply, 'Cảm ơn bạn!');
    expect(snapshot.emptyTitle, 'Chưa có đánh giá nào');
    expect(snapshot.contractNotes, contains('escrow'));
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

  testWidgets('SC-231 renders received reviews baseline', (tester) async {
    await pumpP2PReviews(tester);

    expect(find.byType(P2PReviewsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đánh giá P2P'), findsOneWidget);
    expect(find.text('Đánh giá · P2P'), findsOneWidget);
    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('3 đánh giá'), findsOneWidget);
    expect(find.text('Nhận được'), findsOneWidget);
    expect(find.text('Đã viết'), findsOneWidget);
    expect(find.text('VIPTrader_HN'), findsOneWidget);
    expect(find.text('TradeMaster99'), findsOneWidget);
    expect(find.text('BTCWhale_VN'), findsOneWidget);
    expect(
      find.text('Người mua thanh toán rất nhanh, hợp tác vui vẻ!'),
      findsOneWidget,
    );
  });

  testWidgets('SC-231 first viewport reaches review preview', (tester) async {
    await pumpP2PReviews(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-231 P2PReviewsPage',
      semanticLabel: 'Đánh giá P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PReviewsPage.reviewKey('rv006')),
      routeName: 'SC-231 P2PReviewsPage',
      actionLabel: 'first received review preview',
      minVisibleHeight: 72,
    );
  });

  testWidgets('SC-231 switches to given reviews state', (tester) async {
    await pumpP2PReviews(tester);

    await tester.tap(find.text('Đã viết'));
    await tester.pumpAndSettle();

    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('2 đánh giá'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(
      find.text(
        'Top merchant. Xác nhận siêu nhanh ~1 phút. Highly recommended!',
      ),
      findsOneWidget,
    );
    expect(find.text('VIPTrader_HN'), findsOneWidget);
  });

  testWidgets('SC-231 header back returns to the P2P parent route', (
    tester,
  ) async {
    await pumpP2PReviews(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsOneWidget);
  });
}
