import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_performance_analytics_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotPerformanceAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotPerformanceAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-124 mock repository exposes performance analytics BE draft',
    () async {
      final snapshot = await const MockTradeBotsRepository(
        loadDelay: Duration.zero,
      ).getBotPerformanceAnalytics();

      expect(snapshot.pnlPoints, hasLength(8));
      expect(snapshot.winLossPoints, hasLength(4));
      expect(snapshot.strategyPerformance, hasLength(3));
      expect(snapshot.durationDistribution, hasLength(4));
      expect(snapshot.metrics.totalPnl, 199.30);
      expect(snapshot.pnlPoints.first.date, '01/03');
      expect(snapshot.winLossPoints.first.week, 'Tuần 1');
      expect(
        snapshot.endpoint,
        '/api/mobile/trade/trade-bots-performance-analytics',
      );
      expect(snapshot.actionDraft, contains('POST /bots/create'));
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

  testWidgets('SC-124 renders performance analytics baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotPerformanceAnalytics(tester);

    expect(find.byType(BotPerformanceAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích hiệu suất'), findsOneWidget);
    // Default tab is 7 ngày → period PnL (199.3 - 58.9).
    expect(find.text(r'+$140.40'), findsWidgets);
    expect(find.text('Lãi/lỗ luỹ kế'), findsOneWidget);
    expect(find.text('Phân bố thắng/thua'), findsOneWidget);
    expect(find.text('Hiệu suất theo chiến lược'), findsOneWidget);
    expect(find.text('Lệnh tệ nhất'), findsOneWidget);
    expect(find.text('Xem lịch sử lệnh'), findsOneWidget);
    expect(find.text('Khung thời gian'), findsNothing);
    expect(find.text('Tổng quan'), findsNothing);
    expect(find.textContaining('USDT'), findsNothing);
  });

  testWidgets('SC-124 first viewport reaches cumulative PnL chart', (
    tester,
  ) async {
    await pumpBotPerformanceAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotPerformanceAnalyticsPage',
      semanticLabel: 'Phân tích hiệu suất bot theo khung thời gian',
    );
    await tester.ensureVisible(
      find.byKey(BotPerformanceAnalyticsPage.pnlChartKey),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(BotPerformanceAnalyticsPage.pnlChartKey), findsOneWidget);
  });

  testWidgets('SC-124 timeframe tabs change visible period PnL', (
    tester,
  ) async {
    await pumpBotPerformanceAnalytics(tester);

    expect(find.text(r'+$140.40'), findsWidgets);

    await tester.tap(
      find.byKey(BotPerformanceAnalyticsPage.timeframeKey('all')),
    );
    await tester.pumpAndSettle();

    expect(find.text(r'+$199.30'), findsWidgets);
    expect(find.textContaining('Toàn thời gian'), findsWidgets);
  });

  testWidgets('SC-124 history CTA opens bot history', (tester) async {
    await pumpBotPerformanceAnalytics(tester);

    await tester.ensureVisible(
      find.byKey(BotPerformanceAnalyticsPage.historyCtaKey),
    );
    await tester.tap(find.byKey(BotPerformanceAnalyticsPage.historyCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(BotHistoryPage), findsOneWidget);
  });
}
