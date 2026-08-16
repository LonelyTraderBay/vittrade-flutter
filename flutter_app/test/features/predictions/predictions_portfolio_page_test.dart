import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/predictions_portfolio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolio(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.marketsPredictionsPortfolio,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-031 mock repository exposes the portfolio BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getPortfolio();

    expect(
      snapshot.endpoint,
      '/api/mobile/predictions/markets-predictions-portfolio',
    );
    expect(snapshot.profileEndpoint, '/api/mobile/profile/profile-predictions');
    expect(
      snapshot.actionDraft,
      'POST /predictions/orders|claim|watchlist where applicable',
    );
    expect(snapshot.positions, hasLength(7));
    expect(snapshot.activeCount, 5);
    expect(snapshot.closedCount, 2);
    expect(snapshot.openOrders, hasLength(3));
    expect(snapshot.receipts, hasLength(6));
    expect(snapshot.historyCount, 3);
    expect(snapshot.rewards, isNotEmpty);
    expect(snapshot.totalCurrentValue, 1787);
    expect(snapshot.totalPnl, 440.5);
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
  });

  testWidgets('SC-167 redirects to canonical predictions portfolio route', (
    tester,
  ) async {
    await pumpPortfolio(
      tester,
      initialLocation: AppRoutePaths.profilePredictions,
    );

    expect(find.byType(PredictionsPortfolioPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Prediction Portfolio'), findsOneWidget);
    expect(find.text('Portfolio Value'), findsOneWidget);
    expect(
      find.byKey(PredictionsPortfolioPage.positionKey('pos-1')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });

  testWidgets('SC-167 redirect reaches canonical portfolio controls', (
    tester,
  ) async {
    await pumpPortfolio(
      tester,
      initialLocation: AppRoutePaths.profilePredictions,
    );

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-031 PredictionsPortfolioPage',
      semanticLabel: 'Danh mục dự đoán',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(PredictionsPortfolioPage.visibilityToggleKey),
      routeName: 'SC-031 PredictionsPortfolioPage',
      actionLabel: 'the portfolio visibility toggle',
    );
  });

  testWidgets('SC-031 renders portfolio inside the Markets shell', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(PredictionsPortfolioPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Prediction Portfolio'), findsOneWidget);
    expect(find.text('Vị thế · Prediction'), findsOneWidget);
    expect(find.text('\$1787.00'), findsOneWidget);
    expect(find.text('Portfolio Value'), findsOneWidget);
    expect(find.textContaining('Shares'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(
      find.byKey(PredictionsPortfolioPage.positionKey('pos-1')),
      findsOneWidget,
    );
    expect(find.text('Bitcoin reaches \$150K before July 2026?'), findsWidgets);
    expect(find.text('Open Orders'), findsWidgets);
    expect(
      find.byKey(PredictionsPortfolioPage.openOrderKey('oo-1')),
      findsOneWidget,
    );
    expect(find.text('Khám phá Arena cùng chủ đề'), findsOneWidget);
    expect(find.text('Arena Points'), findsOneWidget);
    expect(
      find.text(
        'Prediction positions and P/L stay separate from Arena Points.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-031 first viewport reaches markets portfolio controls', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-031 PredictionsPortfolioPage',
      semanticLabel: 'Danh mục dự đoán',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(PredictionsPortfolioPage.visibilityToggleKey),
      routeName: 'SC-031 PredictionsPortfolioPage',
      actionLabel: 'the portfolio visibility toggle',
    );
  });

  testWidgets('SC-031 local tabs, visibility and cancel state work', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(PredictionsPortfolioPage.visibilityToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('\$1787.00'), findsNothing);
    expect(find.text('••••••'), findsOneWidget);

    await tester.tap(find.byKey(PredictionsPortfolioPage.closedTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Bitcoin above \$100K by Feb 2026?'), findsOneWidget);
    expect(find.text('Super Bowl LX Winner: Kansas City?'), findsOneWidget);

    await tester.tap(find.byKey(PredictionsPortfolioPage.historyTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử lệnh'), findsOneWidget);
    expect(
      find.byKey(PredictionsPortfolioPage.receiptKey('po-4')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(PredictionsPortfolioPage.activeTabKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(PredictionsPortfolioPage.cancelOrderKey('oo-1')),
    );
    await tester.tap(
      find.byKey(PredictionsPortfolioPage.cancelOrderKey('oo-1')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsPortfolioPage.openOrderKey('oo-1')),
      findsNothing,
    );
  });

  testWidgets('SC-031 navigation edges use event detail and placeholders', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(PredictionsPortfolioPage.positionKey('pos-1')));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
  });

  testWidgets('SC-031 receipt and Arena edges are wired safely', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.ensureVisible(
      find.byKey(PredictionsPortfolioPage.openOrderKey('oo-1')),
    );
    await tester.tap(find.byKey(PredictionsPortfolioPage.openOrderKey('oo-1')));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionOrderReceiptPage), findsOneWidget);
    expect(find.text('Chi tiết lệnh'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(PredictionsPortfolioPage.arenaBridgeKey),
    );
    await tester.tap(find.byKey(PredictionsPortfolioPage.arenaBridgeKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaHomePage), findsOneWidget);
  });

  testWidgets('SC-031 invalid constructor backPath falls back to predictions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/custom-prediction-portfolio',
      routes: [
        GoRoute(
          path: '/custom-prediction-portfolio',
          builder: (_, _) => const PredictionsPortfolioPage(
            backPath: 'https://evil.example/predictions',
          ),
        ),
        GoRoute(
          path: AppRoutePaths.marketsPredictions,
          builder: (_, _) => const Scaffold(body: Text('Safe predictions')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Safe predictions'), findsOneWidget);
    expect(find.byType(PredictionsPortfolioPage), findsNothing);
  });
}
