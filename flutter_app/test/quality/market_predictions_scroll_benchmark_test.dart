// Origin: 2e71daab (2026-07-17) - feat(arch-a1+perf): gỡ sạch 2 cycle họ trade + hiệu năng markets — đóng Cụm 3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/phone/market_list_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/hub/predictions_home_page.dart';

/// PERF-HN2 scroll benchmark: fling both Danh sách thị trường (SC-008) and
/// Prediction Markets home (SC-027) and assert (a) no exception surfaces
/// during/after the fling and (b) the number of mounted row widgets stays
/// pinned to a measured, bounded count.
///
/// DRIFT note (2026-07-17, recorded in the batch report — not fixed here,
/// out of PERF-HN2 scope): neither list is virtualized. `MarketListPairList`
/// (market_list_pairs.dart) renders `_MarketPairRow` via a plain `Column`
/// under `.take(8)`, and `PredictionsHomePage`'s event section
/// (predictions_home_events.dart) renders `_PredictionEventCard` via a
/// `for`-loop `Column`, both inside a `SingleChildScrollView` — every row
/// is built eagerly on first frame regardless of scroll offset (there is
/// no `ListView.builder`/`SliverList` here to lazily window). This test
/// therefore cannot prove "only the visible window is built" (Flutter has
/// nothing to virtualize); it instead pins the eagerly-built row count as a
/// regression guard (catches an unbounded data blow-up or a `.take(8)` cap
/// regression) and proves fling scrolling itself does not throw.
int _mountedCountOf(WidgetTester tester, String typeName) {
  return tester
      .widgetList(
        find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == typeName,
        ),
      )
      .length;
}

void main() {
  testWidgets('PERF-HN2 fling Danh sách thị trường keeps mounted row count '
      'bounded and throws nothing', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.markets),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final beforeFling = _mountedCountOf(tester, '_MarketPairRow');

    await tester.fling(
      find.byKey(MarketListPage.contentKey),
      const Offset(0, -600),
      3000,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.fling(
      find.byKey(MarketListPage.contentKey),
      const Offset(0, 600),
      3000,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final afterFling = _mountedCountOf(tester, '_MarketPairRow');

    // Đo thực tế (2026-07-17): mock repository trả 10 cặp, trang cắt
    // `.take(8)` -> 8 `_MarketPairRow` mount trước VÀ sau fling (không
    // đổi, vì Column không lazy). Ghim ngưỡng +2 đệm (<=10) để bắt hồi quy
    // nếu cap `.take(8)` bị gỡ hoặc danh sách bị nhân đôi khi scroll.
    expect(beforeFling, lessThanOrEqualTo(10));
    expect(afterFling, lessThanOrEqualTo(10));
    expect(afterFling, beforeFling);
  });

  testWidgets('PERF-HN2 fling Prediction Markets home keeps mounted row count '
      'bounded and throws nothing', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictions,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final beforeFling = _mountedCountOf(tester, '_PredictionEventCard');

    await tester.fling(
      find.byKey(PredictionsHomePage.contentKey),
      const Offset(0, -800),
      3000,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.fling(
      find.byKey(PredictionsHomePage.contentKey),
      const Offset(0, 800),
      3000,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final afterFling = _mountedCountOf(tester, '_PredictionEventCard');

    // PERF-HN3 (2026-07-18): hub chỉ dựng lát cắt bounded
    // `snapshot.visibleEvents` (cap 8, khuôn markets) — mock trả 12 sự kiện
    // nên đúng 8 card mount trước VÀ sau fling. Ghim <=10 (+2 đệm, đồng
    // nhất markets). Lưu ý: chỉ đếm trong trang predictions nên class
    // trùng tên `_PredictionEventCard` bên discovery không gây nhiễu.
    expect(beforeFling, lessThanOrEqualTo(10));
    expect(afterFling, lessThanOrEqualTo(10));
    expect(afterFling, beforeFling);

    // Chống gỡ cap lặng lẽ: mock 12 > cap 8 nên card "Xem tất cả" PHẢI
    // hiện diện — ai nâng/bỏ cap mà quên đường thoát sẽ đỏ tại đây.
    await tester.fling(
      find.byKey(PredictionsHomePage.contentKey),
      const Offset(0, -800),
      3000,
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsHomePage.viewAllEventsKey),
      findsOneWidget,
      reason:
          'Cap 8 sự kiện ở hub cần card "Xem tất cả" dẫn sang trang tìm '
          'kiếm khi còn sự kiện dư (PERF-HN3).',
    );
  });
}
