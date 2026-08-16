import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_portfolio_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotPortfolioDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotPortfolioDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-128 mock repository exposes portfolio dashboard BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotPortfolioDashboard();

    expect(snapshot.summary.totalEquity, 3245);
    expect(snapshot.summary.totalPnl, 745);
    expect(snapshot.allocations, hasLength(4));
    expect(snapshot.equityPoints, hasLength(7));
    expect(snapshot.correlations, hasLength(3));
    expect(snapshot.healthItems, hasLength(3));
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-bots-portfolio-dashboard',
    );
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

  testWidgets('SC-128 renders portfolio dashboard baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotPortfolioDashboard(tester);

    expect(find.byType(BotPortfolioDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bảng điều khiển danh mục'), findsOneWidget);
    expect(find.text('Vốn danh mục'), findsOneWidget);
    expect(find.text(r'$3,245'), findsOneWidget);
    expect(find.text('+29.8%'), findsOneWidget);
    expect(find.text('Đường cong vốn danh mục'), findsOneWidget);
    expect(find.text('Chi tiết phân bổ'), findsOneWidget);
    expect(find.text('Ma trận tương quan bot'), findsOneWidget);
    expect(find.text('Portfolio Health: Excellent'), findsOneWidget);
  });

  testWidgets('SC-128 first viewport reaches equity curve section', (
    tester,
  ) async {
    await pumpBotPortfolioDashboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-128 BotPortfolioDashboardPage',
      semanticLabel: 'Bảng điều khiển danh mục bot',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Đường cong vốn danh mục'),
      targetLabel: 'the portfolio equity curve section',
      minVisibleHeight: 12,
    );
  });
}
