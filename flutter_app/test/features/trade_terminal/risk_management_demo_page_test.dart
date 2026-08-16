import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/risk_management_demo_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskManagement(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeRiskManagement,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-060 mock repository exposes risk management BE draft', () async {
    final repo = const MockTradeTerminalRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getRiskManagement();
    final oco = await repo.submitOcoOrder(
      const TradeOcoOrderDraft(
        symbol: 'BTC/USDT',
        side: TradeOrderSide.buy,
        quantity: .015,
        limitPrice: 69000,
        takeProfitPrice: 72000,
        stopPrice: 66000,
      ),
    );
    final sizing = await repo.calculatePositionSize(
      const TradePositionSizeRequest(
        accountBalance: 50000,
        riskPct: 1,
        entryPrice: 69000,
        stopPrice: 67500,
      ),
    );

    expect(snapshot.features, hasLength(3));
    expect(snapshot.positions, hasLength(3));
    expect(snapshot.statusItems, hasLength(5));
    expect(snapshot.features.first.title, 'OCO Orders');
    expect(oco.orderId, 'OCO-DEMO-060');
    expect(sizing.riskAmount, 500);
    expect(sizing.perUnitRisk, 1500);
    expect(sizing.suggestedAmount.toStringAsFixed(6), '0.333333');
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

  testWidgets('SC-060 renders RiskManagementDemoPage inside the Trade shell', (
    tester,
  ) async {
    await pumpRiskManagement(tester);

    expect(find.byType(RiskManagementDemoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Quản lý rủi ro'), findsOneWidget);
    expect(find.text('Risk Management Foundation'), findsOneWidget);
    expect(find.text('OCO Orders'), findsWidgets);
    expect(find.text('Position Dashboard'), findsWidgets);
    expect(find.text('Position Sizing Calculator'), findsWidgets);
    expect(find.text('Lợi ích chính'), findsOneWidget);
    expect(find.text('Implementation Status'), findsOneWidget);
  });

  testWidgets('SC-060 first viewport reaches first risk feature', (
    tester,
  ) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeRiskManagement,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-060 RiskManagementDemoPage',
      semanticLabel: 'Quản lý rủi ro',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(RiskManagementDemoPage.featureKey('oco')),
      targetLabel: 'the OCO risk feature card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-060 tab switching shows positions and calculator', (
    tester,
  ) async {
    await pumpRiskManagement(tester);

    await tester.ensureVisible(
      find.byKey(RiskManagementDemoPage.tabKey('positions')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(RiskManagementDemoPage.tabKey('positions')));
    await tester.pumpAndSettle();
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('Tổng P&L'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(RiskManagementDemoPage.tabKey('calculator')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(RiskManagementDemoPage.tabKey('calculator')));
    await tester.pumpAndSettle();
    expect(find.text('Mở Position Sizing Calculator'), findsOneWidget);
  });

  testWidgets('SC-060 OCO and calculator sheets submit local mock actions', (
    tester,
  ) async {
    await pumpRiskManagement(tester);

    await tester.ensureVisible(find.byKey(RiskManagementDemoPage.ocoButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(RiskManagementDemoPage.ocoButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Đặt lệnh OCO'), findsOneWidget);
    await tester.tap(find.byKey(RiskManagementDemoPage.ocoSubmitKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã đặt OCO-DEMO-060'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(RiskManagementDemoPage.tabKey('calculator')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(RiskManagementDemoPage.tabKey('calculator')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(RiskManagementDemoPage.calculatorButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(RiskManagementDemoPage.calculatorButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Áp dụng khối lượng'), findsOneWidget);
    await tester.tap(find.byKey(RiskManagementDemoPage.calculatorApplyKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã áp dụng khối lượng đề xuất'), findsOneWidget);
  });

  testWidgets('SC-060 back returns to SC-048 TradePage', (tester) async {
    await pumpRiskManagement(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(RiskManagementDemoPage), findsNothing);
  });
}
