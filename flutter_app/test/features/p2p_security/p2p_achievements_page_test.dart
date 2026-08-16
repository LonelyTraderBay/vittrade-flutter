import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_achievements_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_trading_level_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAchievements(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pAchievements,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-275 mock repository exposes achievements BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getAchievements();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-achievements');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Thành tích P2P');
    expect(snapshot.subtitle, 'Thành tích · P2P');
    expect(snapshot.currentLevel, 3);
    expect(snapshot.achievements, hasLength(9));
    expect(snapshot.categories, hasLength(4));
    expect(snapshot.unlockedCount, 5);
    expect(snapshot.totalReputationPoints, 20);
    expect(snapshot.unlockedBadgeCount, 2);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.tradingLevelRoute, AppRoutePaths.p2pTradingLevel);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-275 renders achievements baseline', (tester) async {
    await pumpAchievements(tester);

    expect(find.byType(P2PAchievementsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thành tích P2P'), findsOneWidget);
    expect(find.text('Thành tích · P2P'), findsOneWidget);
    expect(find.byKey(P2PAchievementsPage.summaryKey), findsOneWidget);
    expect(find.text('Thành tích đạt được'), findsOneWidget);
    expect(find.text('5/9'), findsOneWidget);
    expect(find.text('+20'), findsOneWidget);
    expect(find.text('Lv.3'), findsOneWidget);
    expect(
      find.byKey(P2PAchievementsPage.categoryKey('trades')),
      findsOneWidget,
    );
    expect(find.text('Giao dịch'), findsAtLeastNWidgets(1));
    expect(
      find.byKey(P2PAchievementsPage.achievementKey('ach001')),
      findsOneWidget,
    );
    expect(find.text('Giao dịch đầu tiên'), findsOneWidget);
    expect(find.text('+5 điểm uy tín'), findsOneWidget);
  });

  testWidgets('SC-275 first viewport reaches summary and first category', (
    tester,
  ) async {
    await pumpAchievements(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-275 P2PAchievementsPage',
      semanticLabel: 'Thành tích P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAchievementsPage.summaryKey),
      routeName: 'SC-275 P2PAchievementsPage',
      actionLabel: 'achievements summary',
      minVisibleHeight: 80,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAchievementsPage.categoryKey('trades')),
      routeName: 'SC-275 P2PAchievementsPage',
      actionLabel: 'first achievement category',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-275 renders category progress while scrolling', (
    tester,
  ) async {
    await pumpAchievements(tester);

    await tester.ensureVisible(
      find.byKey(P2PAchievementsPage.achievementKey('ach009')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đặc biệt'), findsOneWidget);
    expect(find.text('Tốc độ thanh toán'), findsOneWidget);
    expect(find.text('Huy hiệu "Nhanh nhẹn"'), findsOneWidget);
  });

  testWidgets('SC-275 trading level navigation edge is wired', (tester) async {
    await pumpAchievements(tester);

    await tester.ensureVisible(find.byKey(P2PAchievementsPage.tradingLevelKey));
    await tester.tap(find.byKey(P2PAchievementsPage.tradingLevelKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PAchievementsPage), findsNothing);
    expect(find.byType(P2PTradingLevelPage), findsOneWidget);
  });

  testWidgets('SC-275 header back returns to P2P parent', (tester) async {
    await pumpAchievements(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PAchievementsPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}
