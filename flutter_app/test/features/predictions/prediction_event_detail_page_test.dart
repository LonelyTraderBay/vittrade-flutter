import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionEvent('pred-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-030 mock repository exposes the event detail BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getEventDetail('pred-1');

    expect(snapshot.event.id, 'pred-1');
    expect(snapshot.position?.outcome, 'Yes');
    expect(snapshot.position?.shares, 500);
    expect(snapshot.position?.pnl, 30);
    expect(snapshot.relatedEvents.map((event) => event.id), [
      'pred-2',
      'pred-9',
    ]);
    expect(snapshot.probabilityHistory, hasLength(30));
    expect(snapshot.volumeHistory, hasLength(30));
    expect(snapshot.orderBook.bids, hasLength(3));
    expect(snapshot.orderBook.asks, hasLength(3));
    expect(snapshot.rules, hasLength(5));
    expect(snapshot.topHolders, hasLength(3));
    expect(snapshot.activity, hasLength(2));
    expect(snapshot.arenaRooms, hasLength(2));
    expect(snapshot.orders, hasLength(2));
    expect(snapshot.receipts, hasLength(1));
    expect(snapshot.rewards, hasLength(2));
    expect(snapshot.lastUpdatedLabel, 'read-only');
    expect(
      snapshot.supportedStates,
      containsAll([
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-030 renders event detail inside the Markets shell', (
    tester,
  ) async {
    await pumpDetail(tester);

    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
    expect(
      find.text('Bitcoin reaches \$150K before July 2026?'),
      findsOneWidget,
    );
    expect(find.text('Live Crypto'), findsWidgets);
    expect(find.text('Yes'), findsWidgets);
    expect(find.text('No'), findsWidgets);
    expect(find.text('34%'), findsWidgets);
    expect(find.text('66%'), findsWidgets);
    expect(find.text('Volume 24h'), findsOneWidget);
    expect(find.text('Participants'), findsOneWidget);
    expect(find.text('Your Position'), findsOneWidget);
    expect(find.text('Price / Probability'), findsOneWidget);
    expect(find.text('Order Book'), findsOneWidget);
    expect(find.text('Trade'), findsOneWidget);
    expect(find.text('Order Preview'), findsOneWidget);
    expect(find.text('Rules'), findsWidgets);
    expect(find.text('Related Markets'), findsOneWidget);
    expect(find.text('Open Arena trên cùng chủ đề'), findsOneWidget);
    expect(find.text('Daily Rewards'), findsOneWidget);
    expect(find.text('Global Activity'), findsOneWidget);
  });

  testWidgets('SC-030 first viewport reaches compact market metrics', (
    tester,
  ) async {
    await pumpDetail(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-030 PredictionEventDetailPage',
      semanticLabel: 'Chi tiết sự kiện dự đoán: xác suất, vị thế và quy tắc',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Volume 24h').first,
      targetLabel: 'the first compact market metric',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-030 order book and tabs switch locally', (tester) async {
    await pumpDetail(tester);

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.orderBookToggleKey),
    );
    await tester.tap(find.byKey(PredictionEventDetailPage.orderBookToggleKey));
    await tester.pumpAndSettle();

    expect(find.text('PRICE'), findsOneWidget);
    expect(find.text('SHARES'), findsOneWidget);
    expect(find.text('TOTAL'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.commentsTabKey),
    );
    await tester.tap(find.byKey(PredictionEventDetailPage.commentsTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Add a comment...'), findsOneWidget);

    await tester.tap(find.byKey(PredictionEventDetailPage.holdersTabKey));
    await tester.pumpAndSettle();
    expect(find.text('AlphaDesk'), findsOneWidget);

    await tester.tap(find.byKey(PredictionEventDetailPage.activityTabKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Trader A'), findsOneWidget);
  });

  testWidgets('SC-030 navigation edges are wired with scoped placeholders', (
    tester,
  ) async {
    await pumpDetail(tester);

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.relatedKey('pred-2')),
    );
    await tester.tap(
      find.byKey(PredictionEventDetailPage.relatedKey('pred-2')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ethereum ETF approved in Q2 2026?'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.dailyRewardsKey),
    );
    await tester.tap(find.byKey(PredictionEventDetailPage.dailyRewardsKey));
    await tester.pumpAndSettle();
    expect(find.text('Daily Rewards'), findsWidgets);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);

    await pumpDetail(tester);
    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.globalActivityKey),
    );
    await tester.tap(find.byKey(PredictionEventDetailPage.globalActivityKey));
    await tester.pumpAndSettle();
    expect(find.text('Global Activity'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await pumpDetail(tester);
    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.arenaCreateKey),
    );
    await tester.tap(find.byKey(PredictionEventDetailPage.arenaCreateKey));
    await tester.pumpAndSettle();
    expect(find.text('Arena Studio'), findsOneWidget);
  });

  testWidgets(
    'SC-030 submit Buy chạy máy trạng thái ERR-36 và điều hướng biên lai',
    (tester) async {
      await pumpDetail(tester);

      await tester.scrollUntilVisible(
        find.text(r'$25'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(r'$25'));
      await tester.pumpAndSettle();

      final cta = find.textContaining('Buy Yes @');
      await tester.scrollUntilVisible(
        cta,
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(cta);
      // Mock loadDelay 300ms — pumpAndSettle flush timer + điều hướng.
      await tester.pumpAndSettle();

      expect(find.byType(PredictionOrderReceiptPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-030 risk link shows a coming-soon notice sheet', (
    tester,
  ) async {
    await pumpDetail(tester);

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailPage.riskLinkKey),
    );
    await tester.tap(find.byKey(PredictionEventDetailPage.riskLinkKey));
    await tester.pumpAndSettle();

    expect(find.text('Tìm hiểu rủi ro sẽ sớm ra mắt.'), findsOneWidget);
  });

  testWidgets('SC-030 back button returns to SC-027 Predictions home', (
    tester,
  ) async {
    await pumpDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
