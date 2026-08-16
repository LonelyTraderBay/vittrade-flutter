import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_multi_chain_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpMultiChain(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnMultiChain,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-367 mock repository exposes multi-chain BE draft', () async {
    final snapshot = await const MockStakingMultiChainRepository()
        .getMultiChain();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-multi-chain');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('multi-chain/rebalance'));
    expect(snapshot.title, 'Multi-Chain Portfolio');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.dashboardRoute, AppRoutePaths.earnDashboard);
    expect(snapshot.positions, hasLength(5));
    expect(snapshot.totalValue, 482150);
    expect(snapshot.quickActions, hasLength(2));
    expect(snapshot.benefits, hasLength(4));
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

  testWidgets('SC-367 renders multi-chain overview baseline', (tester) async {
    await pumpMultiChain(tester);

    expect(find.byType(StakingMultiChainPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Multi-Chain Portfolio'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.infoKey), findsOneWidget);
    expect(find.text('Cross-Chain Staking Hub'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.totalStatsKey), findsOneWidget);
    expect(find.text('\$482,150'), findsOneWidget);
    expect(find.text('+\$156.80'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.allocationKey), findsOneWidget);
    expect(find.text('Chain Allocation'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.positionsKey), findsOneWidget);
    expect(
      find.byKey(StakingMultiChainPage.chainKey(StakingChainId.ethereum)),
      findsOneWidget,
    );
    expect(find.text('Ethereum'), findsWidgets);
  });

  testWidgets('SC-367 manage position opens staking dashboard', (tester) async {
    await pumpMultiChain(tester);

    await tester.tap(
      find.byKey(StakingMultiChainPage.manageKey(StakingChainId.ethereum)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StakingDashboardPage), findsOneWidget);
    expect(find.text('Staking Dashboard'), findsOneWidget);
  });

  testWidgets('SC-367 full content sections are present', (tester) async {
    await pumpMultiChain(tester);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingMultiChainPage.quickActionsKey), findsOneWidget);
    expect(find.text('Rebalance'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.apyComparisonKey), findsOneWidget);
    expect(find.text('APY Comparison'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.benefitsKey), findsOneWidget);
    expect(find.text('Why Multi-Chain?'), findsOneWidget);
    expect(find.byKey(StakingMultiChainPage.technicalNoteKey), findsOneWidget);
  });

  testWidgets('SC-367 header back returns to staking hub', (tester) async {
    await pumpMultiChain(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
