// Bù coverage cho code mới của batch nâng cấp predictions tablet
// (CI gate DEC-coverage floor 92.0%): các nhánh TƯƠNG TÁC mà test render
// khói chưa chạm — đổi tab analyzer/market-maker, gõ + lọc search, đổi
// filter/category home. Mỗi test bám key công khai của trang, không phụ
// thuộc text dễ đổi.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_market_maker_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_portfolio_analyzer_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester, String location) async {
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

  testWidgets('SC-218 analyzer: đi qua cả 3 tab overview/performance/risk', (
    tester,
  ) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictionsPortfolioAnalyzer);

    expect(find.text('Tóm tắt danh mục'), findsOneWidget); // tab overview

    await tester.tap(
      find.byKey(PredictionPortfolioAnalyzerTabletPage.performanceTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lãi/lũy lỗ theo thời gian'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionPortfolioAnalyzerTabletPage.riskTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sụt giảm tối đa'), findsOneWidget);
  });

  testWidgets('SC-217 market maker: đi qua tab vị thế + thu nhập', (
    tester,
  ) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictionsMarketMaker);

    await tester.tap(
      find.byKey(PredictionMarketMakerTabletPage.positionsTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Các vị thế'), findsOneWidget);
    expect(find.text('Tổn thất tạm thời'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionMarketMakerTabletPage.earningsTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Phân tích thu nhập'), findsOneWidget);
  });

  testWidgets('SC-209 search: bật bộ lọc, đổi trạng thái, xóa lọc', (
    tester,
  ) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictionsSearch);

    // Nút filter inline trong search bar trượt với finder-tap đơn thuần;
    // chuỗi tap-để-focus + tapAt-theo-rect-hiện-tại là tổ hợp đã kiểm chứng
    // ổn định (down/up đầu kiện định layout, lần bấm sau trúng nút).
    final toggleFinder = find.byKey(
      PredictionsSearchTabletPage.filtersToggleKey,
    );
    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();
    final toggle = tester.getRect(toggleFinder);
    await tester.tapAt(toggle.center);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(PredictionsSearchTabletPage.statusResolvedKey));
    await tester.pumpAndSettle();

    final categoryChip = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('sc209_category_'),
    );
    if (categoryChip.evaluate().isNotEmpty) {
      await tester.tap(categoryChip.first);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(PredictionsSearchTabletPage.clearFiltersKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsSearchTabletPage.statusAllKey),
      findsOneWidget,
      reason:
          'Xóa lọc phải đưa trạng thái về Tất cả (kể cả sau khi chọn danh mục).',
    );
  });

  testWidgets('SC-208 home: đổi filter tab + category + ô tìm kiếm', (
    tester,
  ) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictions);

    await tester.tap(find.byKey(PredictionsHomeTabletPage.newFilterKey));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(PredictionsHomeTabletPage.categoryLiveCryptoKey),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(PredictionsHomeTabletPage.searchFieldKey),
      'eth',
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsHomeTabletPage.contentKey),
      findsOneWidget,
      reason: 'Trang vẫn render sau khi lọc + tìm kiếm.',
    );

    for (final label in ['Phổ biến', 'Thanh khoản', 'Sắp đóng', 'Cạnh tranh']) {
      await tester.tap(find.text(label).first);
      await tester.pumpAndSettle();
    }
    expect(
      find.byKey(PredictionsHomeTabletPage.contentKey),
      findsOneWidget,
      reason: 'Trang vẫn render sau khi đổi qua mọi filter tab.',
    );
  });

  testWidgets('SC-210 breaking: đổi tab, bấm mover mở chi tiết sự kiện', (
    tester,
  ) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictionsBreaking);

    await tester.tap(find.byKey(PredictionsBreakingTabletPage.cryptoTabKey));
    await tester.pumpAndSettle();

    final mover = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('sc210_mover_'),
    );
    await tester.scrollUntilVisible(
      mover.first,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(mover.first);
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsBreakingTabletPage.contentKey),
      findsNothing,
      reason: 'Bấm mover phải mở trang chi tiết sự kiện.',
    );
  });

  testWidgets('SC-222 tournaments: đổi tab ended, mở chi tiết giải đấu', (
    tester,
  ) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictionsTournaments);

    await tester.tap(find.byKey(PredictionTournamentsTabletPage.endedTabKey));
    await tester.pumpAndSettle();

    final card = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('sc222_tournament_'),
    );
    await tester.scrollUntilVisible(
      card.first,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(card.first);
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionTournamentsTabletPage.contentKey),
      findsNothing,
      reason: 'Bấm giải đấu phải mở trang chi tiết giải.',
    );
  });

  testWidgets(
    'SC-209 search: từ khóa vô kết quả render empty-state + bấm Biến động',
    (tester) async {
      await pumpPage(tester, AppRoutePaths.marketsPredictionsSearch);

      await tester.enterText(
        find.byKey(PredictionsSearchTabletPage.searchFieldKey),
        'zzzz-khong-co-ket-qua',
      );
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy sự kiện'), findsOneWidget);

      await tester.tap(find.text('Xem Biến động'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(PredictionsSearchTabletPage.contentKey),
        findsNothing,
        reason: 'Xem Biến động phải mở trang breaking.',
      );
    },
  );

  testWidgets('SC-208 home: hero Vị thế của tôi mở danh mục', (tester) async {
    await pumpPage(tester, AppRoutePaths.marketsPredictions);

    await tester.tap(find.byKey(PredictionsHomeTabletPage.myPredictionsKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsHomeTabletPage.contentKey),
      findsNothing,
      reason: 'Hero Vị thế của tôi phải mở trang danh mục.',
    );
  });

  testWidgets(
    'SC-209 search: empty-state có bộ lọc active hiện nút Xóa bộ lọc',
    (tester) async {
      await pumpPage(tester, AppRoutePaths.marketsPredictionsSearch);

      final toggleFinder = find.byKey(
        PredictionsSearchTabletPage.filtersToggleKey,
      );
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();
      final toggle = tester.getRect(toggleFinder);
      await tester.tapAt(toggle.center);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(PredictionsSearchTabletPage.statusResolvedKey),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(PredictionsSearchTabletPage.searchFieldKey),
        'zzzz-khong-co-ket-qua',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Xóa bộ lọc').last);
      await tester.pumpAndSettle();
      expect(
        find.byKey(PredictionsSearchTabletPage.statusAllKey),
        findsOneWidget,
        reason: 'Xóa bộ lọc từ empty-state phải reset trạng thái về Tất cả.',
      );
    },
  );
}
