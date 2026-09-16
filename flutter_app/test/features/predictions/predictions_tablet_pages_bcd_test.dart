import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_market_maker_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_portfolio_analyzer_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_risk_calculator_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
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

  testWidgets('SC-208 tablet home renders full hub + filter state', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictions);

    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
    expect(find.text('Dự đoán thị trường'), findsOneWidget);
    expect(find.text('Vị thế của tôi'), findsOneWidget);
    expect(find.text('Xu hướng'), findsOneWidget);
    expect(find.text('Tất cả'), findsWidgets);
    expect(find.text('Biến động 24h'), findsWidgets);
    expect(find.text('Thử thách cùng chủ đề'), findsOneWidget);
    expect(find.text('Công cụ dự đoán'), findsOneWidget);
    expect(
      find.byKey(PredictionsHomeTabletPage.trendingFilterKey),
      findsOneWidget,
    );

    // Lọc "Mới" chạy stateful — vẫn cùng trang, đổi bộ tab.
    await tester.tap(find.byKey(PredictionsHomeTabletPage.newFilterKey));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-209 tablet search renders filter section and results', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsSearch);

    expect(find.text('Tìm sự kiện'), findsOneWidget);
    expect(find.text('Sắp xếp'), findsOneWidget);
    expect(find.text('Trạng thái'), findsOneWidget);
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Đang mở'), findsOneWidget);
    expect(find.textContaining('Tìm thấy'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-210 tablet breaking renders summary and movers', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsBreaking);

    expect(find.text('Biến động'), findsOneWidget);
    expect(find.text('Biến động 24h'), findsOneWidget);
    expect(find.textContaining('tăng'), findsWidgets);
    expect(find.text('Nhận báo cáo biến động 24h'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-212 tablet portfolio renders tabs and hero summary', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsPortfolio);

    expect(find.text('Danh mục prediction'), findsOneWidget);
    expect(find.text('Đang mở'), findsOneWidget);
    expect(find.text('Đã đóng'), findsOneWidget);
    expect(find.text('Lịch sử'), findsOneWidget);
    expect(find.textContaining('Khám phá Arena'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-216 tablet risk calculator computes live metrics', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionsRiskCalculator,
    );

    expect(find.byType(PredictionRiskCalculatorTabletPage), findsOneWidget);
    expect(find.text('Thông tin vị thế'), findsOneWidget);
    expect(find.text('Tóm tắt vị thế'), findsOneWidget);
    expect(find.text('Phân tích rủi ro'), findsOneWidget);
    expect(find.text('Tối đa mất'), findsOneWidget);
    expect(find.text('Định cỡ vị thế theo Kelly'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionRiskCalculatorTabletPage.scenariosTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Thắng (Yes chốt)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-217 tablet market maker renders provide form', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsMarketMaker);

    expect(find.byType(PredictionMarketMakerTabletPage), findsOneWidget);
    expect(find.text('Thêm thanh khoản'), findsWidgets);
    expect(find.text('Spread (basis points)'), findsOneWidget);
    expect(find.text('Người cung cấp thanh khoản'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-218 tablet portfolio analyzer renders overview', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
    );

    expect(find.byType(PredictionPortfolioAnalyzerTabletPage), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('Hiệu suất'), findsWidgets);
    expect(find.text('Rủi ro'), findsOneWidget);
    expect(find.text('Tóm tắt danh mục'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-214 tablet leaderboard renders podium and metric switch', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsLeaderboard);

    expect(find.byType(PredictionsLeaderboardTabletPage), findsOneWidget);
    expect(find.text('Bảng xếp hạng'), findsOneWidget);
    expect(find.text('P/L'), findsOneWidget);
    expect(find.text('Khối lượng'), findsOneWidget);
    expect(find.text('Thắng lớn nhất'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionsLeaderboardTabletPage.volumeMetricKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xếp theo khối lượng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-215 tablet global activity renders stats and amount filter', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsActivity);

    expect(find.text('Hoạt động toàn cục'), findsOneWidget);
    expect(find.text('Lệnh mua'), findsOneWidget);
    expect(find.text('Lệnh bán'), findsOneWidget);
    expect(find.text('Bảng tin trực tiếp'), findsOneWidget);
    expect(find.text(r'$100+'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-213 tablet rewards renders hero and table', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsRewards);

    expect(find.text('Phần thưởng'), findsOneWidget);
    expect(find.text('Quỹ thưởng hàng ngày'), findsOneWidget);
    expect(find.text('Cơ hội kiếm thưởng'), findsOneWidget);
    expect(find.text('SPREAD TỐI ĐA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-219 tablet calendar renders months timeline', (tester) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionsEventCalendar,
    );

    expect(find.text('Lịch sự kiện'), findsOneWidget);
    expect(find.textContaining('Tháng'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-220 tablet social renders sentiment and comments', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsSocial);

    expect(find.text('Cộng đồng'), findsOneWidget);
    expect(find.text('Sentiment cộng đồng'), findsOneWidget);
    expect(find.text('Bình luận'), findsOneWidget);
    expect(find.text('Đóng góp nổi bật'), findsOneWidget);
    expect(find.text('Chia sẻ phân tích'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-221 tablet advanced chart renders series and indicators', (
    tester,
  ) async {
    final eventId = 'pred-1';
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionsAdvancedChart(eventId),
    );

    expect(find.text('Biểu đồ nâng cao'), findsOneWidget);
    expect(find.text('Giá · MA7 · MA25'), findsOneWidget);
    expect(find.text('Dòng lệnh mua/bán'), findsOneWidget);
    expect(find.text('Tín hiệu chỉ báo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-222/223 tablet tournaments list and detail render', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictionsTournaments);

    expect(find.text('Giải đấu'), findsOneWidget);
    expect(find.text('Đang diễn ra'), findsWidgets);
    expect(find.text('Đã kết thúc'), findsOneWidget);
    expect(find.text('Thống kê nhanh'), findsOneWidget);

    await tester.tap(find.text('Crypto Masters Q1 2026').first);
    await tester.pumpAndSettle();
    expect(find.text('Bảng xếp hạng giải đấu'), findsOneWidget);
    expect(find.text('Tham gia giải đấu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('drill-down pages có nút back và pop về trang trước', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictions);

    // Home -> BXH (chip Công cụ) = push -> header BXH có nút back.
    await tester.scrollUntilVisible(
      find.text('BXH'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('BXH').first);
    await tester.pumpAndSettle();
    expect(find.text('Bảng xếp hạng'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);

    // Back pop đúng tầng: quay về trang chủ Dự đoán.
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-224 tablet data integration renders sources and keys', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionsDataIntegration,
    );

    expect(find.text('Tích hợp dữ liệu'), findsOneWidget);
    expect(find.text('Nguồn dữ liệu'), findsOneWidget);
    expect(find.text('Khóa API'), findsOneWidget);
    expect(find.text('Webhook'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
