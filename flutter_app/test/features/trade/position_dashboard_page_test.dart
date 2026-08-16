import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/position_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPositions(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradePositions,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-053 mock repository exposes position dashboard BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getTradePositions();

    expect(snapshot.trade.pair.symbol, 'BTC/USDT');
    expect(snapshot.positions, hasLength(6));
    expect(
      snapshot.positions.where((p) => p.type == TradePositionType.spot),
      hasLength(3),
    );
    expect(
      snapshot.positions.where((p) => p.type == TradePositionType.futures),
      hasLength(2),
    );
    expect(
      snapshot.positions.where((p) => p.type == TradePositionType.margin),
      hasLength(1),
    );
    expect(snapshot.positions.first.symbol, 'BTC/USDT');
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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

  testWidgets('SC-053 renders positions inside the Trade shell', (
    tester,
  ) async {
    await pumpPositions(tester);

    expect(find.byType(PositionDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Vị thế đang mở'), findsOneWidget);
    expect(find.text('Tổng P/L'), findsOneWidget);
    expect(find.text('+\$210.57'), findsOneWidget);
    expect(find.text('Tất cả (6)'), findsOneWidget);
    expect(find.text('ETH/USDT'), findsWidgets);
    expect(find.text('SOL/USDT'), findsWidgets);
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('SHORT 5x'), findsOneWidget);
  });

  testWidgets('SC-053 first viewport reaches the first position row', (
    tester,
  ) async {
    await pumpPositions(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-053 PositionDashboardPage',
      semanticLabel: 'Vị thế đang mở',
    );
    expectFirstViewportVisible(
      tester,
      find.text('ETH/USDT'),
      targetLabel: 'the first open position row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-053 filters by position type and changes sort mode', (
    tester,
  ) async {
    await pumpPositions(tester);

    await tester.tap(find.byKey(PositionDashboardPage.tabKey('futures')));
    await tester.pumpAndSettle();

    expect(find.text('SHORT 5x'), findsOneWidget);
    expect(find.text('LONG 10x'), findsOneWidget);
    expect(find.text('LONG 3x'), findsNothing);

    await tester.tap(find.byKey(PositionDashboardPage.sortKey('size')));
    await tester.pumpAndSettle();

    expect(find.byType(PositionDashboardPage), findsOneWidget);
  });
}
