import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/execution_quality_demo_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpExecutionQuality(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeExecutionQuality,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-061 mock repository exposes execution quality BE draft', () async {
    final repo = const MockTradeTerminalRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getExecutionQuality();
    final settings = await repo.updateSlippageSettings(
      const TradeSlippageSettings(
        tolerancePct: 1,
        rejectOnExceed: true,
        partialFillAllowed: false,
      ),
    );
    final amended = await repo.amendOrder(
      const TradeOrderAmendmentRequest(
        orderId: 'ORD-2026-03-11-B9G4E3',
        newPrice: 68600,
        newAmount: .5,
      ),
    );

    expect(snapshot.features, hasLength(3));
    expect(snapshot.report.fills, hasLength(3));
    expect(snapshot.openOrder.queuePosition, 42);
    expect(snapshot.statusItems, hasLength(6));
    expect(snapshot.features.first.title, 'Slippage Protection');
    expect(settings.tolerancePct, 1);
    expect(amended.status, 'modified');
    expect(amended.queuePositionPreserved, isTrue);
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

  testWidgets(
    'SC-061 renders ExecutionQualityDemoPage inside the Trade shell',
    (tester) async {
      await pumpExecutionQuality(tester);

      expect(find.byType(ExecutionQualityDemoPage), findsOneWidget);
      expect(find.byType(VitBottomNav), findsOneWidget);
      expect(find.byType(VitPhoneFrame), findsNothing);
      expect(find.byType(VitStatusBar), findsNothing);
      expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
      expect(find.text('Chất lượng khớp lệnh'), findsOneWidget);
      expect(find.text('Execution Quality'), findsOneWidget);
      expect(find.text('Slippage Protection'), findsWidgets);
      expect(find.text('Execution Report'), findsWidgets);
      expect(find.text('Order Amendment'), findsWidgets);
      expect(find.text('Execution Quality Improvements'), findsOneWidget);
      expect(find.text('Implementation Status'), findsOneWidget);
      expect(find.text('Tier-1 Exchange Parity Achieved'), findsOneWidget);
    },
  );

  testWidgets('SC-061 tab switching shows execution and amendment actions', (
    tester,
  ) async {
    await pumpExecutionQuality(tester);

    await tester.ensureVisible(
      find.byKey(ExecutionQualityDemoPage.tabKey('execution')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.tabKey('execution')));
    await tester.pumpAndSettle();
    expect(find.text('View Sample Execution Report'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ExecutionQualityDemoPage.tabKey('amendment')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.tabKey('amendment')));
    await tester.pumpAndSettle();
    expect(find.text('Modify Open Order'), findsOneWidget);
  });

  testWidgets('SC-061 sheets submit local mock actions', (tester) async {
    await pumpExecutionQuality(tester);

    await tester.ensureVisible(
      find.byKey(ExecutionQualityDemoPage.slippageButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.slippageButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.toleranceKey(1.0)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.slippageSaveKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ngưỡng trượt giá: 1.0%'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(ExecutionQualityDemoPage.tabKey('amendment')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.tabKey('amendment')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ExecutionQualityDemoPage.amendmentButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExecutionQualityDemoPage.amendmentButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Modify Order'), findsWidgets);
    await tester.tap(find.byKey(ExecutionQualityDemoPage.amendmentSaveKey));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Đã sửa lệnh ORD-2026-03-11-B9G4E3'),
      findsOneWidget,
    );
  });

  testWidgets('SC-061 back returns to SC-048 TradePage', (tester) async {
    await pumpExecutionQuality(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(ExecutionQualityDemoPage), findsNothing);
  });
}
