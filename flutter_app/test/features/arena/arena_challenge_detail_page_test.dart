import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_creator_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_mode_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpChallengeDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaChallenge('ch003'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-190 mock repository exposes Challenge Detail BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaChallengeDetail('ch003');

    expect(snapshot.endpoint, '/api/mobile/arena/arena-challenge-ch003');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.challenge.id, 'ch003');
    expect(snapshot.challenge.modeId, 'mode002');
    expect(snapshot.challenge.state, ArenaChallengeState.live);
    expect(snapshot.teams.map((team) => team.name), contains('Team SOL'));
    expect(snapshot.teams.map((team) => team.name), contains('Team AVAX'));
    expect(snapshot.predictionContext.eventId, 'pred-1');
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

  testWidgets('SC-190 renders Arena Challenge Detail baseline', (tester) async {
    await pumpChallengeDetail(tester);

    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết challenge'), findsOneWidget);
    expect(find.text('Thử thách · Open Arena'), findsOneWidget);
    expect(find.text('Altcoin Team Battle — SOL vs AVAX'), findsOneWidget);
    expect(find.text('Altcoin Battle Royale'), findsOneWidget);
    expect(find.text('Đang diễn ra'), findsOneWidget);
    expect(find.text('NvN'), findsOneWidget);
    expect(find.text('Công khai'), findsWidgets);
    expect(find.text('Points Only'), findsOneWidget);
    expect(find.text('Points-only review'), findsOneWidget);
    expect(find.text('Net Points pool'), findsOneWidget);
    expect(find.text('Entry Points'), findsOneWidget);
    expect(find.text('7.2K'), findsWidgets);
    expect(find.text('Team SOL'), findsWidgets);
    expect(find.text('Team AVAX'), findsWidgets);
    expect(find.text('Tóm tắt luật chơi'), findsOneWidget);
  });

  testWidgets('SC-190 first viewport reaches live points summary', (
    tester,
  ) async {
    await pumpChallengeDetail(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ArenaChallengeDetailPage',
      semanticLabel: 'Chi tiết thử thách trong Open Arena',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Entry Points'),
      targetLabel: 'the live Entry Points summary',
      reason:
          'ArenaChallengeDetailPage should expose the live Entry Points summary before the bottom navigation.',
    );
  });

  testWidgets('SC-190 tabs and action sheets expose local state', (
    tester,
  ) async {
    await pumpChallengeDetail(tester);

    await tester.ensureVisible(
      find.byKey(ArenaChallengeDetailPage.tabKey('evidence')),
    );
    await tester.tap(find.byKey(ArenaChallengeDetailPage.tabKey('evidence')));
    await tester.pumpAndSettle();

    expect(find.text('Bằng chứng'), findsWidgets);
    expect(find.textContaining('Chưa có bằng chứng'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ArenaChallengeDetailPage.evidenceCtaKey),
    );
    await tester.tap(find.byKey(ArenaChallengeDetailPage.evidenceCtaKey));
    await tester.pumpAndSettle();

    expect(find.text('Gửi bằng chứng'), findsWidgets);
    expect(find.textContaining('API CoinGecko'), findsWidgets);
  });

  testWidgets('SC-190 navigation edges use canonical Arena routes', (
    tester,
  ) async {
    await pumpChallengeDetail(tester);

    await tester.tap(find.byKey(ArenaChallengeDetailPage.modeLinkKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaModeDetailPage), findsOneWidget);

    await pumpChallengeDetail(tester);
    await tester.ensureVisible(find.byKey(ArenaChallengeDetailPage.creatorKey));
    await tester.tap(find.byKey(ArenaChallengeDetailPage.creatorKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaCreatorPage), findsOneWidget);

    await pumpChallengeDetail(tester);
    await tester.ensureVisible(find.byKey(ArenaChallengeDetailPage.safetyKey));
    await tester.tap(find.byKey(ArenaChallengeDetailPage.safetyKey));
    await tester.pumpAndSettle();
    expect(find.text('An toàn & Quy tắc Arena'), findsOneWidget);

    await pumpChallengeDetail(tester);
    await tester.ensureVisible(
      find.byKey(ArenaChallengeDetailPage.predictionKey),
    );
    await tester.tap(find.byKey(ArenaChallengeDetailPage.predictionKey));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
  });
}
