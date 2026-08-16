import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_guide_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_portfolio_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_product_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSavings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavings,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-329 mock repository exposes savings BE draft', () async {
    final snapshot = await const MockSavingsRepository().getSavings();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Tiết kiệm');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.guideRoute, AppRoutePaths.earnSavingsGuide);
    expect(snapshot.productDetailRoute, AppRoutePaths.earnSavingsProductSample);
    expect(snapshot.products, hasLength(7));
    expect(snapshot.positions, hasLength(3));
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-329 renders savings overview baseline', (tester) async {
    await pumpSavings(tester);

    expect(find.byType(SavingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tiết kiệm'), findsOneWidget);
    expect(find.text('\$8,100.86'), findsOneWidget);
    expect(find.text('Sản phẩm'), findsOneWidget);
    expect(find.text('Đăng ký (3)'), findsOneWidget);
    expect(find.text('USDT Linh hoạt'), findsOneWidget);
    expect(find.text('4.5%'), findsOneWidget);
    expect(find.byKey(SavingsPage.toolsSectionKey), findsOneWidget);
    expect(find.byKey(SavingsPage.moreToolsKey), findsOneWidget);
  });

  testWidgets('SC-329 filters products and switches registered tab', (
    tester,
  ) async {
    await pumpSavings(tester);

    final lockedFilter = find.byKey(SavingsPage.filterKey('locked'));
    await Scrollable.ensureVisible(tester.element(lockedFilter), alignment: .5);
    await tester.pumpAndSettle();
    await tester.tap(lockedFilter);
    await tester.pump();
    expect(find.text('USDT Cố định 30D'), findsOneWidget);
    expect(find.text('USDT Linh hoạt'), findsNothing);

    final positionsTab = find.text('Đăng ký (3)');
    await Scrollable.ensureVisible(tester.element(positionsTab), alignment: .5);
    await tester.pumpAndSettle();
    await tester.tap(positionsTab);
    await tester.pump();
    expect(find.text('BTC Cố định 60D'), findsOneWidget);
    expect(find.text('+0.000019 BTC'), findsOneWidget);
  });

  testWidgets('SC-329 product detail edge uses safe placeholder', (
    tester,
  ) async {
    await pumpSavings(tester);

    final detailButton = find.byKey(SavingsPage.productDetailButtonKey);
    await Scrollable.ensureVisible(
      tester.element(detailButton),
      alignment: 0.55,
    );
    await tester.pumpAndSettle();
    await tester.tap(detailButton);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsProductDetailPage), findsOneWidget);
    expect(find.text('Không tìm thấy sản phẩm'), findsOneWidget);
  });

  testWidgets('SC-333 portfolio edge opens migrated savings portfolio', (
    tester,
  ) async {
    await pumpSavings(tester);

    await tester.tap(find.byKey(SavingsPage.portfolioButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPortfolioPage), findsOneWidget);
  });

  testWidgets('SC-335 guide edge opens migrated savings guide', (tester) async {
    await pumpSavings(tester);

    final moreToolsButton = find.byKey(SavingsPage.moreToolsKey);
    await Scrollable.ensureVisible(
      tester.element(moreToolsButton),
      alignment: .55,
    );
    await tester.pumpAndSettle();
    await tester.tap(moreToolsButton);
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsPage.moreToolsSheetKey), findsOneWidget);
    await tester.tap(find.byKey(SavingsPage.guideButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsGuidePage), findsOneWidget);
  });
}
