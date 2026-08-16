import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_rewards_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRewards(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsRewards,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-032 mock repository exposes the rewards BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getRewards();

    expect(snapshot.rewards, hasLength(10));
    expect(snapshot.totalDailyPool, 373);
    expect(snapshot.categories, containsAll(['Live Crypto', 'Politics', 'AI']));
    expect(snapshot.arenaRooms.single.title, 'BTC \$70K? — Tuần 9');
    expect(snapshot.arenaRooms.single.points, 100);
    expect(snapshot.eventFor('pred-1').title, contains('Bitcoin'));
    expect(snapshot.rewards.first.id, 'rw-1');
    expect(snapshot.rewards.first.maxSpread, .03);
    expect(snapshot.rewards.first.minShares, 100);
    expect(snapshot.rewards.first.dailyReward, 45);
    expect(snapshot.rewards.first.isFavorite, isTrue);
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
  });

  testWidgets('SC-032 renders rewards inside the Markets shell', (
    tester,
  ) async {
    await pumpRewards(tester);

    expect(find.byType(PredictionsRewardsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Daily Rewards'), findsWidgets);
    expect(find.text('Phần thưởng · Prediction'), findsOneWidget);
    expect(find.text('\$373'), findsOneWidget);
    expect(find.text('Total daily pool:'), findsOneWidget);
    expect(find.text('MARKET'), findsOneWidget);
    expect(find.text('SPREAD'), findsOneWidget);
    expect(find.text('MIN'), findsOneWidget);
    expect(find.text('REWARD'), findsOneWidget);
    expect(
      find.byKey(PredictionsRewardsPage.rewardKey('rw-1')),
      findsOneWidget,
    );
    expect(
      find.text('Bitcoin reaches \$150K before July 2026?'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(PredictionsRewardsPage.arenaBridgeKey),
    );
    expect(find.text('Room Arena cùng chủ đề'), findsOneWidget);
    expect(find.text('ARENA POINTS ONLY'), findsOneWidget);
    expect(find.text('BTC \$70K? — Tuần 9'), findsOneWidget);
  });

  testWidgets('SC-032 first viewport reaches reward table row', (tester) async {
    await pumpRewards(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-032 PredictionsRewardsPage',
      semanticLabel: 'Phần thưởng hằng ngày của thị trường dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionsRewardsPage.rewardKey('rw-1')),
      targetLabel: 'the first daily reward row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-032 filters by category and favorites locally', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.tap(find.byKey(PredictionsRewardsPage.liveCryptoFilterKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsRewardsPage.rewardKey('rw-1')),
      findsOneWidget,
    );
    expect(find.byKey(PredictionsRewardsPage.rewardKey('rw-6')), findsNothing);

    await tester.tap(find.byKey(PredictionsRewardsPage.allFilterKey));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(PredictionsRewardsPage.favoritesFilterKey),
      180,
      scrollable: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.right,
      ),
    );
    await tester.tap(find.byKey(PredictionsRewardsPage.favoritesFilterKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsRewardsPage.rewardKey('rw-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionsRewardsPage.rewardKey('rw-4')),
      findsOneWidget,
    );
    expect(find.byKey(PredictionsRewardsPage.rewardKey('rw-2')), findsNothing);
  });

  testWidgets('SC-032 risk explainer opens the disclosure sheet', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.ensureVisible(
      find.byKey(PredictionsRewardsPage.riskExplainerKey),
    );
    await tester.tap(find.byKey(PredictionsRewardsPage.riskExplainerKey));
    await tester.pumpAndSettle();

    expect(find.text('Reward không phải lợi nhuận đảm bảo'), findsOneWidget);
    expect(find.textContaining('Daily rewards phụ thuộc'), findsOneWidget);
  });

  testWidgets('SC-032 reward row navigates to event detail', (tester) async {
    await pumpRewards(tester);

    await tester.tap(find.byKey(PredictionsRewardsPage.rewardKey('rw-1')));
    await tester.pumpAndSettle();

    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
  });

  testWidgets('SC-032 Arena edge is wired to Arena Home', (tester) async {
    await pumpRewards(tester);

    await tester.ensureVisible(
      find.byKey(PredictionsRewardsPage.arenaBridgeKey),
    );
    await tester.tap(find.byKey(PredictionsRewardsPage.arenaBridgeKey));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaHomePage), findsOneWidget);
  });
}
