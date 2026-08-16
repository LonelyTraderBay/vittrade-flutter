import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_creator_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_safety_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

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
            initialLocation: AppRoutePaths.arenaLeaderboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-194 mock repository exposes Arena Leaderboard BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaLeaderboard();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-leaderboard');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.myRank.rank, 142);
    expect(snapshot.metricChips.map((chip) => chip.id), contains('fair_play'));
    expect(
      snapshot.seasonFilters.map((filter) => filter.id),
      contains('monthly'),
    );
    expect(
      snapshot.podium.map((entry) => entry.name),
      contains('CryptoMaster_VN'),
    );
    expect(
      snapshot.topCreators.map((entry) => entry.name),
      contains('PredictorPro'),
    );
    expect(
      snapshot.risingCreators.map((entry) => entry.name),
      contains('GameMaker_HN'),
    );
    expect(
      snapshot.disclaimer,
      contains('Arena Points không phải tài sản tài chính'),
    );
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-194 renders Arena Leaderboard baseline', (tester) async {
    await pumpLeaderboard(tester);

    expect(find.byType(ArenaLeaderboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bảng xếp hạng'), findsOneWidget);
    expect(find.text('Fair play · Open Arena'), findsOneWidget);
    expect(find.text('Hạng của bạn'), findsOneWidget);
    expect(find.text('#142'), findsOneWidget);
    expect(find.text('4.5K pts'), findsOneWidget);
    expect(find.text('Creators'), findsOneWidget);
    expect(find.text('Fair Play'), findsWidgets);
    expect(find.text('Tháng'), findsOneWidget);
    expect(find.text('CryptoMaster_VN'), findsOneWidget);
    expect(find.text('Top Creators'), findsOneWidget);
    expect(find.text('PredictorPro'), findsWidgets);
    expect(find.text('Rising Creators'), findsOneWidget);
  });

  testWidgets('SC-194 first viewport reaches first creator row', (
    tester,
  ) async {
    await pumpLeaderboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ArenaLeaderboardPage',
      semanticLabel: 'Bảng xếp hạng fair play trong Open Arena',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ArenaLeaderboardPage.creatorRowKey),
      targetLabel: 'first creator row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-194 tab state switches to players view', (tester) async {
    await pumpLeaderboard(tester);

    await tester.tap(find.text('Players'));
    await tester.pumpAndSettle();

    expect(find.text('Players'), findsWidgets);
    expect(find.textContaining('cùng bộ lọc Fair Play'), findsOneWidget);
  });

  testWidgets('SC-194 navigation edges use canonical Arena routes', (
    tester,
  ) async {
    await pumpLeaderboard(tester);

    await tester.tap(find.byKey(ArenaLeaderboardPage.creatorRowKey).first);
    await tester.pumpAndSettle();
    expect(find.byType(ArenaCreatorPage), findsOneWidget);

    await pumpLeaderboard(tester);
    await tester.ensureVisible(find.byKey(ArenaLeaderboardPage.rulesKey));
    await tester.tap(find.byKey(ArenaLeaderboardPage.rulesKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaSafetyCenterPage), findsOneWidget);
  });
}
