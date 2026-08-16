import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_analytics_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-359 mock repository exposes analytics BE draft', () async {
    final snapshot = await const MockStakingAnalyticsRepository()
        .getAnalytics();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-analytics');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('realtime-refresh'));
    expect(snapshot.title, 'Phân tích Hiệu suất');
    expect(snapshot.backRoute, AppRoutePaths.earnDashboard);
    expect(snapshot.defaultTab, 'earnings');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'earnings',
      'apy',
      'roi',
      'products',
    ]);
    expect(snapshot.summary.totalEarned, 315.82);
    expect(snapshot.summary.averageApy, 7.2);
    expect(snapshot.earningsBreakdown, hasLength(6));
    expect(snapshot.apyTrends, hasLength(6));
    expect(snapshot.roiComparison, hasLength(6));
    expect(snapshot.productPerformance, hasLength(5));
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-359 renders earnings analytics baseline', (tester) async {
    await pumpAnalytics(tester);

    expect(find.byType(StakingAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích Hiệu suất'), findsOneWidget);
    expect(find.byKey(StakingAnalyticsPage.summaryKey), findsOneWidget);
    expect(find.text('+\$315.82'), findsOneWidget);
    expect(find.text('7.2%'), findsOneWidget);
    expect(find.text('2.4%'), findsOneWidget);
    expect(find.byKey(StakingAnalyticsPage.earningsChartKey), findsOneWidget);
    expect(find.byKey(StakingAnalyticsPage.assetGridKey), findsOneWidget);
    expect(find.byKey(StakingAnalyticsPage.assetKey('BTC')), findsOneWidget);
    expect(find.byKey(StakingAnalyticsPage.assetKey('LP')), findsOneWidget);
    expect(find.textContaining('Dữ liệu được cập nhật'), findsOneWidget);
  });

  testWidgets('SC-359 first viewport reaches calculator action', (
    tester,
  ) async {
    await pumpAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-359 StakingAnalyticsPage',
      semanticLabel:
          'Phân tích hiệu suất staking — lợi nhuận, APY và ROI theo thời gian',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingAnalyticsPage.calculateButtonKey),
      routeName: 'SC-359 StakingAnalyticsPage',
      actionLabel: 'the staking calculator action',
    );
  });

  testWidgets('SC-359 supports analytics tab state changes', (tester) async {
    await pumpAnalytics(tester);

    await tester.tap(find.text('APY Trends'));
    await tester.pumpAndSettle();
    expect(find.byKey(StakingAnalyticsPage.apyChartKey), findsOneWidget);
    expect(find.text('Xu hướng APY (6 tháng)'), findsOneWidget);

    await tester.tap(find.text('ROI So sánh'));
    await tester.pumpAndSettle();
    expect(find.byKey(StakingAnalyticsPage.roiChartKey), findsOneWidget);
    expect(find.text('ROI: Staking vs Holding'), findsOneWidget);

    await tester.tap(find.text('Sản phẩm'));
    await tester.pumpAndSettle();
    expect(find.byKey(StakingAnalyticsPage.productListKey), findsOneWidget);
    expect(find.byKey(StakingAnalyticsPage.productKey('SOL')), findsOneWidget);
  });

  testWidgets('SC-359 calculator state can toggle compound mode', (
    tester,
  ) async {
    await pumpAnalytics(tester);

    await tester.tap(find.byKey(StakingAnalyticsPage.calculateButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingAnalyticsPage.calculatorKey), findsOneWidget);
    expect(find.text('Mẫu tính lợi nhuận'), findsOneWidget);
    expect(find.text('Lãi đơn'), findsOneWidget);

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    expect(find.text('Lãi kép'), findsOneWidget);
  });

  testWidgets('SC-359 header back returns to staking dashboard', (
    tester,
  ) async {
    await pumpAnalytics(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingDashboardPage), findsOneWidget);
    expect(find.text('Staking Dashboard'), findsOneWidget);
  });
}
