import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_analytics_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_trading_demo_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/margin/margin_trading_hub_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/live_market_data_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMarginHub(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeMarginHub,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-090 mock repository exposes margin hub BE draft', () async {
    final snapshot = await const MockTradeRepository(
      loadDelay: Duration.zero,
    ).getMarginTradingHub();

    expect(snapshot.stats, hasLength(2));
    expect(snapshot.stats.map((item) => item.value), ['4', '\$6,080']);
    expect(snapshot.menuItems.map((item) => item.targetPath), [
      AppRoutePaths.tradeMargin,
      AppRoutePaths.tradeMarginAdvancedDemo,
      '/trade/margin/live-market-data-analytics',
      '/trade/margin/advanced-analytics',
    ]);
    expect(snapshot.menuItems.map((item) => item.badge), [
      'LIVE',
      null,
      null,
      null,
    ]);
    expect(snapshot.features.map((item) => item.id), [
      'safety',
      'controls',
      'analytics',
    ]);
    expect(snapshot.compliance.regulations, [
      'MiFID II',
      'ESMA',
      'FCA (UK)',
      'MAS (SG)',
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

  testWidgets('SC-090 renders the margin hub inside the Trade shell', (
    tester,
  ) async {
    await pumpMarginHub(tester);

    expect(find.byType(MarginTradingHubPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hub ký quỹ'), findsOneWidget);
    expect(find.text('Công cụ · Tuân thủ'), findsOneWidget);
    expect(find.text('Bộ công cụ ký quỹ'), findsOneWidget);
    expect(find.text('Vị thế đang mở'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Ký quỹ đang dùng'), findsOneWidget);
    expect(find.text('\$6,080'), findsOneWidget);
    expect(find.text('Market Analytics'), findsOneWidget);
    expect(find.text('Regulatory & Safety'), findsOneWidget);
  });

  testWidgets('SC-090 first viewport reaches first margin action', (
    tester,
  ) async {
    await pumpMarginHub(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-090 MarginTradingHubPage',
      semanticLabel: 'Trung tâm giao dịch ký quỹ',
    );
    expectFirstViewportVisible(
      tester,
      MarginTradingHubPage.menuKey('margin').asFinder(),
      targetLabel: 'the first margin hub action',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-090 menu edges use real routes and placeholders safely', (
    tester,
  ) async {
    await pumpMarginHub(tester);

    await tester.tap(
      MarginTradingHubPage.menuKey('advanced-controls').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AdvancedTradingDemoPage), findsOneWidget);

    await pumpMarginHub(tester);
    await tester.tap(
      MarginTradingHubPage.menuKey('market-analytics').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LiveMarketDataAnalyticsPage), findsOneWidget);
    expect(find.text('Phân tích trực tiếp'), findsOneWidget);

    await pumpMarginHub(tester);
    await tester.ensureVisible(
      MarginTradingHubPage.menuKey('ai-advanced').asFinder(),
    );
    await tester.tap(MarginTradingHubPage.menuKey('ai-advanced').asFinder());
    await tester.pumpAndSettle();
    expect(find.byType(AdvancedAnalyticsPage), findsOneWidget);
    expect(find.text('Phân tích nâng cao'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
