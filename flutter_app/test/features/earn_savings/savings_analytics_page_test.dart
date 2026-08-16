import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_analytics_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

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
            initialLocation: AppRoutePaths.earnSavingsAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-343 mock repository exposes analytics BE draft', () async {
    final snapshot = await const MockSavingsAnalyticsRepository()
        .getAnalytics();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-analytics');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Phân tích Tiết kiệm');
    expect(snapshot.subtitle, 'Yield, compound & phân bổ');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs, ['Yield', 'Compound', 'APY', 'Phân bổ']);
    expect(snapshot.defaultTimeRange, '6M');
    expect(snapshot.summary.totalInvested, 10340.86);
    expect(snapshot.summary.totalEarned, 174.36);
    expect(snapshot.yieldHistory, hasLength(8));
    expect(snapshot.monthlyEarnings, hasLength(6));
    expect(snapshot.contractNotes, contains('realtime-refresh'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-343 renders analytics yield baseline', (tester) async {
    await pumpAnalytics(tester);

    expect(find.byType(SavingsAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích Tiết kiệm'), findsOneWidget);
    expect(find.text(kSavingsToolsHeaderSubtitle), findsOneWidget);
    expect(find.byKey(SavingsAnalyticsPage.summaryKey), findsOneWidget);
    expect(find.text('\$10,340.86'), findsOneWidget);
    expect(find.text('+\$174.36'), findsOneWidget);
    expect(find.text('4.63%'), findsOneWidget);
    expect(find.text('6M'), findsOneWidget);
    expect(find.byKey(SavingsAnalyticsPage.yieldChartKey), findsOneWidget);
    expect(find.text('Tổng yield tích lũy'), findsOneWidget);
    expect(find.byKey(SavingsAnalyticsPage.monthlyChartKey), findsOneWidget);
    expect(find.text('Thu nhập hằng tháng'), findsOneWidget);
    expect(find.byKey(SavingsAnalyticsPage.metricsKey), findsOneWidget);
    expect(find.text('Dự kiến/năm'), findsOneWidget);
  });

  testWidgets('SC-343 supports tab state changes', (tester) async {
    await pumpAnalytics(tester);

    await tester.tap(find.text('APY').first);
    await tester.pumpAndSettle();

    expect(find.text('Xu hướng APY'), findsOneWidget);
    expect(find.textContaining('APY bình quân gia quyền'), findsOneWidget);
  });

  testWidgets('SC-343 range selector keeps yield tab interactive', (
    tester,
  ) async {
    await pumpAnalytics(tester);

    await tester.tap(find.byKey(SavingsAnalyticsPage.rangeKey('30D')));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsAnalyticsPage.yieldChartKey), findsOneWidget);
    expect(find.text('30D'), findsOneWidget);
  });

  testWidgets('SC-343 header back returns to savings overview', (tester) async {
    await pumpAnalytics(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
