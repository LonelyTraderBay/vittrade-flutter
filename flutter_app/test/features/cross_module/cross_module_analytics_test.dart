import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/cross_module/data/cross_module_analytics_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/cross_module_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

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
            initialLocation: AppRoutePaths.crossModuleAnalytics,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test(
    'SC-322 mock repository exposes cross-module analytics BE draft',
    () async {
      final snapshot = await const MockCrossModuleAnalyticsRepository()
          .getAnalytics();

      expect(
        snapshot.endpoint,
        '/api/mobile/cross-module/cross-module-analytics',
      );
      expect(snapshot.actionDraft, 'read-only or local navigation action');
      expect(snapshot.title, 'Cross-Module Analytics');
      expect(snapshot.backRoute, AppRoutePaths.home);
      expect(snapshot.averageRoi.toStringAsFixed(1), '10.4');
      expect(snapshot.totalTrades, 372);
      expect(snapshot.totalVolume, 281690);
      expect(snapshot.bestRoiModule.name, 'Prediction Markets');
      expect(snapshot.mostActiveModule.name, 'Spot Trading');
      expect(snapshot.contractNotes, contains('Open Arena is points-only'));
      expect(
        snapshot.supportedStates,
        containsAll([
          CrossModuleAnalyticsScreenState.loading,
          CrossModuleAnalyticsScreenState.empty,
          CrossModuleAnalyticsScreenState.error,
          CrossModuleAnalyticsScreenState.offline,
          CrossModuleAnalyticsScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-322 renders performance analytics baseline', (tester) async {
    await pumpAnalytics(tester);

    expect(find.byType(CrossModuleAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cross-Module Analytics'), findsOneWidget);
    expect(find.text('Hieu suat'), findsOneWidget);
    expect(find.text('Chi so'), findsOneWidget);
    expect(find.text('So sanh'), findsOneWidget);
    expect(find.text('+10.4%'), findsOneWidget);
    expect(find.text('372'), findsOneWidget);
    expect(find.text('Best ROI'), findsOneWidget);
    expect(find.text('ROI by Module'), findsOneWidget);
    expect(find.text('Monthly ROI Trends'), findsOneWidget);
  });

  testWidgets('SC-322 first viewport reaches analytics tabs', (tester) async {
    await pumpAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-322 CrossModuleAnalytics',
      semanticLabel: 'Phân tích liên module',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(
        CrossModuleAnalyticsPage.tabKey(CrossModuleAnalyticsTab.performance),
      ),
      routeName: 'SC-322 CrossModuleAnalytics',
      actionLabel: 'the performance analytics tab',
    );
  });

  testWidgets('SC-322 switches metrics and comparison tabs locally', (
    tester,
  ) async {
    await pumpAnalytics(tester);

    await tester.tap(
      find.byKey(
        CrossModuleAnalyticsPage.tabKey(CrossModuleAnalyticsTab.metrics),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Multi-Metric Comparison'), findsOneWidget);
    expect(find.text('Chi tiet chi so'), findsOneWidget);
    expect(find.text('Spot Trading'), findsOneWidget);

    await tester.tap(
      find.byKey(
        CrossModuleAnalyticsPage.tabKey(CrossModuleAnalyticsTab.comparison),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Risk vs Return Analysis'), findsOneWidget);
    expect(find.text('Efficiency Comparison'), findsOneWidget);
    expect(
      find.textContaining('Open Arena metrics are not included'),
      findsOneWidget,
    );
  });
}
