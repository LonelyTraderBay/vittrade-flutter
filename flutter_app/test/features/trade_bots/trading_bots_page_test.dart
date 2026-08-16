import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/hub/trading_bots_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTradingBots(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.tradeBots,
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-059 mock repository exposes trading bot BE draft', () async {
    final repo = const MockTradeBotsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getTradingBots();
    final action = await repo.submitBotAction(
      const TradeBotActionRequest(botId: 'bot1', action: 'pause'),
    );
    final created = await repo.createTradingBot(
      const TradeBotCreateRequest(
        strategyId: 'dca',
        params: {'pair': 'BTC/USDT'},
      ),
    );

    expect(snapshot.activeBots, hasLength(3));
    expect(snapshot.strategies, hasLength(4));
    expect(snapshot.runningCount, 2);
    expect(snapshot.totalInvestment, 2000);
    expect(snapshot.totalProfit.toStringAsFixed(2), '199.30');
    expect(snapshot.strategies.first.name, 'DCA Bot');
    expect(snapshot.activeBots.first.pair, 'BTC/USDT');
    expect(action.status, 'accepted');
    expect(created.botId, 'BOT-DEMO-059');
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

  testWidgets('SC-059 renders TradingBotsPage inside the Trade shell', (
    tester,
  ) async {
    await pumpTradingBots(tester);

    expect(find.byType(TradingBotsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bot giao dịch'), findsOneWidget);
    expect(find.text('Tự động hóa giao dịch theo chiến lược'), findsOneWidget);
    expect(find.text('Khám phá chiến lược'), findsOneWidget);
    expect(find.text('Lãi/lỗ'), findsOneWidget);
    expect(find.text('+\$199.30'), findsOneWidget);
    expect(find.text('Bot của tôi (3)'), findsOneWidget);
    expect(find.text('Công cụ'), findsOneWidget);
    expect(find.byKey(TradingBotsPage.toolsKey), findsOneWidget);
    expect(find.text('Dừng khẩn cấp'), findsOneWidget);
    expect(find.text('DCA Bot'), findsOneWidget);
    expect(find.text('Grid Bot'), findsOneWidget);
    expect(find.text('Momentum Bot'), findsOneWidget);
  });

  testWidgets('SC-320 uses full-width bot workspace at 360x800', (
    tester,
  ) async {
    await pumpTradingBots(tester, viewport: const Size(360, 800));

    expect(find.byType(TradingBotsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(TradingBotsPage.contentKey), findsOneWidget);
    expect(find.byKey(TradingBotsPage.backKey), findsOneWidget);
    expect(find.byKey(TradingBotsPage.tabKey('mybots')), findsOneWidget);

    final contentRect = tester.getRect(find.byKey(TradingBotsPage.contentKey));
    final backRect = tester.getRect(find.byKey(TradingBotsPage.backKey));

    expect(contentRect.left, closeTo(0, 0.5));
    expect(contentRect.right, closeTo(360, 0.5));
    expect(contentRect.height, greaterThan(560));
    expect(backRect.left, greaterThanOrEqualTo(0));

    await tester.ensureVisible(find.byKey(TradingBotsPage.addBotKey));
    await tester.pumpAndSettle();

    final addBotRect = tester.getRect(find.byKey(TradingBotsPage.addBotKey));
    expect(addBotRect.bottom, lessThanOrEqualTo(800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-059 bot actions stay local', (tester) async {
    await pumpTradingBots(tester);

    await tester.ensureVisible(
      find.byKey(TradingBotsPage.botToggleKey('bot1')),
    );
    await tester.tap(find.byKey(TradingBotsPage.botToggleKey('bot1')));
    await tester.pumpAndSettle();
    expect(find.text('Tiếp tục'), findsNWidgets(2));

    await tester.ensureVisible(
      find.byKey(TradingBotsPage.botSettingsKey('bot2')),
    );
    await tester.tap(find.byKey(TradingBotsPage.botSettingsKey('bot2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradingBotsPage.botDeleteKey('bot2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradingBotsPage.deleteConfirmKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã xóa bot'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();
    expect(find.text('Grid Bot'), findsNothing);
    expect(find.text('Bot của tôi (2)'), findsOneWidget);
  });

  testWidgets('SC-059 strategy tab opens create bot sheet', (tester) async {
    await pumpTradingBots(tester);

    await tester.tap(find.byKey(TradingBotsPage.tabKey('strategies')));
    await tester.pumpAndSettle();

    expect(find.text('Tạo bot'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(TradingBotsPage.strategyCreateKey('dca')),
    );
    await tester.tap(find.byKey(TradingBotsPage.strategyCreateKey('dca')));
    await tester.pumpAndSettle();
    expect(find.text('Đồng ý điều khoản để tiếp tục'), findsOneWidget);
    expect(find.text('Thông số bot'), findsOneWidget);
    expect(find.text('Xem lại trước khi khởi chạy'), findsOneWidget);

    await tester.ensureVisible(find.byKey(TradingBotsPage.sheetAgreeKey));
    await tester.tap(find.byKey(TradingBotsPage.sheetAgreeKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(TradingBotsPage.sheetCreateKey));
    await tester.tap(find.byKey(TradingBotsPage.sheetCreateKey));
    await tester.pumpAndSettle();

    expect(find.text('Bot đã được khởi chạy!'), findsOneWidget);
  });

  testWidgets('SC-059 quick tools navigate to bot child routes', (
    tester,
  ) async {
    await pumpTradingBots(tester);

    await tester.ensureVisible(find.byKey(TradingBotsPage.toolKey('history')));
    await tester.tap(find.byKey(TradingBotsPage.toolKey('history')));
    await tester.pumpAndSettle();

    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
  });

  testWidgets('SC-059 strategy risk filter narrows the catalog', (
    tester,
  ) async {
    await pumpTradingBots(tester);

    await tester.tap(find.byKey(TradingBotsPage.tabKey('strategies')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(TradingBotsPage.riskFilterKey('high')),
    );
    await tester.tap(find.byKey(TradingBotsPage.riskFilterKey('high')));
    await tester.pumpAndSettle();

    expect(find.text('Martingale Bot'), findsOneWidget);
    expect(find.text('DCA Bot'), findsNothing);
  });

  testWidgets('SC-059 bot settings opens security settings', (tester) async {
    await pumpTradingBots(tester);

    await tester.ensureVisible(
      find.byKey(TradingBotsPage.botSettingsKey('bot1')),
    );
    await tester.tap(find.byKey(TradingBotsPage.botSettingsKey('bot1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();

    expect(find.byType(TradingBotsPage), findsNothing);
  });

  testWidgets('SC-059 back returns to SC-048 TradePage', (tester) async {
    await pumpTradingBots(tester);

    await tester.tap(find.byKey(TradingBotsPage.backKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(TradingBotsPage), findsNothing);
  });

  testWidgets('SC-059 scoped bot child routes return to TradingBotsPage', (
    tester,
  ) async {
    await pumpTradingBots(tester, initialLocation: '/trade/bots/history');

    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(TradingBotsPage), findsOneWidget);
  });
}
