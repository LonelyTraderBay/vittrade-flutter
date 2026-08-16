import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/active_copies_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/flow/copy_configuration_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpActiveCopies(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyActive,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-066 mock repository exposes active copies BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getActiveCopies();
    final result = await repo.submitCopyTradingAction(
      const TradeCopyActionRequest(providerId: 'provider001', action: 'stop'),
    );

    expect(snapshot.trade.copyProviders, isNotEmpty);
    expect(snapshot.portfolio.totalCapital, 10000);
    expect(snapshot.portfolio.totalValue, 10500);
    expect(snapshot.portfolio.totalPnl, 500);
    expect(snapshot.portfolio.activeCopies, 2);
    expect(snapshot.defaultTab, 'all');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'all',
      'active',
      'paused',
      'history',
    ]);
    expect(snapshot.copies, hasLength(3));
    expect(snapshot.copies.first.providerName, 'AlphaHunter_VN');
    expect(snapshot.copies.first.providerId, 'provider001');
    expect(snapshot.copies.first.recentTrades, hasLength(3));
    expect(result.action, 'stop');
    expect(result.status, 'accepted');
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

  testWidgets('SC-066 renders ActiveCopiesPage inside the Trade shell', (
    tester,
  ) async {
    await pumpActiveCopies(tester);

    expect(find.byType(ActiveCopiesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Copy đang chạy'), findsOneWidget);
    expect(find.text('Tổng quan portfolio'), findsOneWidget);
    expect(find.text(r'$10000'), findsOneWidget);
    expect(find.text(r'+$500'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Tạm dừng'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('SteadyGains_Pro'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsOneWidget);
  });

  testWidgets('SC-066 tabs filter active copies and empty states', (
    tester,
  ) async {
    await pumpActiveCopies(tester);

    await tester.tap(find.byKey(ActiveCopiesPage.tabKey('paused')));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có copy nào đang chạy'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsNothing);

    await tester.tap(find.byKey(ActiveCopiesPage.tabKey('active')));
    await tester.pumpAndSettle();

    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('SteadyGains_Pro'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsOneWidget);
  });

  testWidgets('SC-066 first viewport reaches first active copy card', (
    tester,
  ) async {
    await pumpActiveCopies(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(ActiveCopiesPage.copyKey('copy-1')),
      routeName: 'ActiveCopiesPage',
      actionLabel: 'first active copy card',
    );
  });

  testWidgets('SC-066 provider detail uses the SC-070 route edge', (
    tester,
  ) async {
    await pumpActiveCopies(tester);

    await tester.tap(find.byKey(ActiveCopiesPage.expandKey('copy-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ActiveCopiesPage.detailsKey('copy-1')),
    );
    await tester.tap(find.byKey(ActiveCopiesPage.detailsKey('copy-1')));
    await tester.pumpAndSettle();

    expect(find.byType(ActiveCopiesPage), findsNothing);
    expect(find.text('Không tìm thấy provider'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ActiveCopiesPage), findsOneWidget);
  });

  testWidgets('SC-066 configure edge uses the SC-072 route', (tester) async {
    await pumpActiveCopies(tester);

    await tester.tap(find.byKey(ActiveCopiesPage.expandKey('copy-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ActiveCopiesPage.configureKey('copy-1')),
    );
    await tester.tap(find.byKey(ActiveCopiesPage.configureKey('copy-1')));
    await tester.pumpAndSettle();

    expect(find.byType(ActiveCopiesPage), findsNothing);
    expect(find.byType(CopyConfigurationPage), findsOneWidget);
    expect(find.text('Copy Configuration'), findsNothing);
  });

  testWidgets('SC-066 stop copy requires typed confirmation', (tester) async {
    await pumpActiveCopies(tester);

    await tester.tap(find.byKey(ActiveCopiesPage.expandKey('copy-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ActiveCopiesPage.stopKey('copy-1')));
    await tester.tap(find.byKey(ActiveCopiesPage.stopKey('copy-1')));
    await tester.pumpAndSettle();

    expect(find.text('Dừng copy?'), findsOneWidget);
    await tester.enterText(
      find.byKey(ActiveCopiesPage.stopConfirmInputKey),
      'STOP',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ActiveCopiesPage.stopConfirmButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Dừng copy?'), findsNothing);
    expect(find.textContaining('provider001 đã được ghi nhận'), findsOneWidget);
  });

  testWidgets('SC-066 back and add actions return to SC-063 CopyTradingPage', (
    tester,
  ) async {
    await pumpActiveCopies(tester);

    await tester.tap(find.byKey(ActiveCopiesPage.addCopyKey));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(ActiveCopiesPage), findsNothing);

    await pumpActiveCopies(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
  });
}
