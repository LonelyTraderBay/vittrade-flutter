import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/prediction_portfolio_analyzer_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAnalyzer(WidgetTester tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-038 mock repository exposes the portfolio analyzer BE draft',
    () async {
      final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
      final snapshot = await repo.getPortfolioAnalyzer();

      expect(snapshot.positions, hasLength(5));
      expect(snapshot.pnlHistory, hasLength(6));
      expect(snapshot.openPositions, hasLength(3));
      expect(snapshot.closedPositions, hasLength(2));
      expect(snapshot.totalInvested, closeTo(324.6, .001));
      expect(snapshot.totalPortfolioValue, closeTo(378.4, .001));
      expect(snapshot.realizedPnl, 52);
      expect(snapshot.unrealizedPnl, closeTo(1.8, .001));
      expect(snapshot.totalPnl, closeTo(53.8, .001));
      expect(snapshot.totalPnlPercent, closeTo(16.57, .01));
      expect(snapshot.winRate, 50);
      expect(snapshot.categories, hasLength(4));
      expect(snapshot.orders, hasLength(3));
      expect(snapshot.receipts, hasLength(6));
      expect(snapshot.rewards, isNotEmpty);
      expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
      expect(
        snapshot.supportedStates,
        containsAll([
          PredictionScreenState.loading,
          PredictionScreenState.empty,
          PredictionScreenState.error,
          PredictionScreenState.offline,
          PredictionScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-038 renders overview inside the Markets shell', (
    tester,
  ) async {
    await pumpAnalyzer(tester);

    expect(find.byType(PredictionPortfolioAnalyzerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Portfolio Analyzer'), findsOneWidget);
    expect(find.text('Phân tích · Prediction'), findsOneWidget);
    expect(find.text('Tong quan'), findsOneWidget);
    expect(find.text('Hieu suat'), findsOneWidget);
    expect(find.text('Rui ro'), findsOneWidget);
    expect(find.text('Total Portfolio Value'), findsOneWidget);
    expect(find.text('\$378.40'), findsOneWidget);
    expect(find.text('+\$53.80'), findsOneWidget);
    expect(find.text('Open Positions'), findsOneWidget);
    expect(find.text('Win Rate'), findsOneWidget);
    expect(find.text('Portfolio by Category'), findsOneWidget);
    expect(find.text('Crypto'), findsOneWidget);
    expect(find.text('Macro'), findsOneWidget);
  });

  testWidgets('SC-038 first viewport reaches analyzer metrics', (tester) async {
    await pumpAnalyzer(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-038 PredictionPortfolioAnalyzerPage',
      semanticLabel: 'Phân tích danh mục dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Open Positions'),
      targetLabel: 'the first analyzer metric card',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-038 tabs switch performance and risk locally', (
    tester,
  ) async {
    await pumpAnalyzer(tester);

    await tester.tap(
      find.byKey(PredictionPortfolioAnalyzerPage.performanceTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('P/L Over Time'), findsOneWidget);
    expect(find.text('Trade Statistics'), findsOneWidget);
    expect(find.text('Performance Attribution'), findsOneWidget);
    expect(find.text('Global GDP growth > 3% in 2025?'), findsOneWidget);

    await tester.tap(find.byKey(PredictionPortfolioAnalyzerPage.riskTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Risk Exposure'), findsOneWidget);
    expect(find.text('Max Drawdown'), findsOneWidget);
    expect(find.text('Risk by Category'), findsOneWidget);
    expect(find.text('Diversification Score'), findsOneWidget);
  });

  testWidgets('SC-038 back button returns to Predictions home', (tester) async {
    await pumpAnalyzer(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
