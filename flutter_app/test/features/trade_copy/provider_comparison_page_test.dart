import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/provider_comparison_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpProviderComparison(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyComparison,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-076 mock repository exposes provider comparison snapshot', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getProviderComparison();

    expect(snapshot.selectedCount, 3);
    expect(snapshot.maxProviders, 5);
    expect(snapshot.providers.map((provider) => provider.id), [
      'ct001',
      'ct002',
      'ct003',
    ]);
    expect(snapshot.metrics, hasLength(13));
    for (final metric in snapshot.metrics) {
      for (final provider in snapshot.providers) {
        expect(
          metric.values[provider.id],
          isNotEmpty,
          reason: '${metric.label} is missing a value for ${provider.id}',
        );
      }
    }
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

  testWidgets('SC-076 renders comparison baseline in the Trade shell', (
    tester,
  ) async {
    await pumpProviderComparison(tester);

    expect(find.byType(ProviderComparisonPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('So sánh Providers'), findsOneWidget);
    expect(find.text('Đang so sánh 3/5 providers'), findsOneWidget);
    expect(find.text('+ Thêm provider'), findsOneWidget);
    expect(find.text('Metric'), findsOneWidget);
    expect(find.text('Performance'), findsOneWidget);
    expect(find.text('Total ROI'), findsOneWidget);
    expect(find.text('Risk'), findsOneWidget);
    expect(find.text('Execution'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('SteadyGains_Pro'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsOneWidget);
    expect(find.text('+342.5%'), findsOneWidget);
    expect(find.text('82.3%'), findsOneWidget);
    expect(find.text(r'$18.20'), findsOneWidget);
  });

  testWidgets('SC-076 highlights best-in-group metric values', (tester) async {
    await pumpProviderComparison(tester);

    Text textOf(String value) => tester.widget<Text>(find.text(value));

    // Total ROI: higher is better, so ct003 wins.
    expect(textOf('+567.8%').style?.color, AppColors.buy);
    expect(textOf('+342.5%').style?.color, AppColors.text1);
    // Max Drawdown is signed: -8.1% (closest to zero) is best, not -28.3%.
    expect(textOf('-8.1%').style?.color, AppColors.buy);
    expect(textOf('-28.3%').style?.color, AppColors.text1);
    // Est. Monthly Cost: lower is better, so ct002 wins.
    expect(textOf(r'$18.20').style?.color, AppColors.buy);
    // Charter Trade Redesign V2: financial figures always use tabular figures.
    expect(
      textOf('+567.8%').style?.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });

  testWidgets('SC-076 add provider navigates back to copy trading', (
    tester,
  ) async {
    await pumpProviderComparison(tester);

    await tester.tap(find.byKey(ProviderComparisonPage.addProviderLinkKey));
    await tester.pumpAndSettle();

    expect(find.text('Sao chép giao dịch'), findsOneWidget);
  });
}
