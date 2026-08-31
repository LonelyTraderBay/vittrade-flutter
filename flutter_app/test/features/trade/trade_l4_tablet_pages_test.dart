import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/convert_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_history_export_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_settings_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';

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

  testWidgets('SC-056 renders the convert page with quote flow beside '
      'limits', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/convert');

    expect(find.byType(ConvertTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(ConvertTabletPage.amountFieldKey), findsOneWidget);
    expect(find.text('Tỷ giá hiện tại'), findsOneWidget);
    expect(find.byKey(ConvertTabletPage.slippageKey(1.0)), findsOneWidget);

    // Nhập số lượng → quote wired hiện số nhận ước tính.
    await tester.enterText(find.byKey(ConvertTabletPage.amountFieldKey), '50');
    await tester.pumpAndSettle();
    expect(find.text('Nhận ước tính'), findsOneWidget);
    expect(find.byKey(ConvertTabletPage.submitKey), findsOneWidget);
    await tester.tap(find.byKey(ConvertTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận chuyển đổi tài sản'), findsOneWidget);
  });

  testWidgets('SC-052 renders the settings page with wired toggles + '
      'save', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/settings');

    expect(find.byType(TradeSettingsTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(
      find.byKey(const Key('sc052_tablet_toggle_confirm_orders')),
      findsOneWidget,
    );
    expect(find.text('Cấu hình hiện tại'), findsOneWidget);
    expect(find.byKey(TradeSettingsTabletPage.saveKey), findsOneWidget);

    // Bật/tắt công tắc wired — nhãn đổi theo trạng thái.
    await tester.tap(
      find.byKey(const Key('sc052_tablet_toggle_confirm_orders')),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-054 renders the export page with wired format/period/'
      'includes + submit', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/export');

    expect(find.byType(TradeHistoryExportTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byKey(TradeHistoryExportTabletPage.submitKey), findsOneWidget);
    expect(find.text('Tóm tắt dữ liệu'), findsOneWidget);
    expect(find.byKey(const Key('sc054_tablet_format_csv')), findsOneWidget);
    expect(find.byKey(const Key('sc054_tablet_period_30d')), findsOneWidget);

    // Đổi định dạng wired qua controller.
    await tester.tap(find.byKey(const Key('sc054_tablet_format_csv')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Lô 4 pages stay overflow-safe at portrait QA width', (
    tester,
  ) async {
    for (final location in [
      '/trade/convert',
      '/trade/settings',
      '/trade/export',
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
