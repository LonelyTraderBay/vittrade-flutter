import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_chart_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_tools_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_trading_demo_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/copy_trading_card_demo_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/execution_quality_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/live_market_data_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/market_data_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/risk_management_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';

/// Khóa 9 trang công cụ terminal mới port lên tablet (GĐ1.1): route đúng
/// render trang tablet thật, KHÔNG rơi vào TradeTabletUtilityPage.
void main() {
  Future<void> pumpTablet(
    WidgetTester tester, {
    required String initialLocation,
    Size size = const Size(1280, 800),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: initialLocation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-055 renders the advanced chart terminal without page '
      'scroll chrome', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/advanced-chart/btcusdt');

    expect(find.byType(AdvancedChartTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(AdvancedChartTabletPage.buyKey), findsOneWidget);
    expect(find.byKey(AdvancedChartTabletPage.sellKey), findsOneWidget);
    expect(find.byKey(const Key('sc055_tablet_ohlcv')), findsOneWidget);
  });

  testWidgets('SC-060 renders risk management with OCO tab and account '
      'panel', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/risk-management');

    expect(find.byType(RiskManagementTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.text('Lệnh OCO · BTC/USDT · Mua'), findsOneWidget);
    expect(find.text('Số dư tài khoản'), findsOneWidget);

    // Chuyển tab Vị thế → bảng vị thế bảo vệ inline.
    await tester.tap(find.byKey(RiskManagementTabletPage.tabKey('positions')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-061 renders execution quality with reused tab widgets', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/execution-quality');

    expect(find.byType(ExecutionQualityTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(ExecutionQualityTabletPage.statsKey), findsOneWidget);
  });

  testWidgets('SC-062 renders advanced tools with ladder/bulk/shortcut '
      'tabs', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/advanced-tools');

    expect(find.byType(AdvancedToolsTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.text('Thang giá · các bậc đã cấu hình'), findsOneWidget);
    expect(find.byKey(AdvancedToolsTabletPage.ladderSubmitKey), findsOneWidget);

    await tester.tap(find.byKey(AdvancedToolsTabletPage.tabKey('bulk')));
    await tester.pumpAndSettle();
    expect(find.byKey(AdvancedToolsTabletPage.bulkCancelKey), findsOneWidget);
  });

  testWidgets('SC-088 renders the advanced trading demo with position '
      'mode chips', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/margin/advanced-demo');

    expect(find.byType(AdvancedTradingDemoTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.text('Chế độ vị thế'), findsOneWidget);
    expect(
      find.byKey(AdvancedTradingDemoTabletPage.modeKey('one-way')),
      findsOneWidget,
    );
  });

  testWidgets('SC-089 renders market data analytics with hero and funding '
      'panel', (tester) async {
    await pumpTablet(
      tester,
      initialLocation: '/trade/margin/market-data-analytics',
    );

    expect(find.byType(MarketDataAnalyticsTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.text('Funding'), findsOneWidget);
    expect(find.text('Open Interest'), findsOneWidget);

    await tester.tap(
      find.byKey(MarketDataAnalyticsTabletPage.tabKey('sentiment')),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-091 renders live market analytics single-column port', (
    tester,
  ) async {
    await pumpTablet(
      tester,
      initialLocation: '/trade/margin/live-market-data-analytics',
    );

    expect(find.byType(LiveMarketDataAnalyticsTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(
      find.byKey(LiveMarketDataAnalyticsTabletPage.contentKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-092 renders advanced analytics with AI signal list', (
    tester,
  ) async {
    await pumpTablet(
      tester,
      initialLocation: '/trade/margin/advanced-analytics',
    );

    expect(find.byType(AdvancedAnalyticsTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(AdvancedAnalyticsTabletPage.signalsKey), findsOneWidget);
    expect(find.text('Rủi ro danh mục'), findsOneWidget);
  });

  testWidgets('SC-401 renders the copy card demo review dashboard', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/demo/copy-card');

    expect(find.byType(CopyTradingCardDemoTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(CopyTradingCardDemoTabletPage.matrixKey), findsOneWidget);
    expect(find.text('Khuyến nghị'), findsOneWidget);
  });

  testWidgets('Lô 9 pages stay overflow-safe at portrait QA width', (
    tester,
  ) async {
    const locations = [
      '/trade/advanced-chart/btcusdt',
      '/trade/risk-management',
      '/trade/execution-quality',
      '/trade/advanced-tools',
      '/trade/margin/advanced-demo',
      '/trade/margin/market-data-analytics',
      '/trade/margin/live-market-data-analytics',
      '/trade/margin/advanced-analytics',
      '/demo/copy-card',
    ];
    for (final location in locations) {
      await pumpTablet(
        tester,
        initialLocation: location,
        size: const Size(800, 1024),
      );
      expect(tester.takeException(), isNull, reason: 'overflow tại $location');
    }
  });
}
