import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_advanced_orders_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpAdvancedOrders(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnAdvancedOrders,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-366 mock repository exposes advanced orders BE draft', () async {
    final snapshot = await const MockStakingAdvancedOrdersRepository()
        .getAdvancedOrders();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-advanced-orders');
    expect(snapshot.actionDraft, contains('POST /orders/:id/action'));
    expect(snapshot.actionDraft, contains('advanced-orders'));
    expect(snapshot.title, 'Advanced Orders');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.activeOrders, hasLength(3));
    expect(snapshot.orderHistory, hasLength(2));
    expect(snapshot.statCards, hasLength(3));
    expect(snapshot.assetOptions.first, 'stETH (Lido)');
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      ]),
    );
  });

  testWidgets('SC-366 renders advanced orders active baseline', (tester) async {
    await pumpAdvancedOrders(tester);

    expect(find.byType(StakingAdvancedOrdersPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Advanced Orders'), findsOneWidget);
    expect(find.byKey(StakingAdvancedOrdersPage.infoKey), findsOneWidget);
    expect(find.text('Automate Your Liquid Staking Strategy'), findsOneWidget);
    expect(find.byKey(StakingAdvancedOrdersPage.statsKey), findsOneWidget);
    expect(find.text('Active Orders'), findsWidgets);
    expect(find.text('+\$12.4K'), findsOneWidget);
    expect(
      find.byKey(StakingAdvancedOrdersPage.createButtonKey),
      findsOneWidget,
    );
    expect(find.byKey(StakingAdvancedOrdersPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(StakingAdvancedOrdersPage.orderKey('o1')),
      findsOneWidget,
    );
    expect(find.text('Take Profit'), findsWidgets);
    expect(find.text('50 stETH'), findsOneWidget);
    expect(find.byKey(StakingAdvancedOrdersPage.howItWorksKey), findsOneWidget);
  });

  testWidgets('SC-366 create order sheet switches order type copy', (
    tester,
  ) async {
    await pumpAdvancedOrders(tester);

    await tester.tap(find.byKey(StakingAdvancedOrdersPage.createButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingAdvancedOrdersPage.createSheetKey),
      findsOneWidget,
    );
    expect(find.text('Create Take Profit'), findsOneWidget);
    expect(find.text('Trigger Price (Take Profit At)'), findsOneWidget);

    await tester.tap(
      find.byKey(
        StakingAdvancedOrdersPage.typeKey(StakingAdvancedOrderType.stopLoss),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Stop Loss'), findsOneWidget);
    expect(find.text('Stop Price (Exit If Below)'), findsOneWidget);
    expect(
      find.textContaining('Stop-loss protects against downside'),
      findsOneWidget,
    );
  });

  testWidgets('SC-366 history tab shows triggered and cancelled orders', (
    tester,
  ) async {
    await pumpAdvancedOrders(tester);

    await tester.tap(find.byKey(StakingAdvancedOrdersPage.tabKey('history')));
    await tester.pumpAndSettle();

    expect(find.text('Order History'), findsOneWidget);
    expect(
      find.byKey(StakingAdvancedOrdersPage.orderKey('h1')),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingAdvancedOrdersPage.orderKey('h2')),
      findsOneWidget,
    );
    expect(find.text('Triggered'), findsWidgets);
    expect(find.text('Cancelled'), findsOneWidget);
  });

  testWidgets('SC-366 header back returns to staking hub', (tester) async {
    await pumpAdvancedOrders(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
