import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_proposals_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_voting_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpVoting(
    WidgetTester tester, {
    String initialLocation = '/earn/voting/prop001',
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

  test('SC-390 mock repository exposes voting BE draft', () async {
    final snapshot = await const MockStakingVotingRepository().getVoting(
      proposalId: 'prop001',
    );

    expect(snapshot.endpoint, '/api/mobile/earn/earn-voting-prop001');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Proposal #127');
    expect(snapshot.backRoute, AppRoutePaths.earnProposals);
    expect(snapshot.category, 'Fees');
    expect(snapshot.proposedBy, 'CommunityDAO');
    expect(snapshot.results, hasLength(2));
    expect(snapshot.results.first.label, 'Yes');
    expect(snapshot.results.first.percent, 70);
    expect(snapshot.results.first.votes, 42000);
    expect(snapshot.options.map((option) => option.id), ['yes', 'no']);
    expect(snapshot.votingPower, '12,500 votes');
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

  test('SC-391 base voting route exposes base BE endpoint', () async {
    final snapshot = await const MockStakingVotingRepository().getVoting();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-voting');
  });

  testWidgets('SC-390 renders proposal detail, results, vote cards, and note', (
    tester,
  ) async {
    await pumpVoting(tester);

    expect(find.byType(StakingVotingPage), findsOneWidget);
    expect(find.text('Proposal #127'), findsOneWidget);
    expect(find.byKey(StakingVotingPage.proposalKey), findsOneWidget);
    expect(find.text('Fees'), findsOneWidget);
    expect(find.text('Lower ETH Staking Fees from 1.5% to 1%'), findsOneWidget);
    expect(find.text('CommunityDAO'), findsOneWidget);
    expect(find.byKey(StakingVotingPage.resultsKey), findsOneWidget);
    expect(find.text('Current Results'), findsOneWidget);
    expect(find.text('Yes (70%)'), findsOneWidget);
    expect(find.text('42,000 votes'), findsOneWidget);
    expect(find.text('No (30%)'), findsOneWidget);
    expect(find.text('18,000 votes'), findsOneWidget);
    expect(find.byKey(StakingVotingPage.castVoteKey), findsOneWidget);
    expect(find.text('Cast Your Vote'), findsOneWidget);
    expect(find.byKey(StakingVotingPage.optionKey('yes')), findsOneWidget);
    expect(find.byKey(StakingVotingPage.optionKey('no')), findsOneWidget);
    expect(find.byKey(StakingVotingPage.noteKey), findsOneWidget);

    final submit = tester.widget<VitCtaButton>(
      find.byKey(StakingVotingPage.submitKey),
    );
    expect(submit.onPressed, isNull);
  });

  testWidgets('SC-390 selecting a vote enables submit CTA', (tester) async {
    await pumpVoting(tester);

    await tester.tap(find.byKey(StakingVotingPage.optionKey('yes')));
    await tester.pumpAndSettle();

    final submit = tester.widget<VitCtaButton>(
      find.byKey(StakingVotingPage.submitKey),
    );
    expect(submit.onPressed, isNotNull);

    await tester.tap(find.byKey(StakingVotingPage.optionKey('no')));
    await tester.pumpAndSettle();

    final updatedSubmit = tester.widget<VitCtaButton>(
      find.byKey(StakingVotingPage.submitKey),
    );
    expect(updatedSubmit.onPressed, isNotNull);
  });

  testWidgets('SC-391 renders base voting route and supports vote state', (
    tester,
  ) async {
    await pumpVoting(tester, initialLocation: AppRoutePaths.earnVoting);

    expect(find.byType(StakingVotingPage), findsOneWidget);
    expect(find.text('Proposal #127'), findsOneWidget);
    expect(find.byKey(StakingVotingPage.resultsKey), findsOneWidget);

    final disabledSubmit = tester.widget<VitCtaButton>(
      find.byKey(StakingVotingPage.submitKey),
    );
    expect(disabledSubmit.onPressed, isNull);

    await tester.tap(find.byKey(StakingVotingPage.optionKey('yes')));
    await tester.pumpAndSettle();

    final enabledSubmit = tester.widget<VitCtaButton>(
      find.byKey(StakingVotingPage.submitKey),
    );
    expect(enabledSubmit.onPressed, isNotNull);
  });

  testWidgets(
    'SC-390 submitting a vote shows acknowledgement and returns to proposals',
    (tester) async {
      await pumpVoting(tester);

      await tester.tap(find.byKey(StakingVotingPage.optionKey('yes')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(StakingVotingPage.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('Đã ghi nhận phiếu bầu'), findsOneWidget);
      expect(
        find.text(
          'Bạn đã bỏ phiếu "Yes" cho đề xuất '
          '"Lower ETH Staking Fees from 1.5% to 1%".',
        ),
        findsOneWidget,
      );
      expect(find.byType(StakingProposalsPage), findsNothing);

      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();

      expect(find.byType(StakingProposalsPage), findsOneWidget);
    },
  );

  testWidgets('SC-390 proposals vote edge opens voting detail', (tester) async {
    await pumpVoting(tester, initialLocation: AppRoutePaths.earnProposals);

    await tester.tap(find.byKey(StakingProposalsPage.proposalKey('prop001')));
    await tester.pumpAndSettle();

    expect(find.byType(StakingVotingPage), findsOneWidget);
    expect(find.text('Proposal #127'), findsOneWidget);
  });

  testWidgets('SC-390 header back returns to proposals', (tester) async {
    await pumpVoting(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingProposalsPage), findsOneWidget);
    expect(find.text('Proposals'), findsOneWidget);
  });
}
