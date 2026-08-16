import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/ex_ante_costs_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/ex_post_costs_report_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpExPostReport(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.tradeCopyExPostCostsReport,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-107 mock repository exposes ex-post costs BE draft', () async {
    final repo = const MockTradeRegulatoryRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getExPostCostsReport();
    final report = snapshot.reportForYear(2025);
    final export = await repo.createExPostCostsReportExport(year: 2025);

    expect(report.totalActual, 455);
    expect(report.totalEstimated, 450);
    expect(report.variance, 5);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-ex-post-costs-report',
    );
    expect(snapshot.actionDraft, contains('POST /exports'));
    expect(export.status, 'ready');
    expect(export.downloadUrl, '/exports/ex-post-cost-report-2025.pdf');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-107 renders ex-post costs report in Trade shell', (
    tester,
  ) async {
    await pumpExPostReport(tester);

    expect(find.byType(ExPostCostsReportPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Ex-Post Cost Report'), findsOneWidget);
    expect(find.text('Annual Actual Costs'), findsOneWidget);
    expect(find.text('Annual Cost Report Available'), findsOneWidget);
    expect(find.text('€455'), findsOneWidget);
    expect(find.text('€450'), findsOneWidget);
    expect(find.text('Actual vs. Estimated'), findsOneWidget);
    expect(find.text('+€5'), findsOneWidget);
  });

  testWidgets('SC-107 switches yearly report tabs', (tester) async {
    await pumpExPostReport(tester);

    await tester.tap(find.byKey(ExPostCostsReportPage.tabKey(2024)));
    await tester.pumpAndSettle();

    expect(find.text('€401'), findsOneWidget);
    expect(find.text('€420'), findsOneWidget);
    expect(find.text('-€19'), findsOneWidget);
  });

  testWidgets('SC-107 first viewport reaches the first cost row', (
    tester,
  ) async {
    await pumpExPostReport(tester);

    expectFirstViewportVisible(
      tester,
      find.text('One-off Costs'),
      targetLabel: 'the first ex-post cost breakdown row',
      minVisibleHeight: 20,
    );
  });

  testWidgets('SC-105 ex-post quick link opens SC-107 route', (tester) async {
    await pumpExPostReport(
      tester,
      initialLocation: AppRoutePaths.tradeCopyExAnteCosts,
    );

    await tester.drag(
      find.byKey(ExAnteCostsPage.contentKey),
      const Offset(0, -760),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExAnteCostsPage.exPostKey));
    await tester.pumpAndSettle();

    expect(find.byType(ExPostCostsReportPage), findsOneWidget);
    expect(find.text('Ex-Post Cost Report'), findsOneWidget);
  });
}
