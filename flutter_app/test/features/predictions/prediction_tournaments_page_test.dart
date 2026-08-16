import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_tournaments_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTournaments(WidgetTester tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsTournaments,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-042 mock repository exposes the tournaments BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getTournaments();

    expect(snapshot.tournaments, hasLength(4));
    expect(snapshot.activeTournaments, hasLength(2));
    expect(snapshot.upcomingTournaments.single.name, 'Tech Innovation Cup');
    expect(snapshot.myTournaments.map((item) => item.id), ['tour1', 'tour4']);
    expect(snapshot.pastTournaments.single.name, 'Macro Economics Pro');
    expect(snapshot.leaderboard, hasLength(5));
    expect(snapshot.predictionEvents, isNotEmpty);
    expect(snapshot.orders, hasLength(3));
    expect(snapshot.receipts, hasLength(6));
    expect(snapshot.rewards, isNotEmpty);
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

  testWidgets('SC-042 renders active tournaments inside the Markets shell', (
    tester,
  ) async {
    await pumpTournaments(tester);

    expect(find.byType(PredictionTournamentsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tournaments'), findsOneWidget);
    expect(find.text('Giải đấu · Prediction'), findsOneWidget);
    expect(find.text('Dang dien ra'), findsOneWidget);
    expect(find.text('Cua toi'), findsOneWidget);
    expect(find.text('Ket thuc'), findsOneWidget);
    expect(find.text('Featured'), findsOneWidget);
    expect(find.text('Crypto Masters Q1 2026'), findsOneWidget);
    expect(find.text('#34 - 892 pts'), findsOneWidget);
    expect(find.text('\$50,000'), findsOneWidget);
    expect(find.text('Politics Prediction Challenge'), findsOneWidget);
  });

  testWidgets('SC-042 first viewport reaches featured tournament content', (
    tester,
  ) async {
    await pumpTournaments(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-042 PredictionTournamentsPage',
      semanticLabel: 'Giải đấu dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Crypto Masters Q1 2026'),
      targetLabel: 'the featured tournament title',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-042 tabs switch mine and ended content locally', (
    tester,
  ) async {
    await pumpTournaments(tester);

    await tester.tap(find.byKey(PredictionTournamentsPage.mineTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Tournament Stats'), findsOneWidget);
    expect(find.text('Best Rank'), findsOneWidget);
    expect(find.text('Giai dau dang tham gia'), findsOneWidget);
    expect(find.text('Macro Economics Pro'), findsOneWidget);

    await tester.tap(find.byKey(PredictionTournamentsPage.endedTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Giai dau da ket thuc'), findsOneWidget);
    expect(
      find.text('Final Leaderboard - Macro Economics Pro'),
      findsOneWidget,
    );
    expect(find.text('PredictionKing'), findsOneWidget);
  });

  testWidgets('SC-042 tournament card uses scoped detail route', (
    tester,
  ) async {
    await pumpTournaments(tester);

    await tester.tap(
      find.byKey(PredictionTournamentsPage.tournamentKey('tour1')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PredictionTournamentDetailPage), findsOneWidget);
    expect(find.text('Crypto Masters Q1 2026'), findsWidgets);
    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-414 PredictionTournamentDetailPage',
      semanticLabel: 'Chi tiết giải đấu dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Prize Pool'),
      targetLabel: 'the tournament detail stat grid',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-042 back button returns to Predictions home', (tester) async {
    await pumpTournaments(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
