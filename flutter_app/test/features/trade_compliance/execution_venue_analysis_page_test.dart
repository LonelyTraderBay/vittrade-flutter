import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/execution/execution_venue_analysis_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpVenueAnalysis(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-097 mock repository exposes venue analysis BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getExecutionVenueAnalysis();

    expect(snapshot.defaultTab, 'comparison');
    expect(snapshot.defaultSort, 'volume');
    expect(snapshot.summary.totalVenues, 5);
    expect(snapshot.summary.avgTotalCost.toStringAsFixed(2), '4.44');
    expect(snapshot.venues.map((item) => item.venue), [
      'Binance',
      'Coinbase Pro',
      'Kraken',
      'Bybit',
      'OKX',
    ]);
    expect(snapshot.costTrends.map((item) => item.month), [
      'Nov',
      'Dec',
      'Jan',
    ]);
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

  testWidgets('SC-097 renders execution venue analysis inside Trade shell', (
    tester,
  ) async {
    await pumpVenueAnalysis(tester);

    expect(find.byType(ExecutionVenueAnalysisPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Execution Venue Analysis'), findsOneWidget);
    expect(find.text('Detailed Comparison'), findsOneWidget);
    expect(find.text('Total Venues'), findsOneWidget);
    expect(find.text('Sort\nby:'), findsOneWidget);
    expect(find.text('Venue Comparison'), findsOneWidget);
    expect(find.text('Binance'), findsOneWidget);
  });

  testWidgets('SC-097 first viewport reaches venue comparison data', (
    tester,
  ) async {
    await pumpVenueAnalysis(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ExecutionVenueAnalysisPage',
      semanticLabel: 'Phân tích chi tiết các sàn thực thi lệnh giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ExecutionVenueAnalysisPage.venueKey('Binance')),
      minVisibleHeight: 24,
      targetLabel: 'first execution venue card',
      reason:
          'Execution venue analysis must show the first venue comparison row '
          'above bottom navigation after summary and controls.',
    );
  });

  testWidgets('SC-097 sort and tabs update local comparison content', (
    tester,
  ) async {
    await pumpVenueAnalysis(tester);

    await tester.tap(ExecutionVenueAnalysisPage.sortKey('cost').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('3.88 bps'), findsOneWidget);

    await tester.tap(ExecutionVenueAnalysisPage.tabKey('costs').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Cost Breakdown'), findsOneWidget);
    expect(find.text('Trading Fee'), findsWidgets);

    await tester.tap(ExecutionVenueAnalysisPage.tabKey('speed').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Speed Metrics'), findsOneWidget);

    await tester.tap(ExecutionVenueAnalysisPage.tabKey('trends').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Cost Trends (Last 3 Months)'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
