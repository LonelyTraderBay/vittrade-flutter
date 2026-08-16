import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/analytics/copy_performance_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyPerformance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyPerformance('copy001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-074 mock repository exposes copy performance BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getCopyPerformance(copyId: 'copy001');

    expect(snapshot.copyId, 'copy001');
    expect(snapshot.yourReturnPct, 13);
    expect(snapshot.providerReturnPct, 15.6);
    expect(snapshot.performanceGapPct, 2.6);
    expect(snapshot.equityCurve, hasLength(30));
    expect(snapshot.slippageBuckets, hasLength(4));
    expect(snapshot.costAttribution, hasLength(4));
    expect(snapshot.tradeComparisons, hasLength(3));
    expect(snapshot.metrics, hasLength(4));
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

  testWidgets('SC-074 renders copy performance overview in the Trade shell', (
    tester,
  ) async {
    await pumpCopyPerformance(tester);

    expect(find.byType(CopyPerformancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích hiệu suất'), findsOneWidget);
    expect(find.text('Tổng quan so sánh'), findsOneWidget);
    expect(find.text('+13.0%'), findsOneWidget);
    expect(find.text('+15.6%'), findsOneWidget);
    expect(find.text('Đường vốn so sánh (30 ngày)'), findsOneWidget);
    expect(find.text('Tại sao có chênh lệch?'), findsOneWidget);
  });

  testWidgets('SC-074 first viewport reaches performance tabs', (tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyPerformance('copy001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-074 CopyPerformancePage',
      semanticLabel: 'Phân tích hiệu suất',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(CopyPerformancePage.tabKey('overview')),
      targetLabel: 'the performance tabs',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-074 tabs switch to trades and costs', (tester) async {
    await pumpCopyPerformance(tester);

    await tester.tap(find.byKey(CopyPerformancePage.tabKey('trades')));
    await tester.pumpAndSettle();
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('Delay: 2.1s'), findsOneWidget);

    await tester.tap(find.byKey(CopyPerformancePage.tabKey('costs')));
    await tester.pumpAndSettle();
    expect(find.text('Trading Fees'), findsOneWidget);
    expect(find.text('Tổng chi phí'), findsOneWidget);
  });
}
