import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/best_execution_reports_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/execution_venue_analysis_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBestExecution(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyBestExecutionReports,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-096 mock repository exposes best execution BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getBestExecutionReports();

    expect(snapshot.defaultTab, 'current');
    expect(snapshot.summary.totalOrders, 36630);
    expect(snapshot.summary.totalValue, 2507000000);
    expect(snapshot.summary.avgScore, 93.4);
    expect(snapshot.venues.map((item) => item.venue), [
      'Binance',
      'Coinbase Pro',
      'Kraken',
      'Bybit',
      'OKX',
    ]);
    expect(snapshot.archive.first.status, 'draft');
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

  testWidgets('SC-096 renders best execution reports inside Trade shell', (
    tester,
  ) async {
    await pumpBestExecution(tester);

    expect(find.byType(BestExecutionReportsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Best Execution Reports'), findsOneWidget);
    expect(find.text('RTS 27 / RTS 28 Compliance'), findsOneWidget);
    expect(find.text('MiFID II RTS 27/28 Compliance'), findsOneWidget);
    expect(find.text('Total Orders'), findsOneWidget);
    expect(find.text('Top 5 Execution Venues (By Volume)'), findsOneWidget);
    expect(find.text('Binance'), findsOneWidget);
  });

  testWidgets('SC-096 first viewport reaches top venue', (tester) async {
    await pumpBestExecution(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BestExecutionReportsPage',
      semanticLabel: 'Báo cáo thực thi lệnh tốt nhất theo RTS 27/28',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(BestExecutionReportsPage.venueKey(1)),
      minVisibleHeight: 24,
      targetLabel: 'top execution venue',
      reason:
          'Best execution reports must show the first venue above bottom '
          'navigation after compliance notice, summary, and tabs.',
    );
  });

  testWidgets('SC-096 switches archive tab and exposes report actions', (
    tester,
  ) async {
    await pumpBestExecution(tester);

    await tester.tap(BestExecutionReportsPage.tabKey('archive').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Historical Reports'), findsOneWidget);
    expect(find.text('Q4 2025'), findsOneWidget);

    await tester.tap(BestExecutionReportsPage.tabKey('current').asFinder());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(BestExecutionReportsPage.exportKey));
    expect(find.text('Export PDF'), findsOneWidget);
    expect(find.text('Publish Report'), findsOneWidget);
  });

  testWidgets('SC-096 detailed analysis edge opens SC-097 route', (
    tester,
  ) async {
    await pumpBestExecution(tester);

    await tester.ensureVisible(
      find.byKey(BestExecutionReportsPage.analysisKey),
    );
    await tester.tap(find.byKey(BestExecutionReportsPage.analysisKey));
    await tester.pumpAndSettle();

    expect(find.byType(ExecutionVenueAnalysisPage), findsOneWidget);
    expect(find.text('Execution Venue Analysis'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
