import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_portfolio_analyzer_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Gate test Cụm C (redesign 2026-09-17): 4 màn danh mục/phân tích lên
/// workspace 2 cột — panel phải tồn tại ở tầng rộng, biến mất ở tầng hẹp
/// (portrait), nội dung chính không vỡ.
void main() {
  Future<void> pumpAt(
    WidgetTester tester,
    String location, {
    Size size = const Size(1280, 900),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
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

  testWidgets('SC-212 danh mục: hero + tabs cột chính, panel lệnh mở/Arena', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsPortfolio);

    expect(
      find.byKey(PredictionsPortfolioTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Danh mục prediction'), findsOneWidget);
    expect(find.text('Đang mở'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-212 hẹp: một cột, không panel', (tester) async {
    await pumpAt(
      tester,
      AppRoutePaths.marketsPredictionsPortfolio,
      size: const Size(800, 1280),
    );

    expect(
      find.byKey(PredictionsPortfolioTabletPage.controlPaneKey),
      findsNothing,
    );
    expect(find.text('Danh mục prediction'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-218 phân tích: tabs cột chính + panel chỉ số nhanh', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsPortfolioAnalyzer);

    expect(
      find.byKey(PredictionPortfolioAnalyzerTabletPage.statsPaneKey),
      findsOneWidget,
    );
    expect(find.text('Chỉ số nhanh'), findsOneWidget);
    // Tab active + nhãn section Tổng quan (khuôn như tab Hiệu suất/Rủi ro).
    expect(find.text('Tổng quan'), findsNWidgets(2));

    await tester.tap(
      find.byKey(PredictionPortfolioAnalyzerTabletPage.riskTabKey),
    );
    await tester.pumpAndSettle();
    // Panel chỉ số nhanh vẫn hiện khi sang tab Rủi ro (ghim).
    expect(find.text('Chỉ số nhanh'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'SC-218 Tổng quan: 3 khối cách nhau đúng 8dp (khóa tái phạm gap 0dp)',
    (tester) async {
      await pumpAt(tester, AppRoutePaths.marketsPredictionsPortfolioAnalyzer);

      final summary = tester.getRect(
        find.widgetWithText(VitCard, 'Tóm tắt danh mục'),
      );
      final statsRow = tester.getRect(
        find.byKey(PredictionPortfolioAnalyzerTabletPage.statsRowKey),
      );
      final firstCategory = tester.getRect(
        find.byKey(PredictionPortfolioAnalyzerTabletPage.firstCategoryKey),
      );

      // Card trong CÙNG section = item/compact role x3 = 8dp (mặc định tight
      // của VitPageSection, như 2 tab Hiệu suất/Rủi ro); sibling 12 là gap
      // GIỮA các section do workspace cấp. Từng bị 0dp khi tab là Column
      // trần (đo pixel emulator 2026-09-18).
      expect(statsRow.top - summary.bottom, moreOrLessEquals(8, epsilon: .1));
      expect(
        firstCategory.top - statsRow.bottom,
        moreOrLessEquals(8, epsilon: .1),
      );
    },
  );

  testWidgets('SC-214 BXH: podium + bảng cột chính, panel lọc phải', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsLeaderboard);

    expect(
      find.byKey(PredictionsLeaderboardTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Bảng xếp hạng'), findsOneWidget);
    expect(find.text('Xếp theo P/L'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-215 hoạt động: bảng tin cột chính, panel stats + lọc tiền', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsActivity);

    expect(
      find.byKey(PredictionsGlobalActivityTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Bảng tin trực tiếp'), findsOneWidget);
    expect(find.text('Khối lượng 24h'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
