import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: location,
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-056 Tablet uses independent preview composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeConvert);

    expect(find.byType(TradeTabletUtilityPage), findsOneWidget);
    expect(find.byType(TradeTabletPage), findsNothing);
    expect(find.text('Chuyển đổi tài sản'), findsOneWidget);

    await tester.tap(find.byKey(const Key('SC-056-tablet-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SC-056-tablet-cancel')), findsOneWidget);
    await tester.tap(find.byKey(const Key('SC-056-tablet-cancel')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SC-056-tablet-cancel')), findsNothing);
  });

  testWidgets('SC-049 Tablet pair route uses the Trade Tablet page', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradePair('ethusdt'));

    expect(find.byType(TradeTabletPage), findsOneWidget);
    expect(find.text('Giao dịch Spot'), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
  });
}
