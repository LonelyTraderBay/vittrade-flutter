import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/phone/pages/rewards_hub_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/my_arena_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMyArena(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.arenaMy,
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

  test('SC-168 mock repository exposes My Arena BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getMyArena();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-arena');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.stats.currentBalance, 2220);
    expect(snapshot.stats.activeChallenges, 5);
    expect(snapshot.myRooms.map((challenge) => challenge.id), [
      'ch001',
      'ch002',
      'ch003',
    ]);
    expect(snapshot.savedModes.first.id, 'mode001');
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

  test('SC-205 mock repository exposes Arena My BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaMy();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-my');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.stats.currentBalance, 2220);
    expect(snapshot.myRooms.first.id, 'ch001');
    expect(snapshot.rewardHistory.totalReceipts, 12);
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

  testWidgets('SC-168 redirects to canonical My Arena route', (tester) async {
    await pumpMyArena(tester, initialLocation: AppRoutePaths.profileArena);

    expect(find.byType(MyArenaPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_trade')),
      findsOneWidget,
    );
    expect(find.text('S\u00E2n ch\u01A1i c\u1EE7a t\u00F4i'), findsOneWidget);
    expect(find.text('Điểm Arena'), findsOneWidget);
    expect(find.text('Chỉ điểm Arena'), findsOneWidget);
    expect(find.text('2.2K'), findsOneWidget);
    expect(find.text('Tạo thách đấu mới'), findsOneWidget);
    expect(find.text('BTC \$70K? - Tu\u1EA7n 9'), findsOneWidget);
  });

  testWidgets('SC-205 renders My Arena at arena route with trade nav active', (
    tester,
  ) async {
    await pumpMyArena(tester);

    expect(find.byType(MyArenaPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsNothing,
    );
    expect(find.text('S\u00E2n ch\u01A1i c\u1EE7a t\u00F4i'), findsOneWidget);
    expect(find.text('Điểm Arena'), findsOneWidget);
    expect(find.text('Chỉ điểm Arena'), findsOneWidget);
    expect(find.text('2.2K'), findsOneWidget);
    expect(find.text('Tạo thách đấu mới'), findsOneWidget);
    expect(find.text('BTC \$70K? - Tu\u1EA7n 9'), findsOneWidget);
  });

  testWidgets('SC-168 redirect reaches canonical create challenge action', (
    tester,
  ) async {
    await pumpMyArena(tester, initialLocation: AppRoutePaths.profileArena);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'Arena MyArenaPage',
      semanticLabel:
          'Sân chơi của tôi - quản lý phòng, thử thách đã tham gia và lịch sử trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MyArenaPage.createChallengeKey),
      routeName: 'Arena MyArenaPage',
      actionLabel: 'create challenge action',
    );
  });

  testWidgets('SC-205 first viewport reaches create challenge action', (
    tester,
  ) async {
    await pumpMyArena(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'Arena MyArenaPage',
      semanticLabel:
          'Sân chơi của tôi - quản lý phòng, thử thách đã tham gia và lịch sử trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MyArenaPage.createChallengeKey),
      routeName: 'Arena MyArenaPage',
      actionLabel: 'create challenge action',
    );
  });

  testWidgets('SC-205 switches local tabs with stable mock data', (
    tester,
  ) async {
    await pumpMyArena(tester);

    await tester.ensureVisible(find.byKey(MyArenaPage.tabKey('saved_modes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MyArenaPage.tabKey('saved_modes')));
    await tester.pumpAndSettle();
    expect(find.text('BTC Weekly Predict'), findsOneWidget);
    expect(find.text('Fair play'), findsWidgets);

    await tester.ensureVisible(find.byKey(MyArenaPage.tabKey('drafts')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MyArenaPage.tabKey('drafts')));
    await tester.pumpAndSettle();
    expect(find.text('SOL vs DOT Prediction'), findsOneWidget);

    await tester.ensureVisible(find.byKey(MyArenaPage.tabKey('history')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MyArenaPage.tabKey('history')));
    await tester.pumpAndSettle();
    expect(find.text('Crypto Quiz Night #11'), findsOneWidget);
  });

  testWidgets('SC-205 canonical route edges open arena safety pages', (
    tester,
  ) async {
    await pumpMyArena(tester, initialLocation: AppRoutePaths.arenaMy);
    await tester.ensureVisible(find.byKey(MyArenaPage.reportsKey));
    await tester.tap(find.byKey(MyArenaPage.reportsKey));
    await tester.pumpAndSettle();
    expect(find.text('B\u00E1o c\u00E1o c\u1EE7a t\u00F4i'), findsOneWidget);

    await pumpMyArena(tester, initialLocation: AppRoutePaths.arenaMy);
    await tester.ensureVisible(find.byKey(MyArenaPage.blockedKey));
    await tester.tap(find.byKey(MyArenaPage.blockedKey));
    await tester.pumpAndSettle();
    expect(find.text('Ng\u01B0\u1EDDi \u0111\u00E3 ch\u1EB7n'), findsOneWidget);

    await pumpMyArena(tester, initialLocation: AppRoutePaths.arenaMy);
    await tester.ensureVisible(find.byKey(MyArenaPage.safetyKey));
    await tester.tap(find.byKey(MyArenaPage.safetyKey));
    await tester.pumpAndSettle();
    expect(find.text('An to\u00E0n & Quy t\u1EAFc Arena'), findsOneWidget);
  });

  testWidgets('SC-205 canonical route edges open real or preview routes', (
    tester,
  ) async {
    await pumpMyArena(tester);
    await tester.tap(find.byKey(MyArenaPage.createChallengeKey));
    await tester.pumpAndSettle();
    expect(find.text('Arena Studio'), findsOneWidget);

    await pumpMyArena(tester);
    await tester.tap(find.byKey(MyArenaPage.challengeKey('ch001')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);

    await pumpMyArena(tester);
    await tester.ensureVisible(find.byKey(MyArenaPage.pointsDetailKey));
    await tester.tap(find.byKey(MyArenaPage.pointsDetailKey));
    await tester.pumpAndSettle();
    expect(find.byType(RewardsHubPage), findsOneWidget);

    await pumpMyArena(tester);
    await tester.ensureVisible(find.byKey(MyArenaPage.reportsKey));
    await tester.tap(find.byKey(MyArenaPage.reportsKey));
    await tester.pumpAndSettle();
    expect(find.text('Báo cáo của tôi'), findsOneWidget);

    await pumpMyArena(tester);
    await tester.ensureVisible(find.byKey(MyArenaPage.blockedKey));
    await tester.tap(find.byKey(MyArenaPage.blockedKey));
    await tester.pumpAndSettle();
    expect(find.text('Người đã chặn'), findsOneWidget);

    await pumpMyArena(tester);
    await tester.ensureVisible(find.byKey(MyArenaPage.safetyKey));
    await tester.tap(find.byKey(MyArenaPage.safetyKey));
    await tester.pumpAndSettle();
    expect(find.text('An toàn & Quy tắc Arena'), findsOneWidget);
  });
}
