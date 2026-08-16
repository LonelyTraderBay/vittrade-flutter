import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_performance_compare_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCompare(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaPerformanceCompare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-178 mock repository exposes performance compare BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getPerformanceCompare();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-performance-compare');
    expect(
      snapshot.actionDraft,
      'POST /dca/plans|rebalance|schedule; GET with query filters',
    );
    expect(snapshot.investedUsd, 12000);
    expect(snapshot.comparison.length, 12);
    expect(snapshot.metrics.length, 5);
    expect(snapshot.scenarios.length, 4);
    expect(snapshot.radar.length, 5);
    expect(snapshot.dcaFinalValueUsd, 14500);
    expect(snapshot.lumpSumFinalValueUsd, 1548);
    expect(snapshot.winner, DcaPerformanceWinner.dca);
    expect(snapshot.advantagePercent, moreOrLessEquals(107.93, epsilon: 0.01));
    expect(snapshot.dcaPlans, isEmpty);
    expect(snapshot.schedules, isEmpty);
    expect(snapshot.rules, isEmpty);
    expect(snapshot.portfolioTargets, isEmpty);
    expect(snapshot.backtests, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-178 renders comparison baseline', (tester) async {
    await pumpCompare(tester);

    expect(find.byType(DCAPerformanceComparePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('DCA vs Lump Sum'), findsOneWidget);
    expect(find.text('So sánh'), findsOneWidget);
    expect(find.text('DCA Strategy'), findsOneWidget);
    expect(find.text('Lump Sum'), findsWidgets);
    expect(find.text('DCA Strategy Wins'), findsOneWidget);
    expect(find.text('Portfolio Value Over Time'), findsOneWidget);
    expect(find.text('Key Metrics'), findsOneWidget);
  });

  testWidgets('SC-178 supports scenarios and analysis tabs', (tester) async {
    await pumpCompare(tester);

    await tester.tap(find.byKey(DCAPerformanceComparePage.tabKey('scenarios')));
    await tester.pumpAndSettle();
    expect(find.text('Scenarios Analysis'), findsOneWidget);
    expect(find.text('High Volatility'), findsOneWidget);
    expect(find.text('Recommendation'), findsOneWidget);

    await tester.tap(find.byKey(DCAPerformanceComparePage.tabKey('analysis')));
    await tester.pumpAndSettle();
    expect(find.text('Multi-Dimensional Comparison'), findsOneWidget);
    expect(find.text('Pros'), findsNWidgets(2));
    expect(find.text('Cons'), findsNWidgets(2));
  });

  testWidgets('SC-178 first viewport reaches compare controls', (tester) async {
    await pumpCompare(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-178 DCAPerformanceComparePage',
      semanticLabel: 'So sánh hiệu suất giữa đầu tư DCA và đầu tư một lần',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCAPerformanceComparePage.tabKey('compare')),
      routeName: 'SC-178 DCAPerformanceComparePage',
      actionLabel: 'compare tab',
    );
  });
}
