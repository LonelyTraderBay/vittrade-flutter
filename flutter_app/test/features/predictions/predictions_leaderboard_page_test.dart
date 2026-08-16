import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/predictions_leaderboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLeaderboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsLeaderboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-033 mock repository exposes the leaderboard BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getLeaderboard();

    expect(snapshot.timeFilter, PredictionLeaderboardTimeFilter.weekly);
    expect(snapshot.metric, PredictionLeaderboardMetric.pnl);
    expect(snapshot.traders, hasLength(10));
    expect(snapshot.traders.first.user, 'WhaleAlpha');
    expect(snapshot.traders.first.pnl, 18200);
    expect(snapshot.biggestWins, hasLength(4));
    expect(snapshot.eventForWin(snapshot.biggestWins.first)?.id, 'pred-1');
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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

    final volume = await repo.getLeaderboard(
      metric: PredictionLeaderboardMetric.volume,
    );
    expect(volume.traders.first.user, 'AlgoTrader');
    expect(volume.traders.first.rank, 1);
  });

  testWidgets('SC-033 renders leaderboard inside the Markets shell', (
    tester,
  ) async {
    await pumpLeaderboard(tester);

    expect(find.byType(PredictionsLeaderboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Bảng xếp hạng · Prediction'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Profit/Loss'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('Rankings'), findsOneWidget);
    expect(find.text('WhaleAlpha'), findsWidgets);
    expect(find.text('+\$18.2K'), findsWidgets);
    expect(find.text('74%'), findsOneWidget);
    expect(
      find.byKey(PredictionsLeaderboardPage.traderKey('WhaleAlpha')),
      findsOneWidget,
    );
  });

  testWidgets('SC-033 first viewport reaches the top ranking row', (
    tester,
  ) async {
    await pumpLeaderboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-033 PredictionsLeaderboardPage',
      semanticLabel: 'Bảng xếp hạng nhà giao dịch dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionsLeaderboardPage.traderKey('WhaleAlpha')),
      targetLabel: 'the top prediction leaderboard row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-033 time and metric tabs update locally', (tester) async {
    await pumpLeaderboard(tester);

    await tester.tap(find.byKey(PredictionsLeaderboardPage.todayFilterKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsLeaderboardPage.traderKey('CryptoKing')),
      findsOneWidget,
    );
    expect(find.text('+\$4.5K'), findsWidgets);

    await tester.tap(find.byKey(PredictionsLeaderboardPage.volumeMetricKey));
    await tester.pumpAndSettle();
    expect(find.text('VOLUME'), findsOneWidget);
    expect(
      find.byKey(PredictionsLeaderboardPage.traderKey('WhaleAlpha')),
      findsOneWidget,
    );
    expect(find.text('\$45.0K'), findsOneWidget);
  });

  testWidgets('SC-033 P/L info opens the explanatory sheet', (tester) async {
    await pumpLeaderboard(tester);

    await tester.tap(find.byKey(PredictionsLeaderboardPage.infoKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('P/L (Profit/Loss)'), findsOneWidget);
  });

  testWidgets('SC-033 biggest win navigates to event detail', (tester) async {
    await pumpLeaderboard(tester);

    await tester.ensureVisible(
      find.byKey(PredictionsLeaderboardPage.biggestWinKey('WhaleAlpha')),
    );
    await tester.tap(
      find.byKey(PredictionsLeaderboardPage.biggestWinKey('WhaleAlpha')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
  });
}
