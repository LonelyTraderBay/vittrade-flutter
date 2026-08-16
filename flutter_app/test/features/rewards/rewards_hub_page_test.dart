import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_home_page.dart';
import 'package:vit_trade_flutter/features/rewards/data/rewards_repository.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/phone/pages/rewards_hub_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRewards(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.rewards,
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

  test('SC-319 mock repository exposes rewards hub BE draft', () async {
    final snapshot = await const MockRewardsRepository(
      loadDelay: Duration.zero,
    ).getHub();

    expect(snapshot.endpoint, '/api/mobile/rewards/rewards');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Trung tâm Phần thưởng');
    expect(snapshot.subtitle, 'Phần thưởng · Rewards');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.referralRoute, AppRoutePaths.referral);
    expect(snapshot.leaderboardRoute, AppRoutePaths.arenaLeaderboard);
    expect(snapshot.summary.currentPoints, 2220);
    expect(snapshot.summary.lockedPoints, 450);
    expect(snapshot.summary.pendingCount, 3);
    expect(
      snapshot.categories.map((category) => category.id),
      contains('arena'),
    );
    expect(snapshot.tasks.map((task) => task.id), contains('task-thang3'));
    expect(snapshot.leaderboard.first.name, 'CryptoWhale');
    expect(snapshot.contractNotes, contains('Rewards Hub is read-only'));
    expect(
      snapshot.supportedStates,
      containsAll([
        RewardsScreenState.loading,
        RewardsScreenState.empty,
        RewardsScreenState.error,
        RewardsScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-319 renders rewards hub baseline structure', (tester) async {
    await pumpRewards(tester);

    expect(find.byType(RewardsHubPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.textContaining('Rewards'), findsWidgets);
    expect(find.textContaining('Points'), findsWidgets);
    expect(find.text('Arena Points'), findsOneWidget);
    expect(find.textContaining('Check-in'), findsOneWidget);
    expect(find.byKey(RewardsHubPage.claimAllKey), findsOneWidget);
  });

  testWidgets(
    'SC-319 claimed task card looks visually compact (no dead bottom gap)',
    (tester) async {
      await pumpRewards(tester);

      final taskFinder = find.byKey(RewardsHubPage.taskKey('task-first'));
      await tester.drag(
        find.byKey(RewardsHubPage.contentKey),
        const Offset(0, -900),
      );
      await tester.pumpAndSettle();

      const legacyMinHeight =
          AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x5;
      final taskHeight = tester.getSize(taskFinder).height;

      expect(
        taskHeight,
        lessThan(legacyMinHeight - 20),
        reason: 'Claimed task card should not show a large empty bottom band',
      );
      expect(find.text('Giao dịch đầu tiên'), findsOneWidget);
      expect(find.text('Đã nhận'), findsWidgets);
    },
  );

  testWidgets('SC-319 first viewport reaches reward claim action', (
    tester,
  ) async {
    await pumpRewards(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-319 RewardsHubPage',
      semanticLabel: 'Trung tâm Phần thưởng',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(RewardsHubPage.claimAllKey),
      routeName: 'SC-319 RewardsHubPage',
      actionLabel: 'the claim all rewards action',
    );
  });

  testWidgets('SC-319 auto-hides rewards header on scroll', (tester) async {
    await pumpRewards(tester);

    double headerHeight() {
      return tester
          .getSize(find.byKey(VitAutoHideHeaderScaffold.headerHostKey))
          .height;
    }

    expect(headerHeight(), greaterThan(0));

    await tester.drag(
      find.byKey(RewardsHubPage.contentKey),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(headerHeight(), 0);

    await tester.drag(
      find.byKey(RewardsHubPage.contentKey),
      const Offset(0, 160),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(headerHeight(), greaterThan(0));
  });

  testWidgets('SC-319 filters reward tasks and supports claim-all state', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.tap(find.byKey(RewardsHubPage.claimAllKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã nhận hết phần thưởng chờ'), findsOneWidget);

    await tester.drag(
      find.byKey(RewardsHubPage.contentKey),
      const Offset(0, -280),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(RewardsHubPage.filterKey('Flash')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Flash: Mua BTC'), findsOneWidget);
    expect(find.textContaining('Flash 3'), findsOneWidget);
    expect(find.textContaining('Volume tu'), findsNothing);
  });

  testWidgets('SC-319 tab query preselects Arena and invalid tab is safe', (
    tester,
  ) async {
    await pumpRewards(
      tester,
      initialLocation: '${AppRoutePaths.rewards}?tab=arena',
    );

    expect(find.byKey(RewardsHubPage.activeFilterKey('Arena')), findsOneWidget);
    expect(find.textContaining('Open Arena'), findsWidgets);

    await pumpRewards(
      tester,
      initialLocation: '${AppRoutePaths.rewards}?tab=wallet',
    );

    expect(find.byType(RewardsHubPage), findsOneWidget);
    expect(find.byKey(RewardsHubPage.activeFilterKey('Arena')), findsNothing);
    expect(find.textContaining('Flash: Mua BTC'), findsOneWidget);
  });

  testWidgets('SC-319 referral and leaderboard links use resolved routes', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.ensureVisible(find.byKey(RewardsHubPage.referralKey));
    await tester.tap(find.byKey(RewardsHubPage.referralKey));
    await tester.pumpAndSettle();
    expect(find.byType(ReferralHomePage), findsOneWidget);

    await pumpRewards(tester);
    await tester.ensureVisible(find.byKey(RewardsHubPage.leaderboardKey));
    await tester.tap(find.byKey(RewardsHubPage.leaderboardKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaLeaderboardPage), findsOneWidget);
  });
}
