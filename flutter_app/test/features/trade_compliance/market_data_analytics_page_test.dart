import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/market_data_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMarketAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeMarginMarketDataAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-089 mock repository exposes market analytics BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getMarketDataAnalytics();

    expect(snapshot.selectedPair, 'BTC/USDT');
    expect(snapshot.markPrice, 67543.21);
    expect(snapshot.openInterest.current, 25680000000);
    expect(snapshot.longShortRatio.longPct, 62.5);
    expect(snapshot.topTraders.longPct, 58.3);
    expect(snapshot.fundingRate.nextFundingLabel, '02:00');
    expect(snapshot.defaultTab, 'market');
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

  testWidgets('SC-089 renders market data inside the Trade shell', (
    tester,
  ) async {
    await pumpMarketAnalytics(tester);

    expect(find.byType(MarketDataAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích thị trường'), findsOneWidget);
    expect(find.text('Dữ liệu · Thanh khoản'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('\$67,543.21'), findsOneWidget);
    expect(find.text('Open Interest'), findsOneWidget);
    expect(find.text('Long/Short Ratio'), findsWidgets);
    expect(find.text('Top Traders'), findsOneWidget);
    expect(find.text('Funding Rate'), findsOneWidget);
  });

  testWidgets('SC-089 first viewport reaches market data card', (tester) async {
    await pumpMarketAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'MarketDataAnalyticsPage',
      semanticLabel: 'Phân tích thị trường: dữ liệu và thanh khoản',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Open Interest'),
      minVisibleHeight: 18,
      targetLabel: 'first market data card',
      reason:
          'Market analytics must show the first data card above bottom '
          'navigation after the pair selector, risk review, and tabs.',
    );
  });

  testWidgets('SC-089 local tabs switch to liquidations and sentiment', (
    tester,
  ) async {
    await pumpMarketAnalytics(tester);

    await tester.tap(MarketDataAnalyticsPage.tabKey('liquidations').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Liquidation Stats'), findsOneWidget);
    expect(find.text('Liquidation Heatmap'), findsOneWidget);
    expect(find.text('Recent Liquidations'), findsOneWidget);

    await tester.tap(MarketDataAnalyticsPage.tabKey('sentiment').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Market Sentiment'), findsOneWidget);
    expect(find.text('How Sentiment is Calculated'), findsOneWidget);
    expect(find.text('Trading Implications'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
