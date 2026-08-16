import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/trade_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTradeSettings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeSettings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-052 mock repository exposes trade settings BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getTradeSettings();
    final settings = snapshot.settings;

    expect(snapshot.trade.pairs, hasLength(3));
    expect(settings.defaultOrderType, 'limit');
    expect(settings.defaultSlippage, .5);
    expect(settings.confirmOrders, isTrue);
    expect(settings.skipConfirmSmall, isFalse);
    expect(settings.showOrderBook, isTrue);
    expect(settings.showRecentTrades, isTrue);
    expect(settings.defaultPctButtons, isTrue);
    expect(settings.chartTimeframe, '1h');
    expect(settings.priceDecimals, 'auto');
    expect((await repo.patchTradeSettings(settings)).defaultOrderType, 'limit');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-052 renders settings inside the Trade shell', (tester) async {
    await pumpTradeSettings(tester);

    expect(find.byType(TradeSettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cài đặt giao dịch'), findsOneWidget);
    expect(find.text('Mặc định lệnh'), findsOneWidget);
    expect(find.text('Loại lệnh mặc định'), findsOneWidget);
    expect(find.text('Giới hạn'), findsOneWidget);
    expect(find.text('Trượt giá tối đa (Market orders)'), findsOneWidget);
    expect(find.text('Xác nhận lệnh'), findsOneWidget);
    expect(find.text('Phản hồi'), findsOneWidget);
    expect(find.text('Hiển thị'), findsOneWidget);
  });

  testWidgets('SC-052 first viewport reaches order defaults controls', (
    tester,
  ) async {
    await pumpTradeSettings(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-052 TradeSettingsPage',
      semanticLabel: 'Cài đặt giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(TradeSettingsPage.orderTypeKey('market')),
      targetLabel: 'the first trade settings order type control',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-052 order defaults and display chips update locally', (
    tester,
  ) async {
    await pumpTradeSettings(tester);

    await tester.tap(find.byKey(TradeSettingsPage.orderTypeKey('market')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeSettingsPage.slippageKey(1.0)));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(TradeSettingsPage.timeframeKey('4h')),
    );
    await tester.tap(find.byKey(TradeSettingsPage.timeframeKey('4h')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeSettingsPage.decimalsKey('4')));
    await tester.pumpAndSettle();

    expect(find.byType(TradeSettingsPage), findsOneWidget);
    expect(find.text('1.0%'), findsOneWidget);
  });

  testWidgets('SC-052 confirmation toggle hides dependent setting', (
    tester,
  ) async {
    await pumpTradeSettings(tester);

    expect(find.text('Bỏ qua xác nhận cho lệnh nhỏ'), findsOneWidget);

    await tester.tap(find.byKey(TradeSettingsPage.confirmOrdersKey));
    await tester.pumpAndSettle();

    expect(find.text('Bỏ qua xác nhận cho lệnh nhỏ'), findsNothing);
  });

  testWidgets('SC-052 reset returns defaults after local changes', (
    tester,
  ) async {
    await pumpTradeSettings(tester);

    await tester.tap(find.byKey(TradeSettingsPage.orderTypeKey('market')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(TradeSettingsPage.resetKey));
    await tester.tap(find.byKey(TradeSettingsPage.resetKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradeSettingsPage), findsOneWidget);
    expect(find.text('Giới hạn'), findsOneWidget);
  });
}
