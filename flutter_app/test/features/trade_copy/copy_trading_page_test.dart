import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyTrading(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyTrading,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-063 mock repository exposes copy trading BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getCopyTrading();
    final result = await repo.submitCopyTradingAction(
      const TradeCopyActionRequest(providerId: 'ct001', action: 'follow'),
    );

    expect(snapshot.trade.copyProviders, isNotEmpty);
    expect(snapshot.traders, hasLength(5));
    expect(snapshot.sortOptions, [
      'Top ROI',
      'Ổn định nhất',
      'Nhiều copier',
      'AUM cao',
    ]);
    expect(snapshot.totalCopiers, 11013);
    expect(snapshot.totalAum, 19250000);
    expect(snapshot.riskWarningTitle, 'Cảnh báo rủi ro');
    expect(result.status, 'accepted');
    expect(result.providerId, 'ct001');
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

  testWidgets('SC-063 renders CopyTradingPage inside the Trade shell', (
    tester,
  ) async {
    await pumpCopyTrading(tester);

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Sao chép giao dịch'), findsWidgets);
    expect(find.text('Sao chép chiến lược có kiểm soát'), findsOneWidget);
    expect(find.text('Tổng AUM'), findsOneWidget);
    expect(find.text(r'$19.25M'), findsOneWidget);
    expect(find.text('Cảnh báo rủi ro'), findsOneWidget);
    expect(find.text('Đánh giá trước khi copy'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsWidgets);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('WhaleWatcher'), findsOneWidget);
    expect(find.text('Xem chi tiết'), findsNWidgets(5));
  });

  testWidgets('SC-063 first viewport reaches first provider card', (
    tester,
  ) async {
    await pumpCopyTrading(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-063 CopyTradingPage',
      semanticLabel: 'Sao chép giao dịch – sao chép chiến lược có kiểm soát',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(CopyTradingPage.traderKey('ct003')),
      targetLabel: 'the first copy trader card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-063 sort chips reorder the trader cards', (tester) async {
    await pumpCopyTrading(tester);

    final riskTopBefore = tester
        .getTopLeft(find.byKey(CopyTradingPage.traderKey('ct003')))
        .dy;
    final whaleTopBefore = tester
        .getTopLeft(find.byKey(CopyTradingPage.traderKey('ct005')))
        .dy;
    expect(riskTopBefore, lessThan(whaleTopBefore));

    await tester.ensureVisible(find.byKey(CopyTradingPage.sortKey('AUM cao')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CopyTradingPage.sortKey('AUM cao')));
    await tester.pumpAndSettle();

    final riskTopAfter = tester
        .getTopLeft(find.byKey(CopyTradingPage.traderKey('ct003')))
        .dy;
    final whaleTopAfter = tester
        .getTopLeft(find.byKey(CopyTradingPage.traderKey('ct005')))
        .dy;
    expect(whaleTopAfter, lessThan(riskTopAfter));
  });

  testWidgets('SC-063 provider detail uses the SC-070 route edge', (
    tester,
  ) async {
    await pumpCopyTrading(tester);

    await tester.ensureVisible(find.byKey(CopyTradingPage.detailKey('ct003')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CopyTradingPage.detailKey('ct003')));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsNothing);
    expect(find.text('RiskMaster_88'), findsWidgets);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(CopyTradingPage), findsOneWidget);
  });

  testWidgets('SC-063 back returns to SC-048 TradePage', (tester) async {
    await pumpCopyTrading(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(CopyTradingPage), findsNothing);
  });
}
