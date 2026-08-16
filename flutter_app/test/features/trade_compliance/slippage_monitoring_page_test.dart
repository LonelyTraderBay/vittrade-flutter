import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/slippage_monitoring_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSlippageMonitoring(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopySlippageMonitoring,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-098 mock repository exposes slippage monitoring BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getSlippageMonitoring();

    expect(snapshot.defaultTab, 'realtime');
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
    expect(snapshot.summary.total, 5);
    expect(snapshot.summary.normal, 3);
    expect(snapshot.summary.warning, 1);
    expect(snapshot.summary.critical, 1);
    expect(snapshot.summary.avgSlippage.toStringAsFixed(1), '40.5');
    expect(snapshot.summary.maxSlippage.toStringAsFixed(1), '117.6');
    expect(snapshot.events.map((event) => event.instrument), [
      'BTC/USDT',
      'ETH/USDT',
      'SOL/USDT',
      'BTC/USDT',
      'BTC/USDT',
    ]);
    expect(snapshot.providers.map((provider) => provider.provider), [
      'AlphaTrader',
      'BetaTrader',
      'GammaTrader',
    ]);
    expect(snapshot.history.first.date, '03-02');
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

  testWidgets('SC-098 renders slippage monitoring inside Trade shell', (
    tester,
  ) async {
    await pumpSlippageMonitoring(tester);

    expect(find.byType(SlippageMonitoringPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Slippage Monitoring'), findsOneWidget);
    expect(find.text('Real-time Tracking · Alerts'), findsOneWidget);
    expect(find.text('1 Critical Slippage Event Detected'), findsOneWidget);
    expect(find.text('Recent Slippage Events'), findsOneWidget);
    expect(
      find.byKey(SlippageMonitoringPage.eventKey('slip-1')),
      findsOneWidget,
    );
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('ETH/USDT'), findsOneWidget);
  });

  testWidgets('SC-098 first viewport reaches first slippage event', (
    tester,
  ) async {
    await pumpSlippageMonitoring(tester);

    expectFirstViewportVisible(
      tester,
      find.byKey(SlippageMonitoringPage.eventKey('slip-1')),
      targetLabel: 'first slippage event',
    );
  });

  testWidgets('SC-098 switches provider, history, and alert tabs', (
    tester,
  ) async {
    await pumpSlippageMonitoring(tester);

    await tester.tap(SlippageMonitoringPage.tabKey('providers').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Provider Performance'), findsOneWidget);
    expect(find.text('AlphaTrader'), findsOneWidget);
    expect(find.text('45.2 bps'), findsOneWidget);

    await tester.tap(SlippageMonitoringPage.tabKey('history').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Slippage Trends (Last 7 Days)'), findsOneWidget);
    expect(find.text('03-08'), findsOneWidget);

    await tester.tap(SlippageMonitoringPage.tabKey('alerts').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Alert Configuration'), findsOneWidget);
    expect(find.text('Critical Slippage Alert'), findsOneWidget);
    expect(find.text('Daily Summary Email'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
