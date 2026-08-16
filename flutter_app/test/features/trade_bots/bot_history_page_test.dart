import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-123 mock repository exposes bot history BE draft', () async {
    final repo = const MockTradeBotsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getBotHistory();
    final export = await repo.createBotHistoryExport(
      const TradeBotHistoryExportRequest(format: 'csv'),
    );

    expect(snapshot.trades, hasLength(7));
    expect(
      snapshot.trades.where((trade) => trade.side == TradeBotHistorySide.buy),
      hasLength(4),
    );
    expect(
      snapshot.trades.where((trade) => trade.side == TradeBotHistorySide.sell),
      hasLength(3),
    );
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-history');
    expect(snapshot.actionDraft, contains('POST /bots/create'));
    expect(export.status, 'ready');
    expect(export.downloadUrl, '/exports/BOT-HISTORY-123.csv');
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

  testWidgets('SC-123 renders bot trade history baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotHistory(tester);

    expect(find.byType(BotHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
    expect(find.text('Tổng số giao dịch'), findsOneWidget);
    expect(find.text(r'+$1.50'), findsWidgets);
    expect(find.text('Tất cả (7)'), findsOneWidget);
    expect(find.text('Giao dịch (7)'), findsOneWidget);
    expect(find.text('DCA Bot #1 · DCA'), findsWidgets);
  });

  testWidgets('SC-123 first viewport reaches first trade card', (tester) async {
    await pumpBotHistory(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotHistoryPage',
      semanticLabel: 'Lịch sử giao dịch của bot',
    );
    expectFirstViewportVisible(
      tester,
      find.text('DCA Bot #1 · DCA').first,
      minVisibleHeight: 12,
      targetLabel: 'first bot history trade card',
      reason:
          'Bot history should expose the first concrete trade record above '
          'bottom navigation on the QA phone viewport.',
    );
  });

  testWidgets('SC-123 filters sell trades', (tester) async {
    await pumpBotHistory(tester);

    await tester.tap(find.byKey(BotHistoryPage.filterKey('sell')));
    await tester.pumpAndSettle();

    expect(find.text('Giao dịch (3)'), findsOneWidget);
    expect(find.text('Bán (3)'), findsOneWidget);
  });
}
