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

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-094 mock repository exposes regulatory reports BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getRegulatoryReportsDashboard();

    expect(snapshot.defaultTab, 'overview');
    expect(snapshot.defaultRange, '7D');
    expect(snapshot.totals.total, 1279);
    expect(snapshot.totals.failed, 24);
    expect(snapshot.totals.successRate.toStringAsFixed(1), '98.1');
    expect(snapshot.dailyStats.map((item) => item.date).first, '03-02');
    expect(snapshot.providers.map((item) => item.name), [
      'REGIS-TR',
      'UnaVista',
      'Bloomberg',
      'DTCC',
    ]);
    expect(snapshot.distribution.map((item) => item.name), [
      'MiFID II',
      'EMIR',
      'SEC',
      'Other',
    ]);
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
  });

  testWidgets('SC-094 renders dashboard inside the Trade shell', (
    tester,
  ) async {
    await pumpDashboard(tester);

    expect(find.byType(RegulatoryReportsDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Regulatory Reports'), findsOneWidget);
    expect(find.text('Dashboard - MiFID II - EMIR'), findsOneWidget);
    expect(find.text('100% SLA Compliance (Last 7 Days)'), findsOneWidget);
    expect(find.text('Total Reports'), findsOneWidget);
    expect(find.text('Submission Trend (Last 7 Days)'), findsOneWidget);
    expect(find.text('ARM Provider Performance'), findsOneWidget);
  });

  testWidgets('SC-094 first viewport reaches KPI summary', (tester) async {
    await pumpDashboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'RegulatoryReportsDashboardPage',
      semanticLabel: 'Bảng báo cáo tuân thủ quy định',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(RegulatoryReportsDashboardPage.kpiGridKey),
      minVisibleHeight: 24,
      targetLabel: 'regulatory report KPI grid',
      reason:
          'Regulatory reports dashboard must expose report KPI content above '
          'bottom navigation after the compliance alert.',
    );
  });

  testWidgets('SC-094 switches range and local tabs', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(RegulatoryReportsDashboardPage.rangeKey('30D').asFinder());
    await tester.pumpAndSettle();

    await tester.tap(
      RegulatoryReportsDashboardPage.tabKey('compliance').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Compliance Metrics'), findsOneWidget);
    expect(find.text('Field Accuracy (RTS 22)'), findsOneWidget);

    await tester.tap(
      RegulatoryReportsDashboardPage.tabKey('exports').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Export Reports'), findsOneWidget);
    expect(find.text('Xuất ISO 20022 XML'), findsOneWidget);

    await tester.tap(RegulatoryReportsDashboardPage.tabKey('queue').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Submission Queue Summary'), findsOneWidget);
  });

  testWidgets('SC-094 quick actions navigate to real queue and ARM status', (
    tester,
  ) async {
    await pumpDashboard(tester);

    await tester.ensureVisible(
      RegulatoryReportsDashboardPage.actionKey('queue').asFinder(),
    );
    await tester.tap(
      RegulatoryReportsDashboardPage.actionKey('queue').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TransactionReportingPage), findsOneWidget);

    await pumpDashboard(tester);
    await tester.ensureVisible(
      RegulatoryReportsDashboardPage.actionKey('arm-status').asFinder(),
    );
    await tester.tap(
      RegulatoryReportsDashboardPage.actionKey('arm-status').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ArmIntegrationStatusPage), findsOneWidget);
    expect(find.text('ARM Integration'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
