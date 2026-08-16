import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_join_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpJoinPage(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaJoin('ch003'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-191 mock repository exposes Arena Join BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaJoin('ch003');

    expect(snapshot.endpoint, '/api/mobile/arena/arena-join-ch003');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.challenge.id, 'ch003');
    expect(snapshot.challenge.entryPoints, 200);
    expect(snapshot.currentBalance, 2220);
    expect(snapshot.rules.length, 5);
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

  testWidgets('SC-191 renders Arena Join baseline', (tester) async {
    await pumpJoinPage(tester);

    expect(find.byType(ArenaJoinPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tham gia thử thách'), findsOneWidget);
    expect(find.text('Xác nhận · Open Arena'), findsOneWidget);
    expect(find.text('Altcoin Team Battle — SOL vs AVAX'), findsOneWidget);
    expect(find.text('Altcoin Battle Royale'), findsOneWidget);
    expect(find.text('Team Battle'), findsOneWidget);
    expect(find.text('Công khai'), findsOneWidget);
    expect(find.text('40/40'), findsOneWidget);
    expect(find.text('Đã hết hạn'), findsOneWidget);
    expect(find.text('ArenaKing'), findsOneWidget);
    expect(find.text('Tóm tắt luật'), findsOneWidget);
    expect(find.text('Số dư Arena Points'), findsOneWidget);
    expect(find.text('2.2K pts'), findsOneWidget);
    expect(find.text('-200 pts'), findsOneWidget);
    expect(find.text('2.0K pts'), findsOneWidget);
    expect(find.text('Xem chính sách hủy/void'), findsOneWidget);
    expect(find.text('Xác nhận tham gia · 200 pts'), findsOneWidget);
    expect(find.text('Từ chối'), findsOneWidget);
  });

  testWidgets('SC-191 first viewport exposes safety acknowledgements', (
    tester,
  ) async {
    await pumpJoinPage(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-191 ArenaJoinPage',
      semanticLabel: 'Xác nhận tham gia thử thách trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaJoinPage.safetyPolicyKey),
      routeName: 'SC-191 ArenaJoinPage',
      actionLabel: 'the safety policy link',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaJoinPage.rulesCheckboxKey),
      routeName: 'SC-191 ArenaJoinPage',
      actionLabel: 'the rules acknowledgement checkbox',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-191 acknowledgements enable join confirmation', (
    tester,
  ) async {
    await pumpJoinPage(tester);

    await tester.ensureVisible(find.byKey(ArenaJoinPage.confirmKey));
    await tester.tap(find.byKey(ArenaJoinPage.confirmKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaJoinPage), findsOneWidget);

    await tester.ensureVisible(find.byKey(ArenaJoinPage.rulesCheckboxKey));
    await tester.tap(find.byKey(ArenaJoinPage.rulesCheckboxKey));
    await tester.ensureVisible(find.byKey(ArenaJoinPage.pointsCheckboxKey));
    await tester.tap(find.byKey(ArenaJoinPage.pointsCheckboxKey));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ArenaJoinPage.confirmKey));
    await tester.tap(find.byKey(ArenaJoinPage.confirmKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);
  });

  testWidgets('SC-191 navigation edges use canonical Arena routes', (
    tester,
  ) async {
    await pumpJoinPage(tester);
    await tester.ensureVisible(find.byKey(ArenaJoinPage.safetyPolicyKey));
    await tester.tap(find.byKey(ArenaJoinPage.safetyPolicyKey));
    await tester.pumpAndSettle();
    expect(find.text('An toàn & Quy tắc Arena'), findsOneWidget);

    await pumpJoinPage(tester);
    await tester.ensureVisible(find.byKey(ArenaJoinPage.declineKey));
    await tester.tap(find.byKey(ArenaJoinPage.declineKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);
  });
}
