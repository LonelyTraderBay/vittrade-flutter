import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_trading_demo_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAdvancedDemo(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeMarginAdvancedDemo,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-088 mock repository exposes advanced demo BE draft', () async {
    final snapshot = await const MockTradeTerminalRepository(
      loadDelay: Duration.zero,
    ).getAdvancedTradingDemo();

    expect(snapshot.position.pair, 'BTC/USDT');
    expect(snapshot.position.currentPnl, 1250);
    expect(snapshot.defaultTab, 'position');
    expect(snapshot.defaultPositionMode, 'one-way');
    expect(snapshot.positionActions, hasLength(4));
    expect(snapshot.orderTypes, hasLength(4));
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

  testWidgets('SC-088 renders the position demo inside the Trade shell', (
    tester,
  ) async {
    await pumpAdvancedDemo(tester);

    expect(find.byType(AdvancedTradingDemoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Giao dịch nâng cao'), findsOneWidget);
    expect(find.text('Quản lý vị thế'), findsOneWidget);
    expect(find.text('Mock Position (Demo)'), findsOneWidget);
    expect(find.text('BTC/USDT · LONG'), findsOneWidget);
  });

  testWidgets('SC-088 first viewport reaches first position action', (
    tester,
  ) async {
    await pumpAdvancedDemo(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'AdvancedTradingDemoPage',
      semanticLabel: 'Giao dịch nâng cao',
    );
    expectFirstViewportVisible(
      tester,
      AdvancedTradingDemoPage.actionKey('partial-close').asFinder(),
      minVisibleHeight: 24,
      targetLabel: 'first advanced position action',
      reason:
          'Advanced trading demo must expose the first position action above '
          'bottom navigation after mode and tab controls.',
    );
  });

  testWidgets('SC-088 local tabs and demo controls update', (tester) async {
    await pumpAdvancedDemo(tester);

    await tester.tap(AdvancedTradingDemoPage.modeKey('hedge').asFinder());
    await tester.pumpAndSettle();
    expect(find.textContaining('phòng hộ'), findsOneWidget);

    await tester.tap(
      AdvancedTradingDemoPage.actionKey('partial-close').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Partial Close Position (25%/50%/75%/100%)'),
      findsWidgets,
    );
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();

    await tester.tap(AdvancedTradingDemoPage.tabKey('orders').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.text('LIMIT'), findsOneWidget);

    await tester.tap(AdvancedTradingDemoPage.tabKey('analytics').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('PnL Summary'), findsOneWidget);
    expect(find.text('Performance Stats'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
