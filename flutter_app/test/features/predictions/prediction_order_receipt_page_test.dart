import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_order_receipt_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpReceipt(WidgetTester tester, String receiptId) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionReceipt(receiptId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-035 mock repository exposes the order receipt BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final missing = await repo.getOrderReceipt('p2p001');
    final found = await repo.getOrderReceipt('po-1');

    expect(missing.receiptId, 'p2p001');
    expect(missing.found, isFalse);
    expect(missing.receipt, isNull);
    expect(missing.orders, hasLength(3));
    expect(missing.receipts, hasLength(6));
    expect(missing.rewards, isNotEmpty);
    expect(missing.lastUpdatedLabel, 'realtime-refresh');
    expect(
      missing.supportedStates,
      containsAll([
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      ]),
    );

    expect(found.found, isTrue);
    expect(found.receipt?.id, 'po-1');
    expect(found.receipt?.timeline, hasLength(3));
    expect(found.event?.id, 'pred-1');
  });

  testWidgets('SC-035 renders the Flutter missing receipt state', (
    tester,
  ) async {
    await pumpReceipt(tester, 'p2p001');

    expect(find.byType(PredictionOrderReceiptPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Chi tiết lệnh'), findsOneWidget);
    expect(find.text('Biên lai · phí · tiến trình'), findsOneWidget);
    expect(find.text('Không tìm thấy'), findsOneWidget);
    expect(find.text('Lệnh không tồn tại hoặc đã bị xoá'), findsOneWidget);
    expect(find.text('Prediction Receipt'), findsNothing);
    expect(find.text('Xem sự kiện'), findsNothing);
  });

  testWidgets('SC-035 renders a valid mock receipt for portfolio edges', (
    tester,
  ) async {
    await pumpReceipt(tester, 'po-1');

    expect(find.byType(PredictionOrderReceiptPage), findsOneWidget);
    expect(find.text('Chi tiết lệnh'), findsOneWidget);
    expect(find.text('Tổng quan lệnh'), findsOneWidget);
    expect(find.text('Tiến trình'), findsOneWidget);
    expect(find.text('PO-1'), findsOneWidget);
    expect(find.text('Đã gửi'), findsOneWidget);
    expect(find.text('Chia sẻ chi tiết lệnh'), findsOneWidget);
  });

  testWidgets('SC-035 first viewport reaches fee summary', (tester) async {
    await pumpReceipt(tester, 'po-1');

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-035 PredictionOrderReceiptPage',
      semanticLabel: 'Chi tiết lệnh dự đoán: biên lai, phí và tiến trình',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionOrderReceiptPage.feeSummaryKey),
      targetLabel: 'the prediction receipt fee summary',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-035 share receipt button shows a coming-soon notice sheet', (
    tester,
  ) async {
    await pumpReceipt(tester, 'po-1');

    await tester.ensureVisible(find.byKey(PredictionOrderReceiptPage.shareKey));
    await tester.tap(find.byKey(PredictionOrderReceiptPage.shareKey));
    await tester.pumpAndSettle();

    expect(find.text('Chia sẻ chi tiết lệnh sẽ sớm ra mắt.'), findsOneWidget);
  });

  testWidgets('SC-035 receipt navigation edges are wired safely', (
    tester,
  ) async {
    await pumpReceipt(tester, 'po-1');

    await tester.ensureVisible(
      find.byKey(PredictionOrderReceiptPage.viewEventKey),
    );
    await tester.tap(find.byKey(PredictionOrderReceiptPage.viewEventKey));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(
      find.text('Bitcoin reaches \$150K before July 2026?'),
      findsOneWidget,
    );

    await pumpReceipt(tester, 'po-1');
    await tester.ensureVisible(
      find.byKey(PredictionOrderReceiptPage.viewPortfolioKey),
    );
    await tester.tap(find.byKey(PredictionOrderReceiptPage.viewPortfolioKey));
    await tester.pumpAndSettle();
    expect(find.text('Prediction Portfolio'), findsOneWidget);
  });
}
