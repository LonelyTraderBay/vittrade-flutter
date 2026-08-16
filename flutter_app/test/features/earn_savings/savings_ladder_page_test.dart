import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLadder(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsLadder,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-351 mock repository exposes savings ladder BE draft', () async {
    final snapshot = await const MockSavingsLadderRepository().getLadder();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-ladder');
    expect(snapshot.actionDraft, contains('ladder/create'));
    expect(snapshot.title, 'Maturity Ladder');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Xây dựng',
      'Timeline',
      'Phân tích',
    ]);
    expect(snapshot.defaultAmountUsd, 10000);
    expect(snapshot.defaultPreset, SavingsLadderPreset.monthly);
    expect(snapshot.quickAmounts, contains(25000));
    expect(snapshot.templates, hasLength(4));
    expect(snapshot.availableProducts, isNotEmpty);
    expect(snapshot.contractNotes, contains('rung schedule'));
    expect(snapshot.supportedStates, contains(EarnScreenState.success));
  });

  testWidgets('SC-351 renders ladder builder baseline', (tester) async {
    await pumpLadder(tester);

    expect(find.byType(SavingsLadderPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Maturity Ladder'), findsOneWidget);
    expect(find.byKey(SavingsLadderPage.summaryKey), findsOneWidget);
    expect(find.text('Staggered Maturity Builder'), findsOneWidget);
    expect(find.text('\$10,000.00'), findsOneWidget);
    expect(find.text('Tổng vốn (USD)'), findsOneWidget);
    expect(
      find.byKey(SavingsLadderPage.presetKey(SavingsLadderPreset.monthly)),
      findsOneWidget,
    );
    expect(find.byKey(SavingsLadderPage.rungsKey), findsOneWidget);
    expect(find.text('Các bậc ladder (3)'), findsOneWidget);
  });

  testWidgets('SC-351 first viewport reaches amount action chips', (
    tester,
  ) async {
    await pumpLadder(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-351 SavingsLadderPage',
      semanticLabel: 'Thang đáo hạn tiết kiệm',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(SavingsLadderPage.amountChipKey(25000)),
      targetLabel: 'the ladder amount action chips',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-351 changes amount, preset, and confirm count', (
    tester,
  ) async {
    await pumpLadder(tester);

    await tester.tap(find.byKey(SavingsLadderPage.amountChipKey(25000)));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(SavingsLadderPage.presetKey(SavingsLadderPreset.quarterly)),
    );
    await tester.pumpAndSettle();

    expect(find.text('\$25,000.00'), findsOneWidget);
    expect(find.text('Đáo hạn theo quý'), findsOneWidget);
    expect(find.text('Các bậc ladder (4)'), findsOneWidget);

    final confirm = find.byKey(SavingsLadderPage.confirmKey);
    await Scrollable.ensureVisible(tester.element(confirm), alignment: .82);
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận Ladder · 4 bậc'), findsOneWidget);
  });

  testWidgets('SC-351 timeline and analysis tabs render state', (tester) async {
    await pumpLadder(tester);

    await tester.tap(find.text('Timeline'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsLadderPage.timelineKey), findsOneWidget);
    expect(find.text('Lịch đáo hạn'), findsOneWidget);
    expect(find.text('Dự kiến dòng tiền'), findsOneWidget);

    await tester.tap(find.text('Phân tích'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsLadderPage.analysisKey), findsOneWidget);
    expect(find.text('Phân bổ theo tài sản'), findsOneWidget);
    expect(find.text('Đánh giá thanh khoản'), findsOneWidget);
  });

  testWidgets(
    'SC-351 empty tab CTA switches from timeline back to builder tab',
    (tester) async {
      await pumpLadder(tester);

      // Move to the custom preset, then remove every rung so the
      // timeline/analysis tabs render EmptyTab.
      final customPreset = find.byKey(
        SavingsLadderPage.presetKey(SavingsLadderPreset.custom),
      );
      await Scrollable.ensureVisible(tester.element(customPreset));
      await tester.pumpAndSettle();
      await tester.tap(customPreset);
      await tester.pumpAndSettle();

      while (find.byTooltip('Xóa bậc').evaluate().isNotEmpty) {
        final deleteButton = find.byTooltip('Xóa bậc').first;
        await Scrollable.ensureVisible(tester.element(deleteButton));
        await tester.pumpAndSettle();
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
      }
      expect(find.text('Chưa có bậc ladder'), findsOneWidget);

      final timelineTab = find.text('Timeline');
      await Scrollable.ensureVisible(tester.element(timelineTab));
      await tester.pumpAndSettle();
      await tester.tap(timelineTab);
      await tester.pumpAndSettle();

      expect(find.text('Chưa có bậc nào'), findsOneWidget);
      final cta = find.text('Bắt đầu xây');
      expect(cta, findsOneWidget);
      await Scrollable.ensureVisible(tester.element(cta));
      await tester.pumpAndSettle();
      await tester.tap(cta);
      await tester.pumpAndSettle();

      // Back on the builder tab: builder-only content is visible again and
      // the timeline-only empty state is gone.
      expect(find.text('Tổng vốn (USD)'), findsOneWidget);
      expect(find.text('Chiến lược ladder'), findsOneWidget);
      expect(find.text('Chưa có bậc nào'), findsNothing);
    },
  );

  testWidgets(
    'SC-351 empty tab CTA switches from analysis back to builder tab',
    (tester) async {
      await pumpLadder(tester);

      // Move to the custom preset, then remove every rung so the
      // timeline/analysis tabs render EmptyTab.
      final customPreset = find.byKey(
        SavingsLadderPage.presetKey(SavingsLadderPreset.custom),
      );
      await Scrollable.ensureVisible(tester.element(customPreset));
      await tester.pumpAndSettle();
      await tester.tap(customPreset);
      await tester.pumpAndSettle();

      while (find.byTooltip('Xóa bậc').evaluate().isNotEmpty) {
        final deleteButton = find.byTooltip('Xóa bậc').first;
        await Scrollable.ensureVisible(tester.element(deleteButton));
        await tester.pumpAndSettle();
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
      }
      expect(find.text('Chưa có bậc ladder'), findsOneWidget);

      final analysisTab = find.text('Phân tích');
      await Scrollable.ensureVisible(tester.element(analysisTab));
      await tester.pumpAndSettle();
      await tester.tap(analysisTab);
      await tester.pumpAndSettle();

      expect(find.text('Tạo ladder để xem phân tích'), findsOneWidget);
      final cta = find.text('Bắt đầu xây');
      expect(cta, findsOneWidget);
      await Scrollable.ensureVisible(tester.element(cta));
      await tester.pumpAndSettle();
      await tester.tap(cta);
      await tester.pumpAndSettle();

      // Back on the builder tab: builder-only content is visible again and
      // the analysis-only empty state is gone.
      expect(find.text('Tổng vốn (USD)'), findsOneWidget);
      expect(find.text('Chiến lược ladder'), findsOneWidget);
      expect(find.text('Tạo ladder để xem phân tích'), findsNothing);
    },
  );

  testWidgets('SC-351 savings insight edge opens ladder page', (tester) async {
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

    final ladderInsight = find.byKey(SavingsPage.ladderInsightKey);
    await Scrollable.ensureVisible(
      tester.element(ladderInsight),
      alignment: .65,
    );
    await tester.pumpAndSettle();
    await tester.tap(ladderInsight);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsLadderPage), findsOneWidget);
  });
}
