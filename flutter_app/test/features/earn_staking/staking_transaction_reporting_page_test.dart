import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_transaction_reporting_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpReporting(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnTransactionReporting,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-378 mock repository exposes transaction reporting BE draft',
    () async {
      final snapshot = await const MockStakingTransactionReportingRepository()
          .getReporting();

      expect(snapshot.endpoint, '/api/mobile/earn/earn-transaction-reporting');
      expect(snapshot.actionDraft, contains('POST /exports'));
      expect(snapshot.title, 'Tax Reporting');
      expect(snapshot.backRoute, AppRoutePaths.earnStaking);
      expect(snapshot.years, contains('2025'));
      expect(snapshot.defaultCostBasis, 'FIFO');
      expect(snapshot.summary.totalStakingIncome, 5234.56);
      expect(snapshot.summary.rewardsByAsset, hasLength(3));
      expect(snapshot.transactions, hasLength(6));
      expect(snapshot.costBasisMethods, hasLength(4));
      expect(snapshot.taxForms, hasLength(3));
      expect(snapshot.integrations, hasLength(3));
      expect(snapshot.rawDataFormats, hasLength(2));
      expect(snapshot.resources, hasLength(3));
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
    },
  );

  testWidgets('SC-378 renders tax summary baseline', (tester) async {
    await pumpReporting(tester);

    expect(find.byType(StakingTransactionReportingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tax Reporting'), findsOneWidget);
    expect(find.byKey(StakingTransactionReportingPage.infoKey), findsOneWidget);
    expect(find.text('Tax Compliance Made Easy'), findsOneWidget);
    expect(
      find.byKey(StakingTransactionReportingPage.selectorsKey),
      findsOneWidget,
    );
    expect(find.text('Tax Year'), findsOneWidget);
    expect(find.text('FIFO'), findsOneWidget);
    expect(find.byKey(StakingTransactionReportingPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(StakingTransactionReportingPage.summaryKey),
      findsOneWidget,
    );
    expect(find.text('Total Staking Income'), findsOneWidget);
    expect(find.text('\$5,234.56'), findsOneWidget);
    expect(find.text('Total Capital Gains'), findsOneWidget);
    expect(find.text('\$12,345.67'), findsOneWidget);
    expect(find.text('\$100,000.00'), findsOneWidget);
    expect(
      find.byKey(StakingTransactionReportingPage.rewardsKey),
      findsOneWidget,
    );
    expect(find.text('Staking Rewards by Asset'), findsOneWidget);
    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('\$7,000.00'), findsOneWidget);
  });

  testWidgets('SC-378 first viewport reaches reporting selectors', (
    tester,
  ) async {
    await pumpReporting(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-378 StakingTransactionReportingPage',
      semanticLabel: 'Báo cáo giao dịch staking phục vụ khai thuế',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingTransactionReportingPage.selectorsKey),
      routeName: 'SC-378 StakingTransactionReportingPage',
      actionLabel: 'the tax year and cost basis selectors',
    );
  });

  testWidgets('SC-378 cost basis sheet updates method state', (tester) async {
    await pumpReporting(tester);

    await tester.tap(find.text('FIFO').first);
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingTransactionReportingPage.methodSheetKey),
      findsOneWidget,
    );
    expect(find.text('Select Cost Basis Method'), findsOneWidget);
    expect(
      find.byKey(StakingTransactionReportingPage.methodKey('LIFO')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(StakingTransactionReportingPage.methodKey('LIFO')),
    );
    await tester.pumpAndSettle();

    expect(find.text('LIFO'), findsOneWidget);
    expect(find.text('Using LIFO method'), findsOneWidget);
  });

  testWidgets('SC-378 transactions tab renders ledger', (tester) async {
    await pumpReporting(tester);

    await tester.tap(
      find.byKey(StakingTransactionReportingPage.tabKey('transactions')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingTransactionReportingPage.transactionsKey),
      findsOneWidget,
    );
    expect(find.text('All Transactions 2025'), findsOneWidget);
    expect(find.text('Staked 10 ETH'), findsOneWidget);
    expect(find.text('Reward 0.1 ETH'), findsOneWidget);
    expect(find.text('Taxable'), findsWidgets);
    expect(find.text('Cost Basis:'), findsWidgets);
  });

  testWidgets('SC-378 export tab opens export options sheet', (tester) async {
    await pumpReporting(tester);

    await tester.tap(
      find.byKey(StakingTransactionReportingPage.tabKey('export')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingTransactionReportingPage.exportKey),
      findsOneWidget,
    );
    expect(find.text('Generate Tax Forms'), findsOneWidget);
    expect(find.text('IRS Tax Forms (PDF)'), findsOneWidget);
    expect(find.text('Important Tax Notice'), findsOneWidget);
    expect(find.text('IRS Crypto Tax Guide'), findsOneWidget);

    await tester.tap(find.text('IRS Tax Forms (PDF)'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingTransactionReportingPage.exportSheetKey),
      findsOneWidget,
    );
    expect(find.text('Export Options'), findsOneWidget);
    expect(find.text('Form 1099-MISC'), findsOneWidget);
    expect(find.text('TurboTax CSV'), findsOneWidget);
    expect(find.text('JSON'), findsOneWidget);
  });

  testWidgets('SC-378 header back returns to staking hub', (tester) async {
    await pumpReporting(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
