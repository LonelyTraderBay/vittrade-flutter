import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/live_market_data_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpLiveMarketAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-091 mock repository exposes live market analytics BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getLiveMarketDataAnalytics();

      expect(snapshot.selectedPair, 'BTC/USDT');
      expect(snapshot.openInterest.current, 25433440000);
      expect(snapshot.openInterest.change24hPct, -.96);
      expect(snapshot.longShortRatio.longPct, 61.6);
      expect(snapshot.topTraders.change24h, -.6);
      expect(snapshot.fundingRate.nextFundingLabel, '01:29');
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

  testWidgets('SC-091 renders live market analytics inside the Trade shell', (
    tester,
  ) async {
    await pumpLiveMarketAnalytics(tester);

    expect(find.byType(LiveMarketDataAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích trực tiếp'), findsOneWidget);
    expect(find.text('Dữ liệu realtime'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('WebSocket Active'), findsOneWidget);
    expect(find.text('Open Interest'), findsOneWidget);
    expect(find.text('Long/Short Ratio'), findsWidgets);
  });

  testWidgets('SC-091 local tabs switch to live liquidations and sentiment', (
    tester,
  ) async {
    await pumpLiveMarketAnalytics(tester);

    await tester.tap(
      LiveMarketDataAnalyticsPage.tabKey('liquidations').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Liquidation Stats'), findsOneWidget);
    expect(find.text('Recent Liquidations'), findsOneWidget);

    await tester.tap(
      LiveMarketDataAnalyticsPage.tabKey('sentiment').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Market Sentiment'), findsOneWidget);
    expect(find.text('Live Data Sources'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
