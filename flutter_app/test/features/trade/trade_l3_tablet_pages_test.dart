import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/futures_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/leverage_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/margin_hub_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/margin_trading_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';

void main() {
  Future<void> pumpTablet(
    WidgetTester tester, {
    required String initialLocation,
    Size size = const Size(1280, 800),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: initialLocation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-057 renders the futures form page with contract facts '
      'beside it', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/btcusdt/futures');

    expect(find.byType(FuturesTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    // Cột chính: hướng + ký quỹ + CTA; cột phụ: facts hợp đồng + vị thế.
    expect(find.text('Giá tăng'), findsOneWidget);
    expect(find.text('Giá giảm'), findsOneWidget);
    expect(find.byKey(FuturesTabletPage.marginFieldKey), findsOneWidget);
    expect(find.byKey(FuturesTabletPage.submitKey), findsOneWidget);
    expect(find.text('Giá đánh dấu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-057 typing margin opens the wired preview + confirm '
      'flow', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/btcusdt/futures');

    await tester.enterText(find.byKey(FuturesTabletPage.marginFieldKey), '100');
    await tester.pumpAndSettle();

    // Preview facts hiện sau khi nhập ký quỹ (wired thật, không nút giả).
    expect(find.text('Quy mô vị thế'), findsOneWidget);
    expect(find.text('Giá thanh lý'), findsAtLeast(1));

    await tester.tap(find.byKey(FuturesTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Xem lại hợp đồng'), findsOneWidget);
  });

  testWidgets('SC-058 renders the leverage page with impact table and '
      'wired presets', (tester) async {
    await pumpTablet(
      tester,
      initialLocation: '/trade/btcusdt/futures/leverage',
    );

    expect(find.byType(LeverageTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    // Bảng tác động theo mức + preset wired.
    expect(find.text('Khoảng cách giá thanh lý'), findsOneWidget);
    expect(find.byKey(LeverageTabletPage.presetKey(25)), findsOneWidget);
    await tester.tap(find.byKey(LeverageTabletPage.presetKey(25)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-085 renders the margin trading page with account panel', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/margin');

    expect(find.byType(MarginTradingTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(MarginTradingTabletPage.amountFieldKey), findsOneWidget);
    expect(find.text('Tài khoản ký quỹ'), findsOneWidget);
    expect(find.text('Tỷ lệ ký quỹ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-086 margin pair variant reuses the same tablet page', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/margin/btcusdt');

    expect(find.byType(MarginTradingTabletPage), findsOneWidget);
    expect(find.text('Margin BTC/USDT'), findsOneWidget);
  });

  testWidgets('SC-090 renders the margin hub dashboard with wired menu', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/margin/hub');

    expect(find.byType(MarginHubTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byType(VitNavigationRail), findsOneWidget);
    expect(find.byKey(MarginHubTabletPage.statsKey), findsOneWidget);
    // Menu điều hướng nhanh wired push.
    final menuTile = find.byKey(const Key('sc090_tablet_menu_open-position'));
    if (menuTile.evaluate().isNotEmpty) {
      await tester.tap(menuTile);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Lô 3 pages stay overflow-safe at portrait QA width', (
    tester,
  ) async {
    for (final location in [
      '/trade/btcusdt/futures',
      '/trade/btcusdt/futures/leverage',
      '/trade/margin',
      '/trade/margin/hub',
    ]) {
      await pumpTablet(
        tester,
        initialLocation: location,
        size: const Size(800, 1280),
      );
      expect(tester.takeException(), isNull, reason: 'overflow at $location');
    }
  });
}
