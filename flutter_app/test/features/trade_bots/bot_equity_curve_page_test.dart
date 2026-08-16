import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_equity_curve_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotEquityCurve(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotEquityCurve,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-130 mock repository exposes equity curve BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotEquityCurve();

    expect(snapshot.summary.botReturnPct, 74.5);
    expect(snapshot.summary.buyHoldReturnPct, 62.1);
    expect(snapshot.summary.alphaPct, 12.4);
    expect(snapshot.equityPoints, hasLength(14));
    expect(snapshot.monthlyReturns, hasLength(7));
    expect(snapshot.performanceStats, hasLength(4));
    expect(snapshot.analysisItems, hasLength(3));
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-equity-curve');
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
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
  });

  testWidgets('SC-130 renders equity curve baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotEquityCurve(tester);

    expect(find.byType(BotEquityCurvePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Equity Curve'), findsWidgets);
    expect(find.text('Lợi nhuận Bot'), findsOneWidget);
    expect(find.text('+74.5%'), findsWidgets);
    expect(find.text('Equity Curve vs Buy & Hold'), findsOneWidget);
    expect(find.text('Thống kê hiệu suất'), findsOneWidget);
    expect(find.text('Vượt trội mạnh mẽ'), findsOneWidget);
  });

  testWidgets('SC-130 first viewport reaches equity summary metrics', (
    tester,
  ) async {
    await pumpBotEquityCurve(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotEquityCurvePage',
      semanticLabel: 'Đường cong vốn bot và so sánh với thị trường',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Alpha'),
      minVisibleHeight: 12,
      targetLabel: 'equity alpha summary metric',
      reason:
          'Equity curve should expose the complete compact return summary '
          'above bottom navigation.',
    );
  });

  testWidgets('SC-130 tab controls switch to mock chart variants', (
    tester,
  ) async {
    await pumpBotEquityCurve(tester);

    await tester.tap(find.byKey(BotEquityCurvePage.tabKey('sharpe')));
    await tester.pumpAndSettle();
    expect(find.text('Tỷ lệ Sharpe trượt 30 ngày'), findsOneWidget);
    expect(find.text('Hiện tại'), findsOneWidget);

    await tester.tap(find.byKey(BotEquityCurvePage.tabKey('alpha')));
    await tester.pumpAndSettle();
    expect(
      find.text('Alpha hằng tháng (Bot so với thị trường)'),
      findsOneWidget,
    );
    expect(find.text('Sep 2025'), findsOneWidget);
  });
}
