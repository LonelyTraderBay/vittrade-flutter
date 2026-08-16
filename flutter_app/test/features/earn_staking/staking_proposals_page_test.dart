import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_community_governance_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_proposals_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_voting_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpProposals(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnProposals,
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

  test('SC-389 mock repository exposes proposals BE draft', () async {
    final snapshot = await const MockStakingProposalsRepository()
        .getProposals();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-proposals');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Proposals');
    expect(snapshot.backRoute, AppRoutePaths.earnCommunityGovernance);
    expect(snapshot.proposals, hasLength(3));
    expect(snapshot.proposals.first.id, 'prop001');
    expect(snapshot.proposals.first.votingRoute, '/earn/voting/prop001');
    expect(snapshot.proposals.first.yesPercent.toStringAsFixed(1), '70.0');
    expect(snapshot.proposals[1].category, 'Product');
    expect(snapshot.createLabel, contains('Requires 10K tokens'));
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

  testWidgets('SC-389 renders active proposals and vote ratios', (
    tester,
  ) async {
    await pumpProposals(tester);

    expect(find.byType(StakingProposalsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Proposals'), findsOneWidget);
    expect(find.byKey(StakingProposalsPage.listKey), findsOneWidget);
    expect(find.text('Active Proposals'), findsOneWidget);
    expect(
      find.byKey(StakingProposalsPage.proposalKey('prop001')),
      findsOneWidget,
    );
    expect(find.text('Lower ETH staking fees to 1%'), findsOneWidget);
    expect(find.text('Fees'), findsOneWidget);
    expect(find.text('5 days left'), findsOneWidget);
    expect(find.text('Yes 70.0%'), findsOneWidget);
    expect(find.text('No 30.0%'), findsOneWidget);
    expect(find.text('60,000 votes - 65% quorum'), findsOneWidget);
    expect(find.text('Vote Now'), findsNWidgets(3));
  });

  testWidgets('SC-389 renders remaining proposals and create CTA', (
    tester,
  ) async {
    await pumpProposals(tester);

    expect(find.text('Add support for Avalanche staking'), findsOneWidget);
    expect(find.text('Product'), findsOneWidget);
    expect(find.text('12 days left'), findsOneWidget);
    expect(find.text('Yes 63.3%'), findsOneWidget);
    expect(find.text('No 36.7%'), findsOneWidget);

    expect(
      find.text('Increase insurance fund to 200% coverage'),
      findsOneWidget,
    );
    expect(find.text('Risk'), findsOneWidget);
    expect(find.text('43,000 votes - 42% quorum'), findsOneWidget);
    expect(find.byKey(StakingProposalsPage.createKey), findsOneWidget);
    expect(
      find.text('Create New Proposal (Requires 10K tokens)'),
      findsOneWidget,
    );
  });

  testWidgets('SC-389 vote action opens voting detail', (tester) async {
    await pumpProposals(tester);

    await tester.tap(find.byKey(StakingProposalsPage.proposalKey('prop001')));
    await tester.pumpAndSettle();

    expect(find.byType(StakingVotingPage), findsOneWidget);
    expect(find.text('Proposal #127'), findsOneWidget);
  });

  testWidgets('SC-389 header back returns to community governance', (
    tester,
  ) async {
    await pumpProposals(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingCommunityGovernancePage), findsOneWidget);
    expect(find.text('Governance'), findsOneWidget);
  });

  testWidgets('SC-389 create proposal shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpProposals(tester);

    await tester.ensureVisible(find.byKey(StakingProposalsPage.createKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingProposalsPage.createKey));
    await tester.pumpAndSettle();

    expect(find.text('Tạo đề xuất sẽ sớm ra mắt'), findsOneWidget);
  });
}
