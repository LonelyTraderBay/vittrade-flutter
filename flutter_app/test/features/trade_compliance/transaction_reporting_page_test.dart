import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/client_money/arm_integration_status_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/hub/regulatory_reports_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/transaction_reporting_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTransactionReporting(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyTransactionReporting,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-093 mock repository exposes transaction reporting BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getTransactionReporting();

      expect(snapshot.defaultTab, 'queue');
      expect(snapshot.stats.total, 5);
      expect(snapshot.stats.pending, 3);
      expect(snapshot.stats.failed, 1);
      expect(snapshot.stats.totalValue, 205025);
      expect(snapshot.reports.map((item) => item.id), [
        'RPT-001',
        'RPT-002',
        'RPT-003',
        'RPT-004',
        'RPT-005',
      ]);
      expect(snapshot.reportsForTab('queue').length, 3);
      expect(
        snapshot.reportsForTab('failed').single.errorMessage,
        contains('LEI'),
      );
      expect(
        snapshot.supportedStates,
        containsAll([
          TradeScreenState.loading,
          TradeScreenState.empty,
          TradeScreenState.error,
          TradeScreenState.offline,
          TradeScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-093 renders transaction reporting inside the Trade shell', (
    tester,
  ) async {
    await pumpTransactionReporting(tester);

    expect(find.byType(TransactionReportingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Transaction Reporting'), findsOneWidget);
    expect(find.text('MiFID II - EMIR Compliance'), findsOneWidget);
    expect(find.text('MiFID II Article 26 Compliance'), findsOneWidget);
    expect(find.text('Total Today'), findsOneWidget);
    expect(find.text('Queue (3)'), findsOneWidget);
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('BTC-PERP'), findsOneWidget);
  });

  testWidgets('SC-093 filters reports and switches tabs', (tester) async {
    await pumpTransactionReporting(tester);

    await tester.enterText(
      find.byKey(TransactionReportingPage.searchKey),
      'ETH',
    );
    await tester.pumpAndSettle();
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('BTC-PERP'), findsNothing);

    await tester.enterText(find.byKey(TransactionReportingPage.searchKey), '');
    await tester.tap(TransactionReportingPage.tabKey('failed').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('SOL/USDT'), findsOneWidget);
    expect(
      find.text('Field validation error: Invalid LEI format'),
      findsOneWidget,
    );

    await tester.tap(TransactionReportingPage.tabKey('stats').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Reporting Statistics'), findsOneWidget);
    expect(find.text("Today's Volume"), findsOneWidget);
    expect(find.text('ARM Providers'), findsOneWidget);
  });

  testWidgets('SC-093 quick actions navigate to scoped reporting screens', (
    tester,
  ) async {
    await pumpTransactionReporting(tester);

    await tester.ensureVisible(
      TransactionReportingPage.actionKey('dashboard').asFinder(),
    );
    await tester.tap(
      TransactionReportingPage.actionKey('dashboard').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RegulatoryReportsDashboardPage), findsOneWidget);
    expect(find.text('Regulatory Reports'), findsOneWidget);

    await pumpTransactionReporting(tester);
    await tester.ensureVisible(
      TransactionReportingPage.actionKey('arm-status').asFinder(),
    );
    await tester.tap(
      TransactionReportingPage.actionKey('arm-status').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ArmIntegrationStatusPage), findsOneWidget);
    expect(find.text('ARM Integration'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
