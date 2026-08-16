import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/backtest/bot_backtesting_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpBotBacktesting(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotBacktesting,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-125 mock repository exposes backtesting BE draft', () async {
    final repo = const MockTradeBotsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getBotBacktesting();
    final result = await repo.runBotBacktest(
      const TradeBotBacktestRequest(
        strategyId: 'grid',
        pair: 'BTC/USDT',
        dateRangeId: '6m',
        initialCapital: 1000,
      ),
    );

    expect(snapshot.strategies, hasLength(4));
    expect(snapshot.pairs, contains('BTC/USDT'));
    expect(snapshot.dateRanges, hasLength(4));
    expect(snapshot.defaultStrategyId, 'grid');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-backtesting');
    expect(snapshot.actionDraft, contains('POST /bots/backtest/run'));
    expect(result.reportId, 'BOT-BACKTEST-125');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-125 renders backtesting config baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotBacktesting(tester);

    expect(find.byType(BotBacktestingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Kiểm thử chiến lược'), findsOneWidget);
    expect(find.text('Chọn chiến lược'), findsOneWidget);
    expect(find.text('Grid Bot'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('6 Months'), findsOneWidget);
    expect(find.text('Chạy kiểm thử chiến lược'), findsOneWidget);
  });

  testWidgets('SC-125 lets users change config and run backtest', (
    tester,
  ) async {
    await pumpBotBacktesting(tester);

    await tester.tap(find.byKey(BotBacktestingPage.strategyKey('dca')));
    await tester.tap(find.byKey(BotBacktestingPage.pairKey('ETH/USDT')));
    await tester.tap(find.byKey(BotBacktestingPage.rangeKey('3m')));
    await tester.enterText(find.byKey(BotBacktestingPage.capitalKey), '2500');
    await tester.tap(find.byKey(BotBacktestingPage.runKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('DCA'), findsWidgets);
    expect(find.textContaining('2500'), findsWidgets);
  });
}
