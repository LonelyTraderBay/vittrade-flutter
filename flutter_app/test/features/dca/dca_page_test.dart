import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/hub/dca_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

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
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.dca),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-169 mock repository exposes DCA BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getDashboard();

    expect(snapshot.endpoint, '/api/mobile/dca/dca');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.overview.currentValueVnd, 3027250000);
    expect(snapshot.overview.totalPlans, 3);
    expect(snapshot.screenState, DcaScreenState.success);
    expect(snapshot.tools.map((tool) => tool.route), [
      AppRoutePaths.dcaPortfolioOptimizer,
      AppRoutePaths.dcaDynamicAmount,
      AppRoutePaths.dcaRebalanceConfig,
      AppRoutePaths.dcaScheduleConfig,
    ]);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
        DcaScreenState.success,
      ]),
    );
  });

  testWidgets('SC-169 renders DCA dashboard with trade nav active', (
    tester,
  ) async {
    await pumpDca(tester);

    expect(find.byType(DCAPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Mua tự động (DCA)'), findsOneWidget);
    expect(find.text('Tổng danh mục DCA (VND)'), findsOneWidget);
    expect(find.text('Công cụ nâng cao'), findsOneWidget);
    expect(find.text('Portfolio Optimizer'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
  });

  testWidgets('SC-169 first viewport reaches first DCA plan', (tester) async {
    await pumpDca(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-169 DCAPage',
      semanticLabel: 'Mua tự động (DCA) – đầu tư định kỳ có kỷ luật',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(DCAPage.planKey('plan-1')),
      targetLabel: 'the first DCA plan card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-169 switches history tab and opens create plan sheet', (
    tester,
  ) async {
    await pumpDca(tester);

    await tester.tap(find.byKey(DCAPage.historyKey));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử danh mục'), findsOneWidget);

    await tester.tap(find.byKey(DCAPage.createPlanKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DCAPage.createSheetKey), findsOneWidget);
    expect(find.text('Tạo kế hoạch DCA'), findsOneWidget);
  });

  testWidgets('SC-169 create plan sheet clears bottom navigation', (
    tester,
  ) async {
    await pumpDca(tester);

    await tester.tap(find.byKey(DCAPage.createPlanKey));
    await tester.pumpAndSettle();

    final sheetRect = tester.getRect(find.byKey(DCAPage.createSheetKey));
    final navRect = tester.getRect(find.byType(VitBottomNav));
    expect(sheetRect.bottom, lessThanOrEqualTo(navRect.top - AppSpacing.x2));
  });

  testWidgets('SC-169 advanced tools open canonical placeholders', (
    tester,
  ) async {
    await pumpDca(tester);

    await tester.ensureVisible(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaPortfolioOptimizer)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaPortfolioOptimizer)),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Portfolio Optimizer'), findsOneWidget);

    await pumpDca(tester);
    await tester.ensureVisible(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaDynamicAmount)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaDynamicAmount)),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Dynamic Amount'), findsOneWidget);

    await pumpDca(tester);
    await tester.ensureVisible(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaRebalanceConfig)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaRebalanceConfig)),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Auto-Rebalance'), findsOneWidget);

    await pumpDca(tester);
    await tester.ensureVisible(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaScheduleConfig)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(DCAPage.toolKey(AppRoutePaths.dcaScheduleConfig)),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Smart Scheduling'), findsOneWidget);
  });
}
