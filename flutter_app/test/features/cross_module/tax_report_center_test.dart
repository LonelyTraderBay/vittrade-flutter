import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/cross_module/data/tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/tax_report_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTaxReports(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.taxReports,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-324 mock repository exposes tax report BE draft', () async {
    final snapshot = await const MockTaxReportRepository().getCenter();

    expect(snapshot.endpoint, '/api/mobile/cross-module/tax-reports');
    expect(
      snapshot.exportEndpoint,
      '/api/mobile/cross-module/tax-reports/exports',
    );
    expect(snapshot.actionDraft, 'POST /exports');
    expect(snapshot.title, 'Tax Report Center');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.totalGainLoss, 5955);
    expect(snapshot.totalTransactions, 449);
    expect(snapshot.taxableModules, 4);
    expect(snapshot.reports.length, 3);
    expect(snapshot.contractNotes, contains('Arena Points stay'));
    expect(
      snapshot.supportedStates,
      containsAll([
        TaxReportScreenState.loading,
        TaxReportScreenState.empty,
        TaxReportScreenState.error,
        TaxReportScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-324 renders generate tax report baseline', (tester) async {
    await pumpTaxReports(tester);

    expect(find.byType(TaxReportCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tax Report Center'), findsOneWidget);
    expect(find.text('Tao bao cao'), findsOneWidget);
    expect(find.text('Bao cao'), findsOneWidget);
    expect(find.text('Cai dat'), findsOneWidget);
    expect(find.text('Tax Summary'), findsOneWidget);
    expect(find.text('+\$5,955'), findsOneWidget);
    expect(find.text('449'), findsOneWidget);
    expect(find.text('Tax Period'), findsOneWidget);
    expect(find.text('Spot Trading'), findsOneWidget);
    expect(find.text('Arena Points (Non-taxable)'), findsOneWidget);
    expect(find.text('Export Format'), findsOneWidget);
    expect(find.byKey(TaxReportCenterPage.generateButtonKey), findsOneWidget);
  });

  testWidgets('SC-324 first viewport reaches tax report tabs', (tester) async {
    await pumpTaxReports(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-324 TaxReportCenter',
      semanticLabel: 'Trung tâm báo cáo thuế',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TaxReportCenterPage.tabKey(TaxReportTab.generate)),
      routeName: 'SC-324 TaxReportCenter',
      actionLabel: 'the generate report tab',
    );
  });

  testWidgets('SC-324 switches format, reports, and settings locally', (
    tester,
  ) async {
    await pumpTaxReports(tester);

    final csvFormat = find.byKey(
      TaxReportCenterPage.formatKey(TaxExportFormat.csv),
    );
    await tester.ensureVisible(csvFormat);
    await tester.pump();
    await tester.tap(csvFormat);
    await tester.pump();
    await tester.ensureVisible(
      find.byKey(TaxReportCenterPage.generateButtonKey),
    );
    await tester.pump();
    await tester.tap(find.byKey(TaxReportCenterPage.generateButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('CSV Export Queued'), findsOneWidget);

    await tester.tap(
      find.byKey(TaxReportCenterPage.tabKey(TaxReportTab.reports)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Generated Reports'), findsOneWidget);
    expect(find.text('2024 Tax Year'), findsOneWidget);
    expect(find.text('Q4 2024'), findsOneWidget);

    await tester.tap(
      find.byKey(TaxReportCenterPage.tabKey(TaxReportTab.settings)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Report Settings'), findsOneWidget);
    expect(find.text('Include Arena Points'), findsOneWidget);
    expect(find.byKey(TaxReportCenterPage.includeArenaKey), findsOneWidget);
    await tester.tap(find.byKey(TaxReportCenterPage.includeArenaKey));
    await tester.pump();
  });
}
