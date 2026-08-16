import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_score_calculator_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskCalculator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnRiskScoreCalculator,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-384 mock repository exposes risk calculator BE draft', () async {
    final snapshot = await const MockStakingRiskScoreCalculatorRepository()
        .getCalculator();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-risk-score-calculator');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Risk Calculator');
    expect(snapshot.backRoute, AppRoutePaths.earnRiskDashboard);
    expect(snapshot.defaultAmountUsd, 10000);
    expect(snapshot.defaultAsset, 'ETH');
    expect(snapshot.defaultDuration, 'flexible');
    expect(snapshot.defaultValidators, 3);
    expect(snapshot.assetOptions, hasLength(4));
    expect(snapshot.durationOptions, hasLength(5));
    expect(snapshot.recommendations, hasLength(3));
    expect(snapshot.proceedLabel, 'Proceed with This Configuration');
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

  testWidgets('SC-384 renders risk calculator baseline', (tester) async {
    await pumpRiskCalculator(tester);

    expect(find.byType(StakingRiskScoreCalculatorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Calculator'), findsOneWidget);
    expect(find.byKey(StakingRiskScoreCalculatorPage.formKey), findsOneWidget);
    expect(find.text('Scenario Inputs'), findsOneWidget);
    expect(find.text('Stake Amount (USD)'), findsOneWidget);
    expect(find.text('10000'), findsOneWidget);
    expect(find.text('ETH (Medium Volatility)'), findsOneWidget);
    expect(find.text('Flexible (No lock)'), findsOneWidget);
    expect(find.text('Number of Validators: 3'), findsOneWidget);

    expect(find.byKey(StakingRiskScoreCalculatorPage.scoreKey), findsOneWidget);
    expect(find.text('Calculated Risk Score'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('/ 100'), findsOneWidget);
    expect(find.text('Low Risk'), findsOneWidget);
    expect(find.byKey(StakingRiskScoreCalculatorPage.radarKey), findsOneWidget);
    expect(find.text('Proceed with This Configuration'), findsOneWidget);
    expect(find.byType(VitStickyFooter), findsNothing);
  });

  testWidgets('SC-384 first viewport reaches amount input', (tester) async {
    await pumpRiskCalculator(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-384 StakingRiskScoreCalculatorPage',
      semanticLabel: 'Máy tính điểm rủi ro staking theo kịch bản',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingRiskScoreCalculatorPage.amountFieldKey),
      routeName: 'SC-384 StakingRiskScoreCalculatorPage',
      actionLabel: 'the stake amount input',
    );
  });

  testWidgets('SC-384 recalculates amount-driven state and recommendations', (
    tester,
  ) async {
    await pumpRiskCalculator(tester);

    await tester.enterText(
      find.byKey(StakingRiskScoreCalculatorPage.amountFieldKey),
      '75000',
    );
    await tester.pumpAndSettle();

    expect(find.text('25'), findsOneWidget);
    expect(find.text('Moderate Risk'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingRiskScoreCalculatorPage.recommendationsKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Large Position'), findsOneWidget);
    expect(
      find.text('Consider splitting across multiple products.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-384 updates selected asset and lock duration', (
    tester,
  ) async {
    await pumpRiskCalculator(tester);

    await tester.tap(
      find.byKey(StakingRiskScoreCalculatorPage.assetSelectorKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('SOL (High Volatility)').last);
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(StakingRiskScoreCalculatorPage.durationSelectorKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fixed 180 Days').last);
    await tester.pumpAndSettle();

    expect(find.text('SOL (High Volatility)'), findsOneWidget);
    expect(find.text('Fixed 180 Days'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Moderate Risk'), findsOneWidget);
  });

  testWidgets('SC-384 header back returns to risk dashboard', (tester) async {
    await pumpRiskCalculator(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskDashboardPage), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
  });

  testWidgets('SC-384 proceed CTA shows coming-soon snack bar', (tester) async {
    await pumpRiskCalculator(tester);

    await tester.ensureVisible(
      find.byKey(StakingRiskScoreCalculatorPage.footerButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingRiskScoreCalculatorPage.footerButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tiếp tục sẽ sớm ra mắt'), findsOneWidget);
  });
}
