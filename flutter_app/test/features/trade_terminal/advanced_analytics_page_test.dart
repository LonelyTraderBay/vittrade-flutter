import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAdvancedAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeMarginAdvancedAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-092 mock repository exposes advanced analytics BE draft', () async {
    final snapshot = await const MockTradeTerminalRepository(
      loadDelay: Duration.zero,
    ).getAdvancedAnalytics();

    expect(snapshot.defaultTab, 'ai');
    expect(snapshot.stats.map((item) => item.value), [
      '3',
      '58',
      '66.7%',
      '1.82',
    ]);
    expect(snapshot.signals.map((item) => item.pair), [
      'BTC/USDT',
      'ETH/USDT',
      'SOL/USDT',
    ]);
    expect(snapshot.risk.riskScore, 58);
    expect(snapshot.journal.winRate, 66.7);
    expect(snapshot.sizing.positionSize, 1.43);
    expect(snapshot.features, contains('AI Trading Signals'));
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

  testWidgets('SC-092 renders advanced analytics inside the Trade shell', (
    tester,
  ) async {
    await pumpAdvancedAnalytics(tester);

    expect(find.byType(AdvancedAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích nâng cao'), findsOneWidget);
    expect(find.text('AI · Rủi ro · Nhật ký'), findsOneWidget);
    expect(find.text('Advanced Analytics'), findsOneWidget);
    expect(find.text('AI Trading Signals'), findsWidgets);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('AI Prediction Disclaimer'), findsOneWidget);
    expect(find.text('Features Included'), findsOneWidget);
  });

  testWidgets('SC-092 first viewport reaches first AI signal', (tester) async {
    await pumpAdvancedAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'AdvancedAnalyticsPage',
      semanticLabel: 'Phân tích nâng cao',
    );
    expectFirstViewportVisible(
      tester,
      find.text('BTC/USDT'),
      minVisibleHeight: 18,
      targetLabel: 'first AI signal',
      reason:
          'Advanced analytics must show the first AI signal above bottom '
          'navigation after the hero metrics and analytics tabs.',
    );
  });

  testWidgets('SC-092 filters AI signals and switches local tabs', (
    tester,
  ) async {
    await pumpAdvancedAnalytics(tester);

    await tester.tap(AdvancedAnalyticsPage.filterKey('short').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsNothing);

    await tester.tap(AdvancedAnalyticsPage.tabKey('risk').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Portfolio Risk Analyzer'), findsOneWidget);
    expect(find.text('Enterprise Risk Management'), findsOneWidget);

    await tester.tap(AdvancedAnalyticsPage.tabKey('journal').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Trade Journal'), findsWidgets);
    expect(find.text('Performance Attribution'), findsWidgets);

    await tester.tap(AdvancedAnalyticsPage.tabKey('sizing').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Position Sizing Calculator'), findsOneWidget);
    expect(find.text('Kelly Criterion Optimization'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
