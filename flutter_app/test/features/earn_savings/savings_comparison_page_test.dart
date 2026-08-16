import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_comparison_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpComparison(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsComparison,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-340 mock repository exposes comparison BE draft', () async {
    final snapshot = await const MockSavingsComparisonRepository()
        .getComparison();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-comparison');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'So sánh sản phẩm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.defaultProductIds, ['sav001', 'sav002']);
    expect(snapshot.maxCompare, 3);
    expect(snapshot.products, hasLength(7));
    expect(snapshot.details.keys, containsAll(['sav001', 'sav002', 'sav003']));
    expect(snapshot.details['sav001']?.earlyWithdrawal, 'Bất kỳ lúc nào');
    expect(snapshot.details['sav002']?.capacityPercent, 90);
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-340 renders comparison baseline', (tester) async {
    await pumpComparison(tester);

    expect(find.byType(SavingsComparisonPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('So sánh sản phẩm'), findsOneWidget);
    expect(find.text('Sản phẩm đã chọn'), findsOneWidget);
    expect(
      find.byKey(SavingsComparisonPage.productChipKey('sav001')),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsComparisonPage.productChipKey('sav002')),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsComparisonPage.addProductButtonKey),
      findsOneWidget,
    );
    expect(find.text('Thêm sản phẩm (2/3)'), findsOneWidget);
    expect(find.text('So sánh chi tiết'), findsOneWidget);
    expect(
      find.byKey(SavingsComparisonPage.comparisonTableKey),
      findsOneWidget,
    );
    expect(find.text('APY'), findsOneWidget);
    expect(find.text('4.5%'), findsOneWidget);
    expect(find.text('7.2%'), findsOneWidget);
    expect(find.text('Rút sớm'), findsOneWidget);
    expect(find.text('Bất kỳ lúc nào'), findsOneWidget);
    expect(find.text('Mất toàn bộ lãi'), findsOneWidget);
    expect(find.text('Tính năng nổi bật'), findsOneWidget);
    expect(find.byKey(SavingsComparisonPage.disclaimerKey), findsOneWidget);
  });

  testWidgets('SC-340 picker adds a third product', (tester) async {
    await pumpComparison(tester);

    await tester.tap(find.byKey(SavingsComparisonPage.addProductButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Chọn sản phẩm so sánh'), findsOneWidget);
    expect(
      find.byKey(SavingsComparisonPage.pickerOptionKey('sav003')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(SavingsComparisonPage.pickerOptionKey('sav003')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsComparisonPage.productChipKey('sav003')),
      findsOneWidget,
    );
    expect(find.text('USDT Cố định 90D'), findsWidgets);
    expect(find.byKey(SavingsComparisonPage.addProductButtonKey), findsNothing);
  });

  testWidgets('SC-340 remove product falls back to comparison empty state', (
    tester,
  ) async {
    await pumpComparison(tester);

    await tester.tap(
      find.byKey(SavingsComparisonPage.removeProductKey('sav002')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsComparisonPage.productChipKey('sav001')),
      findsOneWidget,
    );
    expect(find.byKey(SavingsComparisonPage.emptyStateKey), findsOneWidget);
    expect(find.text('Chọn ít nhất 2 sản phẩm'), findsOneWidget);
  });

  testWidgets('SC-340 header back returns to savings overview', (tester) async {
    await pumpComparison(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
