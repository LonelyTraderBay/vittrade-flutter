import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_product_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

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
}
