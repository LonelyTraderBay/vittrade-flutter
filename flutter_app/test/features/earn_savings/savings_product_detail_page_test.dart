import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_product_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpProductDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsProductSample,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-330 mock repository exposes product-detail BE draft', () async {
    final snapshot = await const MockSavingsProductDetailRepository()
        .getProductDetail(productId: 'sample');

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-product-sample');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.productId, 'sample');
    expect(snapshot.product, isNull);
    expect(snapshot.title, 'Sản phẩm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.notFoundMessage, 'Không tìm thấy sản phẩm');
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-330 renders savings product not-found baseline', (
    tester,
  ) async {
    await pumpProductDetail(tester);

    expect(find.byType(SavingsProductDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Sản phẩm'), findsOneWidget);
    expect(find.text('Không tìm thấy sản phẩm'), findsOneWidget);
    expect(find.text('Quay lại'), findsOneWidget);
  });

  testWidgets('SC-330 back CTA returns to savings overview', (tester) async {
    await pumpProductDetail(tester);

    await tester.tap(find.byKey(SavingsProductDetailPage.backButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });

  // Coverage dòng 2 p3e: trạng thái dữ liệu thật với id 'sav001' (mock getSavings.products)
  // (test cũ chỉ phủ not-found qua id sample).
  testWidgets('SC-330 render chi tiết sản phẩm thật', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Route chỉ đăng ký path sample với id cứng — pump trực tiếp widget
    // với id thật để phủ nhánh dữ liệu (khuôn launchpad contract page).
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SavingsProductDetailPage(productId: 'sav001')),
      ),
    );
    // Mock delay 250ms KHÔNG phải frame — pumpAndSettle không chờ nó;
    // pump thời gian thực để Future.delayed hoàn thành rồi settle.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsProductDetailPage), findsOneWidget);
    expect(find.byType(VitSkeletonList), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3h: nhánh loading + error product detail.
  testWidgets('SC-330 loading qua override', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Pump widget trực tiếp (route chỉ đăng ký id cứng 'sample').
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          savingsProductDetailSnapshotProvider('sav001').overrideWith(
            (ref) => Completer<SavingsProductDetailSnapshot>().future,
          ),
        ],
        child: const MaterialApp(
          home: SavingsProductDetailPage(productId: 'sav001'),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Đang tải…'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // Error ở test riêng — ProviderScope container không đổi override giữa 2
  // lần pumpWidget trong cùng test.
  testWidgets('SC-330 error qua override', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          savingsProductDetailSnapshotProvider(
            'sav001',
          ).overrideWith((ref) async => throw StateError('lỗi mạng')),
        ],
        child: const MaterialApp(
          home: SavingsProductDetailPage(productId: 'sav001'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Không tải được'), findsAtLeastNWidgets(1));
    expect(find.text('Thử lại'), findsOneWidget);
  });
}
