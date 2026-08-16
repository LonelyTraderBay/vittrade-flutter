import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_dca_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDca(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsDca,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-346 mock repository exposes savings DCA BE draft', () async {
    final snapshot = await const MockSavingsDcaRepository().getDca();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-dca');
    expect(snapshot.actionDraft, contains('POST /dca/plans'));
    expect(snapshot.title, 'DCA Tiết kiệm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), ['Kế hoạch (3)', 'Lịch sử']);
    expect(snapshot.plans, hasLength(3));
    expect(snapshot.executions, hasLength(5));
    expect(snapshot.products, hasLength(3));
    expect(snapshot.totalInvestedUsd, '\$1,420.00');
    expect(snapshot.totalCurrentUsd, '\$1,446.34');
    expect(snapshot.contractNotes, contains('DCA plans'));
    expect(snapshot.supportedStates, contains(EarnScreenState.submitting));
  });

  testWidgets('SC-346 renders savings DCA baseline', (tester) async {
    await pumpDca(tester);

    expect(find.byType(SavingsDCAPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('DCA Tiết kiệm'), findsOneWidget);
    expect(find.byKey(SavingsDCAPage.summaryKey), findsOneWidget);
    expect(find.text('Dollar Cost Averaging'), findsOneWidget);
    expect(find.text('\$1,420.00'), findsOneWidget);
    expect(find.text('\$1,446.34'), findsOneWidget);
    expect(find.text('Kế hoạch (3)'), findsOneWidget);
    expect(find.byKey(SavingsDCAPage.plansListKey), findsOneWidget);
    expect(find.byKey(SavingsDCAPage.planKey('dca-usdt')), findsOneWidget);
    expect(find.text('USDT Linh hoạt'), findsOneWidget);
    expect(find.text('4.5%'), findsOneWidget);
  });

  testWidgets('SC-346 first viewport reaches create DCA action', (
    tester,
  ) async {
    await pumpDca(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-346 SavingsDCAPage',
      semanticLabel: 'DCA Tiết kiệm',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsDCAPage.createPlanKey),
      routeName: 'SC-346 SavingsDCAPage',
      actionLabel: 'the create DCA action',
    );
  });

  testWidgets('SC-346 switches to execution history', (tester) async {
    await pumpDca(tester);

    await tester.tap(find.text('Lịch sử').first);
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsDCAPage.historyListKey), findsOneWidget);
    expect(
      find.byKey(SavingsDCAPage.executionKey('exec-usdt-1')),
      findsOneWidget,
    );
    expect(find.text('Thành công'), findsWidgets);
    expect(find.text('09/03/2026 · APY 4.5%'), findsOneWidget);
  });

  testWidgets('SC-346 create action opens DCA plan sheet', (tester) async {
    await pumpDca(tester);

    await tester.tap(find.byKey(SavingsDCAPage.createPlanKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsDCAPage.createSheetKey), findsOneWidget);
    expect(find.text('Tạo kế hoạch DCA'), findsOneWidget);
    expect(find.text('Xem trước lịch DCA'), findsOneWidget);
  });

  testWidgets('SC-346 header back returns to savings overview', (tester) async {
    await pumpDca(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });

  testWidgets('SC-346 savings insight edge opens DCA screen', (tester) async {
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
    await tester.pumpAndSettle();

    final moreToolsButton = find.byKey(SavingsPage.moreToolsKey);
    await Scrollable.ensureVisible(
      tester.element(moreToolsButton),
      alignment: .55,
    );
    await tester.pumpAndSettle();
    await tester.tap(moreToolsButton);
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsPage.moreToolsSheetKey), findsOneWidget);
    await tester.tap(find.byKey(SavingsPage.dcaInsightKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsDCAPage), findsOneWidget);
  });
}
