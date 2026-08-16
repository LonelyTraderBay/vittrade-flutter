import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_creator_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_mode_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_studio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpModeDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaMode('mode001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-189 mock repository exposes Arena Mode Detail BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaModeDetail('mode001');

    expect(snapshot.endpoint, '/api/mobile/arena/arena-mode-mode001');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.mode.id, 'mode001');
    expect(snapshot.template.id, 'closest_guess');
    expect(snapshot.creator.id, 'cr001');
    expect(snapshot.mode.tags, containsAll(['Crypto', 'Weekly', 'Popular']));
    expect(snapshot.relatedRooms.map((room) => room.id), contains('ch001'));
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

  testWidgets('SC-189 renders Arena Mode Detail baseline', (tester) async {
    await pumpModeDetail(tester);

    expect(find.byType(ArenaModeDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC Weekly Predict'), findsWidgets);
    expect(find.text('Chế độ chơi · Open Arena'), findsOneWidget);
    expect(find.text('Closest Guess template'), findsOneWidget);
    expect(find.text('CryptoMaster_VN'), findsOneWidget);
    expect(find.text('Trust Score: 95%'), findsOneWidget);
    expect(find.text('Points-only'), findsOneWidget);
    expect(find.text('Mô tả'), findsOneWidget);
    expect(find.text('Tóm tắt luật chơi'), findsOneWidget);
    expect(find.text('Chất lượng & Tin cậy'), findsOneWidget);
    expect(find.text('Dùng mode này'), findsOneWidget);
  });

  testWidgets('SC-189 first viewport exposes mode action controls', (
    tester,
  ) async {
    await pumpModeDetail(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-189 ArenaModeDetailPage',
      semanticLabel:
          'Chi tiết chế độ chơi trong Open Arena - luật, người tạo và chỉ số chất lượng',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaModeDetailPage.useModeKey),
      routeName: 'SC-189 ArenaModeDetailPage',
      actionLabel: 'the use mode action',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-189 trust sheet exposes metric explanations', (tester) async {
    await pumpModeDetail(tester);

    await tester.ensureVisible(find.byKey(ArenaModeDetailPage.infoKey));
    await tester.tap(find.byKey(ArenaModeDetailPage.infoKey));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết tin cậy'), findsOneWidget);
    expect(find.text('CryptoMaster_VN · 95% Trust'), findsOneWidget);
    expect(find.text('Fair Play'), findsWidgets);
    expect(find.textContaining('không phải chỉ số tài chính'), findsOneWidget);
  });

  testWidgets('SC-189 navigation edges use canonical Arena routes', (
    tester,
  ) async {
    await pumpModeDetail(tester);

    await tester.tap(find.byKey(ArenaModeDetailPage.creatorKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaCreatorPage), findsOneWidget);

    await pumpModeDetail(tester);
    await tester.tap(find.byKey(ArenaModeDetailPage.trustKey));
    await tester.pumpAndSettle();
    expect(find.text('Trust Score'), findsOneWidget);

    await pumpModeDetail(tester);
    await tester.ensureVisible(find.byKey(ArenaModeDetailPage.useModeKey));
    await tester.tap(find.byKey(ArenaModeDetailPage.useModeKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaStudioPage), findsOneWidget);

    await pumpModeDetail(tester);
    await tester.ensureVisible(
      find.byKey(ArenaModeDetailPage.roomKey('ch001')),
    );
    await tester.tap(find.byKey(ArenaModeDetailPage.roomKey('ch001')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);
  });
}
