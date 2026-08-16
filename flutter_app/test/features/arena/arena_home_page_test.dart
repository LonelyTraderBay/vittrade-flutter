import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/my_arena_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/verified_challenges_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpArenaHome(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.arena),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-184 mock repository exposes Arena Home BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaHome();

    expect(snapshot.endpoint, '/api/mobile/arena/arena');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.templates.length, 6);
    expect(snapshot.featuredModes.first.id, 'mode001');
    expect(snapshot.liveRooms.map((room) => room.id), contains('ch003'));
    expect(snapshot.creators.first.id, 'cr001');
    expect(
      snapshot.trustSignals.map((signal) => signal.value),
      contains('no wallet value'),
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

  testWidgets('SC-184 renders Arena Home baseline', (tester) async {
    await pumpArenaHome(tester);

    expect(find.byType(ArenaHomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Open Arena'), findsWidgets);
    expect(find.text('Điểm Arena · thách đấu · hoàn thành'), findsOneWidget);
    expect(find.text('Chỉ điểm Arena'), findsOneWidget);
    expect(find.text('Thử thách cộng đồng'), findsOneWidget);
    expect(find.text('Mẫu thách đấu'), findsOneWidget);
    expect(find.text('Prediction'), findsWidgets);
    expect(find.text('Mode nổi bật'), findsOneWidget);
    expect(find.text('BTC Weekly Predict'), findsOneWidget);
    expect(find.text('Phòng đang mở'), findsOneWidget);
    expect(find.text('BTC \$70K? — Tuần 9'), findsOneWidget);
  });

  testWidgets('SC-184 first viewport reaches first arena template card', (
    tester,
  ) async {
    await pumpArenaHome(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ArenaHomePage',
      semanticLabel:
          'Trang chủ Open Arena - khám phá và tham gia thử thách công bằng',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ArenaHomePage.templateKey('prediction')),
      targetLabel: 'first arena template card',
      minVisibleHeight: 24,
    );
    expect(
      tester.getSize(find.byKey(ArenaHomePage.createChallengeKey)).height,
      lessThanOrEqualTo(44),
      reason: 'Arena hero CTAs should use compact touch-safe height.',
    );
    expect(
      tester
          .getSize(find.byKey(ArenaHomePage.templateKey('prediction')).first)
          .height,
      // A11Y-3: ArenaSpacingTokens.arenaHomeTemplateExtent raised 90->98 so
      // a 2-line title + description + tags fit at the 1.3x text-scaling
      // clamp without overflowing.
      lessThanOrEqualTo(98),
      reason: 'Arena template tiles should stay compact in the first viewport.',
    );
    final finalTemplateBottom = tester
        .getRect(find.byKey(ArenaHomePage.templateKey('proof_challenge')).first)
        .bottom;
    final featuredModesTop = tester.getRect(find.text('Mode nổi bật')).top;
    expect(
      featuredModesTop - finalTemplateBottom,
      lessThanOrEqualTo(16),
      reason: 'Templates should hand off tightly to featured modes.',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-184 search filters modes and rooms', (tester) async {
    await pumpArenaHome(tester);

    await tester.enterText(find.byType(TextField), 'BTC');
    await tester.pumpAndSettle();

    expect(find.text('2 kết quả cho "BTC"'), findsOneWidget);
    expect(find.text('Modes (1)'), findsOneWidget);
    expect(find.text('Phòng (1)'), findsOneWidget);
    expect(find.text('BTC Weekly Predict'), findsOneWidget);
    expect(find.text('BTC \$70K? — Tuần 9'), findsOneWidget);
  });

  testWidgets('SC-184 navigation edges open canonical Arena routes', (
    tester,
  ) async {
    await pumpArenaHome(tester);
    await tester.tap(find.byKey(ArenaHomePage.toolsActionKey));
    await tester.pumpAndSettle();
    expect(find.byKey(ArenaHomePage.toolsSheetKey), findsOneWidget);
    expect(find.text('Công cụ Arena'), findsOneWidget);
    expect(find.text('Hướng dẫn'), findsWidgets);
    expect(find.text('Bảng xếp hạng'), findsWidgets);
    expect(find.text('Studio'), findsWidgets);
    await tester.tap(find.byKey(ArenaHomePage.toolKey('leaderboard')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaLeaderboardPage), findsOneWidget);

    await pumpArenaHome(tester);
    await tester.tap(find.byKey(ArenaHomePage.myArenaHeaderKey));
    await tester.pumpAndSettle();
    expect(find.byType(MyArenaPage), findsOneWidget);

    await pumpArenaHome(tester);
    await tester.tap(find.byKey(ArenaHomePage.createChallengeKey));
    await tester.pumpAndSettle();
    expect(find.text('Arena Studio'), findsOneWidget);

    await pumpArenaHome(tester);
    await tester.tap(find.byKey(ArenaHomePage.quickLeaderboardKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaLeaderboardPage), findsOneWidget);

    await pumpArenaHome(tester);
    await tester.ensureVisible(find.byKey(ArenaHomePage.modeKey('mode001')));
    await tester.tap(find.byKey(ArenaHomePage.modeKey('mode001')));
    await tester.pumpAndSettle();
    expect(find.text('Chế độ chơi · Open Arena'), findsOneWidget);

    await pumpArenaHome(tester);
    await tester.ensureVisible(find.byKey(ArenaHomePage.roomKey('ch003')));
    await tester.tap(find.byKey(ArenaHomePage.roomKey('ch003')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);

    await pumpArenaHome(tester);
    await tester.ensureVisible(find.byKey(ArenaHomePage.verifiedTeaserKey));
    await tester.tap(find.byKey(ArenaHomePage.verifiedTeaserKey));
    await tester.pumpAndSettle();
    expect(find.byType(VerifiedChallengesPage), findsOneWidget);
  });
}
