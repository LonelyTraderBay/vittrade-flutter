import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/trader_profile_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTraderProfile(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeTrader('trader001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-087 mock repository exposes trader profile BE draft', () async {
    final snapshot = await const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    ).getTraderProfile(traderId: 'trader001');

    expect(snapshot.traderId, 'trader001');
    expect(snapshot.trader.name, 'AlphaHunter_VN');
    expect(snapshot.trader.totalPnlPct, 342.5);
    expect(snapshot.defaultTab, 'overview');
    expect(snapshot.pnlHistory, hasLength(31));
    expect(snapshot.recentTrades, hasLength(5));
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

  testWidgets('SC-087 renders the profile overview inside the Trade shell', (
    tester,
  ) async {
    await pumpTraderProfile(tester);

    expect(find.byType(TraderProfilePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hồ sơ trader'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('+342.5%'), findsOneWidget);
    expect(find.text('\$2.45M'), findsOneWidget);
    expect(find.byKey(TraderProfilePage.copyButtonKey), findsOneWidget);
  });

  testWidgets('SC-087 first viewport reaches copy action', (tester) async {
    await pumpTraderProfile(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TraderProfilePage',
      semanticLabel: 'Hồ sơ trader',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TraderProfilePage.copyButtonKey),
      routeName: 'TraderProfilePage',
      actionLabel: 'copy trader action',
    );
  });

  testWidgets('SC-087 local tabs and follow state update', (tester) async {
    await pumpTraderProfile(tester);

    await tester.tap(TraderProfilePage.copyButtonKey.asFinder());
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.tap(TraderProfilePage.tabKey('trades').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('BTC/USDT'), findsWidgets);
    expect(find.text('OPEN'), findsOneWidget);

    await tester.tap(TraderProfilePage.tabKey('stats').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('AUM'), findsOneWidget);
    expect(find.text('1243 / 2000'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
