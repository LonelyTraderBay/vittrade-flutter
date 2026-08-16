import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_tools_demo_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAdvancedTools(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeAdvancedTools,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-062 mock repository exposes advanced tools BE draft', () async {
    final repo = const MockTradeTerminalRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getAdvancedTools();
    final result = await repo.submitAdvancedToolAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'bulk',
        action: 'cancel',
        orderIds: ['o1', 'o2'],
      ),
    );

    expect(snapshot.trade.pairs, hasLength(3));
    expect(snapshot.features, hasLength(3));
    expect(snapshot.features.first.title, 'Ladder Trading');
    expect(snapshot.ladderOrders, hasLength(2));
    expect(snapshot.bulkOrders, hasLength(4));
    expect(snapshot.shortcuts, hasLength(4));
    expect(snapshot.statusItems, hasLength(5));
    expect(result.status, 'accepted');
    expect(result.affectedCount, 2);
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

  testWidgets('SC-062 renders AdvancedToolsDemoPage inside the Trade shell', (
    tester,
  ) async {
    await pumpAdvancedTools(tester);

    expect(find.byType(AdvancedToolsDemoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Công cụ nâng cao'), findsOneWidget);
    expect(find.text('Advanced Trading Tools'), findsOneWidget);
    expect(find.text('Ladder Trading'), findsWidgets);
    expect(find.text('Bulk Operations'), findsWidgets);
    expect(find.text('Keyboard Shortcuts'), findsWidgets);
    expect(find.text('Trading Speed: 3x Faster'), findsOneWidget);
    expect(find.text('Advanced Tools Benefits'), findsOneWidget);
    expect(find.text('Implementation Status'), findsOneWidget);
  });

  testWidgets('SC-062 first viewport reaches first advanced tool', (
    tester,
  ) async {
    await pumpAdvancedTools(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-062 AdvancedToolsDemoPage',
      semanticLabel: 'Công cụ nâng cao',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(AdvancedToolsDemoPage.featureKey('ladder')),
      targetLabel: 'the first advanced tool card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-062 tab switching shows bulk and shortcuts actions', (
    tester,
  ) async {
    await pumpAdvancedTools(tester);

    await tester.ensureVisible(
      find.byKey(AdvancedToolsDemoPage.tabKey('bulk')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.tabKey('bulk')));
    await tester.pumpAndSettle();
    expect(find.text('Open Bulk Operations'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(AdvancedToolsDemoPage.tabKey('shortcuts')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.tabKey('shortcuts')));
    await tester.pumpAndSettle();
    expect(find.text('View Shortcuts Reference'), findsOneWidget);
  });

  testWidgets('SC-062 sheets submit local mock actions', (tester) async {
    await pumpAdvancedTools(tester);

    await tester.ensureVisible(
      find.byKey(AdvancedToolsDemoPage.ladderButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.ladderButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Place Buy Order'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(AdvancedToolsDemoPage.ladderSubmitKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.ladderSubmitKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã đặt lệnh mua'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(AdvancedToolsDemoPage.tabKey('bulk')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.tabKey('bulk')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(AdvancedToolsDemoPage.bulkButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.bulkButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Cancel Selected Orders'), findsOneWidget);
    await tester.ensureVisible(find.byKey(AdvancedToolsDemoPage.bulkCancelKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedToolsDemoPage.bulkCancelKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã hủy 4 lệnh'), findsOneWidget);
  });

  testWidgets('SC-062 back returns to SC-048 TradePage', (tester) async {
    await pumpAdvancedTools(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(AdvancedToolsDemoPage), findsNothing);
  });
}
