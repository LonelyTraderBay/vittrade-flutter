import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_event_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_order_receipt_tablet_page.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

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

  testWidgets('SC-211 tablet renders the full re-composed detail', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionEvent('pred-1'),
    );

    expect(find.byType(PredictionEventDetailTabletPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
    expect(
      find.text('Bitcoin reaches \$150K before July 2026?'),
      findsOneWidget,
    );
    expect(find.text('Vị thế của bạn'), findsOneWidget);
    expect(find.text('Giá / Xác suất'), findsOneWidget);
    expect(find.text('Sổ lệnh'), findsOneWidget);
    expect(find.text('Đặt lệnh'), findsOneWidget);
    expect(find.text('Order Preview'), findsOneWidget);
    expect(find.text('Quy tắc'), findsWidgets);
    expect(find.text('Thị trường liên quan'), findsOneWidget);
    expect(find.text('Mở Arena trên cùng chủ đề'), findsOneWidget);
    expect(find.text('Phần thưởng hàng ngày'), findsOneWidget);
    expect(find.text('Hoạt động toàn cục'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-211 tablet order book and tabs switch locally', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionEvent('pred-1'),
    );

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailTabletPage.orderBookToggleKey),
    );
    await tester.tap(
      find.byKey(PredictionEventDetailTabletPage.orderBookToggleKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('GIÁ'), findsOneWidget);
    expect(find.text('CỔ PHẦN'), findsOneWidget);
    expect(find.text('TỔNG'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(PredictionEventDetailTabletPage.commentsTabKey),
    );
    await tester.tap(
      find.byKey(PredictionEventDetailTabletPage.commentsTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Thêm bình luận…'), findsOneWidget);

    await tester.tap(find.byKey(PredictionEventDetailTabletPage.holdersTabKey));
    await tester.pumpAndSettle();
    expect(find.text('AlphaDesk'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionEventDetailTabletPage.activityTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Trader A'), findsOneWidget);
  });

  testWidgets(
    'SC-211 tablet confirm sheet gates the ERR-36 submit and navigates receipt',
    (tester) async {
      await pumpTabletRoute(
        tester,
        AppRoutePaths.marketsPredictionEvent('pred-1'),
      );

      await tester.scrollUntilVisible(
        find.text(r'$25'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(r'$25'));
      await tester.pumpAndSettle();

      final cta = find.text('Xem trước & xác nhận');
      await tester.scrollUntilVisible(
        cta,
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(cta);
      await tester.pumpAndSettle();

      // Financial Safety: sheet tổng hợp phí/rủi ro trước khi chạm máy trạng thái.
      expect(find.byType(VitSheetPanel), findsOneWidget);
      expect(find.text('Xác nhận lệnh dự đoán'), findsOneWidget);
      expect(find.text('Tối đa mất'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.byType(PredictionOrderReceiptTabletPage), findsNothing);

      await tester.tap(find.text('Xác nhận mua'));
      // Mock loadDelay 300ms — pumpAndSettle flush timer + điều hướng biên lai.
      await tester.pumpAndSettle();

      expect(find.byType(PredictionOrderReceiptTabletPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-225 tablet renders the full receipt composition', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionReceipt('po-1'),
    );

    expect(find.byType(PredictionOrderReceiptTabletPage), findsOneWidget);
    expect(find.text('Chi tiết lệnh'), findsOneWidget);
    expect(find.text('Tổng quan lệnh'), findsOneWidget);
    expect(find.text('Tiến trình khớp'), findsOneWidget);
    expect(find.text('Tiến trình'), findsOneWidget);
    expect(find.text('Mã lệnh'), findsOneWidget);
    expect(find.text('Chia sẻ chi tiết lệnh'), findsOneWidget);
    expect(find.text('Xem sự kiện'), findsOneWidget);
    expect(find.text('Xem danh mục'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-225 tablet renders the missing receipt state', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      AppRoutePaths.marketsPredictionReceipt('p2p001'),
    );

    expect(find.byType(PredictionOrderReceiptTabletPage), findsOneWidget);
    expect(find.text('Không tìm thấy'), findsOneWidget);
    expect(find.text('Lệnh không tồn tại hoặc đã bị xoá'), findsOneWidget);
  });
}
