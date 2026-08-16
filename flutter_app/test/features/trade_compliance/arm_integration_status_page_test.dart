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
  Future<void> pumpArmStatus(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyArmIntegrationStatus,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-095 mock repository exposes ARM integration BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getArmIntegrationStatus();

    expect(snapshot.connections.map((item) => item.provider), [
      'REGIS-TR',
      'UnaVista',
      'Bloomberg',
    ]);
    expect(snapshot.connections.first.isPrimary, isTrue);
    expect(snapshot.connections.last.status, 'degraded');
    expect(snapshot.latencyHistory.map((item) => item.time), [
      '10:30',
      '10:35',
      '10:40',
      '10:45',
    ]);
    expect(snapshot.sla.uptime, 99.97);
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

  testWidgets('SC-095 renders ARM status inside the Trade shell', (
    tester,
  ) async {
    await pumpArmStatus(tester);

    expect(find.byType(ArmIntegrationStatusPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('ARM Integration'), findsOneWidget);
    expect(find.text('Connection Health · Monitoring'), findsOneWidget);
    expect(find.text('All Systems Operational'), findsOneWidget);
    expect(find.text('ARM Providers'), findsOneWidget);
    expect(find.text('REGIS-TR'), findsWidgets);
    expect(find.text('Latency Monitoring (Last 15 min)'), findsOneWidget);
  });

  testWidgets('SC-095 first viewport reaches first ARM provider', (
    tester,
  ) async {
    await pumpArmStatus(tester);

    expectActionableInFirstViewport(
      tester,
      ArmIntegrationStatusPage.connectionKey('arm-1').asFinder(),
      routeName: 'ArmIntegrationStatusPage',
      actionLabel: 'first ARM provider card',
    );
  });

  testWidgets('SC-095 test connection toggles local testing state', (
    tester,
  ) async {
    await pumpArmStatus(tester);

    await tester.tap(ArmIntegrationStatusPage.testKey('arm-1').asFinder());
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Testing...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Test Connection'), findsWidgets);
  });

  testWidgets('SC-095 quick actions navigate to real copy reporting screens', (
    tester,
  ) async {
    await pumpArmStatus(tester);

    await tester.ensureVisible(
      ArmIntegrationStatusPage.actionKey('queue').asFinder(),
    );
    await tester.tap(ArmIntegrationStatusPage.actionKey('queue').asFinder());
    await tester.pumpAndSettle();
    expect(find.byType(TransactionReportingPage), findsOneWidget);

    await pumpArmStatus(tester);
    await tester.ensureVisible(
      ArmIntegrationStatusPage.actionKey('dashboard').asFinder(),
    );
    await tester.tap(
      ArmIntegrationStatusPage.actionKey('dashboard').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RegulatoryReportsDashboardPage), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
