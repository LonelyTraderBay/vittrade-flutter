import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_event_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/tablet/prediction_event_card_tablet.dart';

/// Gate test Cụm A (redesign 2026-09-17, nền P2 full-width): 4 màn
/// discovery lên workspace 2 cột — panel điều khiển tồn tại, feed là GRID 2
/// (hai thẻ đầu cùng hàng), tầng hẹp (portrait ~704dp) về một cột
/// phone-parity và SC-209 có lại đầu gập bộ lọc.
void main() {
  Future<void> pumpWide(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
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

  Future<void> pumpNarrow(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1280);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
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

  testWidgets('SC-208 wide: panel điều khiển + grid 2 thẻ cùng hàng', (
    tester,
  ) async {
    await pumpWide(tester, AppRoutePaths.marketsPredictions);

    expect(
      find.byKey(PredictionsHomeTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Biến động 24h'), findsOneWidget);

    final cards = find.byType(PredictionEventCardTablet);
    expect(cards, findsWidgets);
    final first = tester.getRect(cards.at(0));
    final second = tester.getRect(cards.at(1));
    // Grid gate: hai thẻ đầu CÙNG HÀNG (top khớp) và chia đôi cột chính.
    expect(second.top, moreOrLessEquals(first.top, epsilon: 0.5));
    expect(second.width, moreOrLessEquals(first.width, epsilon: 0.5));
    expect(second.left - first.right, moreOrLessEquals(12, epsilon: 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-208 hẹp: một cột phone-parity, không panel', (tester) async {
    await pumpNarrow(tester, AppRoutePaths.marketsPredictions);

    expect(find.byKey(PredictionsHomeTabletPage.controlPaneKey), findsNothing);
    final cards = find.byType(PredictionEventCardTablet);
    expect(cards, findsWidgets);
    final first = tester.getRect(cards.at(0));
    final second = tester.getRect(cards.at(1));
    // Một cột: thẻ sau nằm DƯỚI thẻ trước, cùng bề rộng full.
    expect(second.top, greaterThan(first.bottom));
    expect(second.width, moreOrLessEquals(first.width, epsilon: 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-209 wide: bộ lọc luôn mở trong panel + grid kết quả', (
    tester,
  ) async {
    await pumpWide(tester, AppRoutePaths.marketsPredictionsSearch);

    expect(
      find.byKey(PredictionsSearchTabletPage.filterPaneKey),
      findsOneWidget,
    );
    expect(find.text('Sắp xếp'), findsOneWidget);
    expect(find.text('Trạng thái'), findsOneWidget);
    expect(
      find.byKey(PredictionsSearchTabletPage.filtersToggleKey),
      findsNothing,
    );
    final cards = find.byType(PredictionEventCardTablet);
    if (cards.evaluate().length >= 2) {
      final first = tester.getRect(cards.at(0));
      final second = tester.getRect(cards.at(1));
      expect(second.top, moreOrLessEquals(first.top, epsilon: 0.5));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-209 hẹp: có đầu gập bộ lọc và gập được', (tester) async {
    await pumpNarrow(tester, AppRoutePaths.marketsPredictionsSearch);

    final toggle = find.byKey(PredictionsSearchTabletPage.filtersToggleKey);
    expect(toggle, findsOneWidget);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-210 wide: panel tổng quan + movers grid 2', (tester) async {
    await pumpWide(tester, AppRoutePaths.marketsPredictionsBreaking);

    expect(
      find.byKey(PredictionsBreakingTabletPage.controlPaneKey),
      findsOneWidget,
    );
    final movers = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('sc210_mover_'),
    );
    expect(movers, findsWidgets);
    if (movers.evaluate().length >= 2) {
      final first = tester.getRect(movers.at(0));
      final second = tester.getRect(movers.at(1));
      expect(second.top, moreOrLessEquals(first.top, epsilon: 0.5));
      expect(second.width, moreOrLessEquals(first.width, epsilon: 0.5));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-219 wide: panel chips + timeline tháng ở cột chính', (
    tester,
  ) async {
    await pumpWide(tester, AppRoutePaths.marketsPredictionsEventCalendar);

    expect(
      find.byKey(PredictionEventCalendarTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionEventCalendarTabletPage.allCategoryKey),
      findsOneWidget,
    );
    expect(find.byType(PredictionEventDetailTabletPage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
