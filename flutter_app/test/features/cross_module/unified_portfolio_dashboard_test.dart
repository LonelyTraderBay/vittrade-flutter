import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/cross_module/data/unified_portfolio_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/unified_portfolio_dashboard_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/hub/dca_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/wallet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpUnifiedPortfolio(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.unifiedPortfolio,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> pumpRoute(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-321 mock repository exposes unified portfolio BE draft', () async {
    final snapshot = await const MockUnifiedPortfolioRepository()
        .getDashboard();

    expect(snapshot.endpoint, '/api/mobile/cross-module/unified-portfolio');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Unified Portfolio');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.totalValue, 102380);
    expect(snapshot.totalPnl, 2995);
    expect(snapshot.totalPositions, 36);
    expect(snapshot.modules.length, 6);
    expect(snapshot.modules.first.route, AppRoutePaths.wallet);
    expect(snapshot.modules[3].route, AppRoutePaths.marketsPredictions);
    expect(snapshot.modules[4].pointsOnly, isTrue);
    expect(snapshot.contractNotes, contains('Arena points-only boundary'));
    expect(
      snapshot.supportedStates,
      containsAll([
        UnifiedPortfolioScreenState.loading,
        UnifiedPortfolioScreenState.empty,
        UnifiedPortfolioScreenState.error,
        UnifiedPortfolioScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-321 renders unified portfolio overview baseline', (
    tester,
  ) async {
    await pumpUnifiedPortfolio(tester);

    expect(find.byType(UnifiedPortfolioDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Unified Portfolio'), findsOneWidget);
    expect(find.text('Tong quan'), findsOneWidget);
    expect(find.text('Phan tich'), findsOneWidget);
    expect(find.text('Lich su'), findsOneWidget);
    expect(find.text('\$102,380'), findsOneWidget);
    expect(find.text('Portfolio Distribution'), findsOneWidget);
    expect(find.text('Module Breakdown'), findsOneWidget);
    expect(find.text('Wallet Holdings'), findsOneWidget);
  });

  testWidgets('SC-321 switches analysis and history tabs locally', (
    tester,
  ) async {
    await pumpUnifiedPortfolio(tester);

    await tester.tap(
      find.byKey(
        UnifiedPortfolioDashboardPage.tabKey(UnifiedPortfolioTab.analysis),
      ),
    );
    await pumpRoute(tester);
    expect(find.text('P&L by Module'), findsOneWidget);
    expect(find.text('Performance Ranking'), findsOneWidget);

    await tester.tap(
      find.byKey(
        UnifiedPortfolioDashboardPage.tabKey(UnifiedPortfolioTab.history),
      ),
    );
    await pumpRoute(tester);
    expect(find.text('Portfolio Growth History'), findsOneWidget);
    expect(find.text('Module Growth (6 months)'), findsOneWidget);
  });

  testWidgets('SC-321 module cards navigate to resolved owning modules', (
    tester,
  ) async {
    Future<void> verifyEdge(
      UnifiedPortfolioModuleId moduleId,
      Type expectedType,
    ) async {
      await pumpUnifiedPortfolio(tester);
      final moduleFinder = find.byKey(
        UnifiedPortfolioDashboardPage.moduleKey(moduleId),
      );
      await tester.ensureVisible(moduleFinder);
      await tester.tap(moduleFinder);
      await pumpRoute(tester);
      expect(find.byType(expectedType), findsOneWidget);
    }

    await verifyEdge(UnifiedPortfolioModuleId.wallet, WalletPage);
    await verifyEdge(UnifiedPortfolioModuleId.trading, TradePage);
    await verifyEdge(UnifiedPortfolioModuleId.p2p, P2PHomePage);
    await verifyEdge(UnifiedPortfolioModuleId.predictions, PredictionsHomePage);
    await verifyEdge(UnifiedPortfolioModuleId.arena, ArenaHomePage);
    await verifyEdge(UnifiedPortfolioModuleId.dca, DCAPage);
  });
}
