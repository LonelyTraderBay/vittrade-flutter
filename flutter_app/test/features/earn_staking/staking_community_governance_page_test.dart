import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_community_governance_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_forum_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpGovernance(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnCommunityGovernance,
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

  test('SC-388 mock repository exposes governance BE draft', () async {
    final snapshot = await const MockStakingCommunityGovernanceRepository()
        .getGovernance();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-community-governance');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Governance');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.proposalsRoute, AppRoutePaths.earnProposals);
    expect(snapshot.forumRoute, AppRoutePaths.earnForum);
    expect(snapshot.stats, hasLength(4));
    expect(snapshot.stats[1].value, '45,000');
    expect(snapshot.activeProposal.badge, '3 Active');
    expect(snapshot.recentDecisions, hasLength(3));
    expect(snapshot.governanceSteps, hasLength(4));
    expect(snapshot.votingPower.value, '12,500');
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-388 renders governance banner and overview stats', (
    tester,
  ) async {
    await pumpGovernance(tester);

    expect(find.byType(StakingCommunityGovernancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Governance'), findsOneWidget);
    expect(find.byKey(StakingCommunityGovernancePage.infoKey), findsOneWidget);
    expect(find.text('Community-Driven Decisions'), findsOneWidget);
    expect(
      find.textContaining('Your stake = your voting power'),
      findsOneWidget,
    );

    expect(
      find.byKey(StakingCommunityGovernancePage.overviewKey),
      findsOneWidget,
    );
    expect(find.text('Governance Overview'), findsOneWidget);
    expect(find.text('125,000'), findsOneWidget);
    expect(find.text('Token Holders'), findsOneWidget);
    expect(find.text('45,000'), findsOneWidget);
    expect(find.text('Active Voters'), findsOneWidget);
    expect(find.text('89/127'), findsOneWidget);
  });

  testWidgets('SC-388 first viewport reaches governance overview', (
    tester,
  ) async {
    await pumpGovernance(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-388 StakingCommunityGovernancePage',
      semanticLabel: 'Quản trị cộng đồng stake',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(StakingCommunityGovernancePage.overviewKey),
      targetLabel: 'the governance overview',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-388 renders proposal entry and recent decisions', (
    tester,
  ) async {
    await pumpGovernance(tester);

    expect(find.text('Active Proposals'), findsOneWidget);
    expect(find.text('View All Active Proposals'), findsOneWidget);
    expect(find.text('3 Active'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.decisionsKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Recent Decisions'), findsOneWidget);
    expect(
      find.text('Reduce ETH staking fees from 2% to 1.5%'),
      findsOneWidget,
    );
    expect(find.text('Add Polygon validator support'), findsOneWidget);
    expect(find.text('Passed'), findsWidgets);
    expect(find.textContaining('89,234 votes'), findsOneWidget);
  });

  testWidgets('SC-388 renders governance steps, voting power, and footer', (
    tester,
  ) async {
    await pumpGovernance(tester);

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.stepsKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('How Governance Works'), findsOneWidget);
    expect(find.text('Proposal Creation'), findsOneWidget);
    expect(find.textContaining('>=10,000 tokens'), findsOneWidget);
    expect(find.text('Execution'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.votingPowerKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your Voting Power'), findsOneWidget);
    expect(find.text('12,500'), findsOneWidget);
    expect(find.text('votes (1.25% of total)'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.footerKey),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Governance is on-chain'), findsOneWidget);
  });

  testWidgets('SC-388 navigation edges open proposals and forum', (
    tester,
  ) async {
    await pumpGovernance(tester);

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.viewProposalsKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingCommunityGovernancePage.viewProposalsKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Proposals'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(StakingCommunityGovernancePage), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.joinForumKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingCommunityGovernancePage.joinForumKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingForumPage), findsOneWidget);
    expect(find.text('Forum'), findsOneWidget);
  });

  testWidgets('SC-388 header back returns to Earn route', (tester) async {
    await pumpGovernance(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
  });
}
