import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_liquid_staking_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpLiquidStaking(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnLiquidStaking,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-364 mock repository exposes liquid staking BE draft', () async {
    final snapshot = await const MockStakingLiquidStakingRepository()
        .getLiquidStaking();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-liquid-staking');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('liquid-swap'));
    expect(snapshot.title, 'Liquid Staking');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.tokens, hasLength(3));
    expect(snapshot.tokens.first.symbol, 'stETH');
    expect(snapshot.tokens[1].protocol, 'Rocket Pool');
    expect(snapshot.slippageTolerance, 0.3);
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

  testWidgets('SC-364 renders liquid staking baseline', (tester) async {
    await pumpLiquidStaking(tester);

    expect(find.byType(StakingLiquidStakingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Liquid Staking'), findsOneWidget);
    expect(find.byKey(StakingLiquidStakingPage.infoKey), findsOneWidget);
    expect(find.text('Về Liquid Staking'), findsOneWidget);
    expect(find.byKey(StakingLiquidStakingPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(StakingLiquidStakingPage.tokenKey('steth')),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingLiquidStakingPage.tokenKey('reth')),
      findsOneWidget,
    );
    expect(find.text('4.2%'), findsOneWidget);
    expect(find.text('\$26.6B'), findsOneWidget);
  });

  testWidgets('SC-364 token detail sheet opens from card', (tester) async {
    await pumpLiquidStaking(tester);

    await tester.tap(
      find.byKey(StakingLiquidStakingPage.detailButtonKey('steth')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingLiquidStakingPage.detailSheetKey), findsOneWidget);
    expect(find.text('Lido Staked ETH'), findsOneWidget);
    expect(find.text('Exchange Rate'), findsOneWidget);
    expect(find.text('Smart contract risk'), findsOneWidget);
  });

  testWidgets('SC-364 swap tab previews rate and minimum receive', (
    tester,
  ) async {
    await pumpLiquidStaking(tester);

    await tester.tap(find.byKey(StakingLiquidStakingPage.tabKey('swap')));
    await tester.pumpAndSettle();
    expect(find.byKey(StakingLiquidStakingPage.swapCardKey), findsOneWidget);

    await tester.enterText(
      find.byKey(StakingLiquidStakingPage.swapAmountKey),
      '1.25',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingLiquidStakingPage.swapSummaryKey), findsOneWidget);
    expect(find.text('1 stETH = 1.002 ETH'), findsOneWidget);
    expect(find.text('1.248742 ETH'), findsOneWidget);
    expect(find.text('~\$2.50'), findsOneWidget);
  });

  testWidgets('SC-364 holdings empty state returns to stake tab', (
    tester,
  ) async {
    await pumpLiquidStaking(tester);

    await tester.tap(find.byKey(StakingLiquidStakingPage.tabKey('holdings')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingLiquidStakingPage.holdingsKey), findsOneWidget);
    expect(find.byKey(StakingLiquidStakingPage.emptyKey), findsOneWidget);
    expect(find.text('Bạn chưa có liquid token nào'), findsOneWidget);

    await tester.tap(find.text('Stake ngay'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingLiquidStakingPage.tokenKey('steth')),
      findsOneWidget,
    );
  });

  testWidgets('SC-364 header back returns to staking hub', (tester) async {
    await pumpLiquidStaking(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
