import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_portfolio_optimizer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolioOptimizer(
    WidgetTester tester, {
    Size size = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaPortfolioOptimizer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-174 mock repository exposes portfolio optimizer BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getPortfolioOptimizer();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-portfolio-optimizer');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.score, 73);
    expect(snapshot.driftPercent, 25);
    expect(snapshot.currentAllocations.map((item) => item.symbol), [
      'BTC',
      'ETH',
      'USDT',
      'SOL',
      'BNB',
    ]);
    expect(snapshot.frontier.length, 5);
    expect(snapshot.suggestions.length, 4);
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

  testWidgets('SC-174 renders portfolio optimizer overview', (tester) async {
    await pumpPortfolioOptimizer(tester);

    expect(find.byType(DCAPortfolioOptimizerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Portfolio Optimizer'), findsOneWidget);
    expect(find.text('Danh mục lệch cao'), findsOneWidget);
    expect(find.text('Hiện tại vs Tối ưu'), findsOneWidget);
    expect(find.text('Efficient Frontier'), findsOneWidget);
    expect(find.text('Optimal (Max Sharpe)'), findsWidgets);
    expect(find.byKey(DCAPortfolioOptimizerPage.applyKey), findsOneWidget);
  });

  testWidgets('SC-174 first viewport reaches optimizer tabs', (tester) async {
    await pumpPortfolioOptimizer(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-174 DCAPortfolioOptimizerPage',
      semanticLabel: 'Tối ưu hóa phân bổ danh mục đầu tư DCA',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCAPortfolioOptimizerPage.tabKey('frontier')),
      routeName: 'SC-174 DCAPortfolioOptimizerPage',
      actionLabel: 'the optimizer tab strip',
    );
  });

  testWidgets('SC-174 360px viewport surfaces optimizer decision content', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester, size: const Size(360, 780));

    expectFirstViewportVisible(
      tester,
      find.text('Efficient Frontier'),
      targetLabel: 'the frontier decision section',
      minVisibleHeight: 18,
      reason:
          'SC-174 must surface the frontier decision section in the 360px '
          'first viewport.',
    );

    final titleRect = tester.getRect(find.text('Hiện tại vs Tối ưu'));
    expect(
      titleRect.height,
      lessThanOrEqualTo(48),
      reason: 'The comparison title should not wrap into a tall hero block.',
    );
  });

  testWidgets('SC-174 360px content width follows Home standard', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester, size: const Size(360, 780));

    expect(find.byType(VitInsetScrollView), findsOneWidget);

    final firstSurfaceRect = tester.getRect(find.byType(VitCard).first);
    final viewport = firstViewportRect(tester);
    final startInset = firstSurfaceRect.left - viewport.left;
    final endInset = viewport.right - firstSurfaceRect.right;

    expect(
      firstSurfaceRect.width,
      greaterThanOrEqualTo(312),
      reason:
          'Portfolio Optimizer should use the Home-standard 20px content '
          'gutters at 360px, not double 40px gutters.',
    );
    expect(startInset, lessThanOrEqualTo(24));
    expect(endInset, lessThanOrEqualTo(24));
  });

  testWidgets('SC-174 decision stack follows compact Home rhythm at 360px', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester, size: const Size(360, 780));

    final frontierTitleTop = tester
        .getRect(find.text('Efficient Frontier'))
        .top;

    expect(
      frontierTitleTop,
      lessThanOrEqualTo(492),
      reason:
          'The optimizer decision section should arrive quickly after the '
          'status and comparison summary on a 360px phone.',
    );
  });

  testWidgets('SC-174 frontier chart exposes legend and data context', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester, size: const Size(360, 780));

    expect(find.text('Tối ưu: +35% · Risk 25%'), findsOneWidget);
    expect(find.text('5 điểm frontier'), findsOneWidget);
  });

  testWidgets('SC-174 proposed allocation is a distinct section', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester);

    await tester.ensureVisible(find.text('Danh mục đề xuất'));
    await tester.pumpAndSettle();

    expect(find.text('Optimal (Max Sharpe)'), findsWidgets);
    expect(find.text('Danh mục đề xuất'), findsOneWidget);
  });

  testWidgets('SC-174 optimizer text has no mojibake artifacts', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester);

    final badTextPattern = RegExp(r'[ÃÂ]|â†|â€|á»|áº|Æ|Ä');
    final badTexts = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data)
        .whereType<String>()
        .where(badTextPattern.hasMatch)
        .toList(growable: false);

    expect(badTexts, isEmpty);
  });

  testWidgets('SC-174 compare action and frontier chart are accessible', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            (widget.properties.label ?? '').contains(
              'Biểu đồ đường biên hiệu quả',
            ),
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('So sánh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('So sánh'));
    await tester.pumpAndSettle();

    expect(
      find.text('Đang so sánh phân bổ hiện tại và tối ưu'),
      findsOneWidget,
    );
  });

  testWidgets('SC-174 tabs and apply allocation route are wired', (
    tester,
  ) async {
    await pumpPortfolioOptimizer(tester);

    await tester.ensureVisible(
      find.byKey(DCAPortfolioOptimizerPage.tabKey('correlation')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCAPortfolioOptimizerPage.tabKey('correlation')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ma trận tương quan'), findsOneWidget);

    await tester.ensureVisible(find.byKey(DCAPortfolioOptimizerPage.applyKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAPortfolioOptimizerPage.applyKey));
    await tester.pumpAndSettle();

    expect(find.text('Auto-Rebalance'), findsOneWidget);
  });
}
