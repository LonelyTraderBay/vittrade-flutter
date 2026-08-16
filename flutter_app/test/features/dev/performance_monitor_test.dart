import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dev/data/dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/performance_monitor.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpPerformanceMonitor(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.performanceMonitor,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-326 mock repository exposes performance monitor BE draft', () async {
    final snapshot = await const MockPerformanceMonitorRepository()
        .getPerformanceMonitor();

    expect(snapshot.endpoint, '/api/mobile/dev/dev-performance-monitor');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Performance Monitor');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.summaryMetrics.length, 3);
    expect(snapshot.vitals.length, 5);
    expect(snapshot.lazyChunks.length, 3);
    expect(snapshot.resources.length, 10);
    expect(snapshot.contractNotes, contains('internal role or dev flag'));
    expect(
      snapshot.supportedStates,
      containsAll([
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-326 renders performance monitor baseline', (tester) async {
    await pumpPerformanceMonitor(tester);

    expect(find.byType(PerformanceMonitor), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Performance Monitor'), findsOneWidget);
    expect(find.text('Performance Score'), findsOneWidget);
    expect(find.text('Core Web Vitals'), findsOneWidget);
    expect(find.text('6244ms'), findsWidgets);
    expect(find.text('87.5 MB'), findsOneWidget);
    expect(find.text('3 chunks loaded on-demand'), findsOneWidget);
    expect(find.text('Top 10 Slowest Resources'), findsOneWidget);
    expect(find.text('ArenaPointsLedgerPage.tsx'), findsOneWidget);
  });

  testWidgets('SC-326 scrolls through lower sections', (tester) async {
    await pumpPerformanceMonitor(tester);

    await tester.ensureVisible(find.text('Performance Targets'));
    await tester.pump();

    expect(find.text('Optimization Tips'), findsOneWidget);
    expect(find.text('Lazy Loading Active'), findsOneWidget);
    expect(find.text('- Memory < 50MB (Mobile-friendly)'), findsOneWidget);
  });

  testWidgets('SC-326 header back returns to home', (tester) async {
    await pumpPerformanceMonitor(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomePage), findsOneWidget);
  });
}
