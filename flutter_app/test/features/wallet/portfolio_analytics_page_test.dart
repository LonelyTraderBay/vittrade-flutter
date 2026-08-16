import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/portfolio_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolioAnalytics(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletPortfolioAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-142 mock repository exposes portfolio analytics BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getPortfolioAnalytics();

    expect(snapshot.totalUsd, 57664);
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-portfolio-analytics');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.assets, hasLength(13));
    expect(snapshot.history, hasLength(31));
    expect(snapshot.metrics, hasLength(6));
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-142 renders portfolio analytics overview in Wallet shell', (
    tester,
  ) async {
    await pumpPortfolioAnalytics(tester);

    expect(find.byType(PortfolioAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Phân tích Danh mục'), findsOneWidget);
    expect(find.text('Tổng quan tài sản · không hype'), findsOneWidget);
    expect(find.text('\$57,664.00'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('1M'), findsOneWidget);
    expect(find.text('Chỉ số hiệu suất'), findsOneWidget);
    expect(find.text('Vị thế hiện tại'), findsOneWidget);
  });

  testWidgets('SC-142 first viewport reaches period selector controls', (
    tester,
  ) async {
    await pumpPortfolioAnalytics(
      tester,
      viewport: VitFirstViewport.minimumPhone,
    );

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PortfolioAnalyticsPage',
      semanticLabel: 'Phân tích danh mục - tổng quan tài sản',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(PortfolioAnalyticsPage.periodKey('1M')),
      routeName: 'PortfolioAnalyticsPage',
      actionLabel: 'the active period selector',
    );
  });

  testWidgets('SC-142 view and period controls update local state', (
    tester,
  ) async {
    await pumpPortfolioAnalytics(tester);

    await tester.tap(find.byKey(PortfolioAnalyticsPage.periodKey('3M')));
    await tester.pumpAndSettle();
    expect(find.text('3M'), findsOneWidget);

    await tester.tap(find.byKey(PortfolioAnalyticsPage.viewKey('allocation')));
    await tester.pumpAndSettle();
    expect(find.text('Phân bổ danh mục'), findsOneWidget);
  });
}
