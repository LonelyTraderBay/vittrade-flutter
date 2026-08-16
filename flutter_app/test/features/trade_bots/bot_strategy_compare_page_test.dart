import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/backtest/bot_strategy_compare_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotStrategyCompare(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotStrategyCompare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-126 mock repository exposes strategy compare BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotStrategyCompare();

    expect(snapshot.strategies, hasLength(4));
    expect(snapshot.equityPoints, hasLength(7));
    expect(snapshot.recommendations, hasLength(4));
    expect(snapshot.defaultSelectedIds, ['grid', 'momentum']);
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-strategy-compare');
    expect(snapshot.actionDraft, contains('GET /bots/strategy-compare'));
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
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

  testWidgets('SC-126 renders strategy compare baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotStrategyCompare(tester);

    expect(find.byType(BotStrategyComparePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('So sánh chiến lược'), findsOneWidget);
    expect(find.text('Chọn chiến lược (2-4)'), findsOneWidget);
    expect(
      find.text('Lợi nhuận điều chỉnh theo rủi ro tốt nhất'),
      findsOneWidget,
    );
    expect(find.text('So sánh đường cong vốn'), findsOneWidget);
    expect(find.text('Biểu đồ radar hiệu suất'), findsOneWidget);
  });

  testWidgets('SC-126 first viewport reaches best strategy card', (
    tester,
  ) async {
    await pumpBotStrategyCompare(tester);

    expectFirstViewportVisible(
      tester,
      find.text('Lợi nhuận điều chỉnh theo rủi ro tốt nhất'),
      targetLabel: 'the best strategy summary',
    );
  });

  testWidgets('SC-126 marks signed max drawdown closest to zero as best', (
    tester,
  ) async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotStrategyCompare();
    Color colorOf(String id) => Color(
      snapshot.strategies.firstWhere((strategy) => strategy.id == id).colorHex,
    );

    await pumpBotStrategyCompare(tester);

    Text textOf(String value) => tester.widget<Text>(find.text(value));

    // Default selection Grid (-12.1%) vs Momentum (-15.3%): the drawdown
    // closest to zero wins, not the numerically smallest one.
    expect(textOf('-12.1%').style?.color, colorOf('grid'));
    expect(textOf('-15.3%').style?.color, AppColors.text1);

    // Adding DCA (-8.4%) hands best-in-group over to it.
    await tester.tap(find.byKey(BotStrategyComparePage.strategyKey('dca')));
    await tester.pumpAndSettle();

    expect(textOf('-8.4%').style?.color, colorOf('dca'));
    expect(textOf('-12.1%').style?.color, AppColors.text1);
    // Volatility stays lowest-wins: DCA 12.4% is the best of the three.
    expect(textOf('12.4%').style?.color, colorOf('dca'));
  });

  testWidgets('SC-126 lets users toggle strategy selection', (tester) async {
    await pumpBotStrategyCompare(tester);

    await tester.tap(find.byKey(BotStrategyComparePage.strategyKey('dca')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotStrategyComparePage.strategyKey('grid')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('DCA Bot'), findsWidgets);
    expect(find.text('Momentum Bot'), findsWidgets);
  });
}
