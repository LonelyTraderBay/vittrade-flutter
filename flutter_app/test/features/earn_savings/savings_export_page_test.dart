import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_export_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpExport(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsExport,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-348 mock repository exposes savings export BE draft', () async {
    final snapshot = await const MockSavingsExportRepository().getExport();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-export');
    expect(snapshot.actionDraft, contains('POST /exports'));
    expect(snapshot.title, 'Xuất báo cáo');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Tạo báo cáo',
      'Lịch sử (4)',
    ]);
    expect(snapshot.reportTypes, hasLength(4));
    expect(snapshot.formats.map((format) => format.label), [
      'CSV',
      'PDF',
      'Excel',
    ]);
    expect(snapshot.defaultFormat, SavingsExportFormat.csv);
    expect(snapshot.defaultPeriod, SavingsExportPeriod.thirtyDays);
    expect(snapshot.defaultScope, SavingsExportScope.all);
    expect(snapshot.defaultEnabledOptions, contains('interest'));
    expect(snapshot.history, hasLength(4));
    expect(snapshot.contractNotes, contains('POST /exports'));
    expect(snapshot.supportedStates, contains(EarnScreenState.success));
  });

  testWidgets('SC-348 renders savings export baseline', (tester) async {
    await pumpExport(tester);

    expect(find.byType(SavingsExportPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xuất báo cáo'), findsOneWidget);
    expect(find.byKey(SavingsExportPage.summaryKey), findsOneWidget);
    expect(find.text('Export & Báo cáo'), findsOneWidget);
    expect(find.text('4 loại'), findsOneWidget);
    expect(find.byKey(SavingsExportPage.reportTypesKey), findsOneWidget);
    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
    expect(find.text('Báo cáo thuế'), findsOneWidget);
  });

  testWidgets(
    'SC-348 updates format, period, scope, option and preview state',
    (tester) async {
      await pumpExport(tester);

      final pdfCard = find.byKey(
        SavingsExportPage.formatKey(SavingsExportFormat.pdf),
      );
      await Scrollable.ensureVisible(tester.element(pdfCard), alignment: 0.45);
      await tester.pumpAndSettle();
      await tester.tap(pdfCard);
      await tester.pumpAndSettle();

      final ninetyDays = find.byKey(
        SavingsExportPage.periodKey(SavingsExportPeriod.ninetyDays),
      );
      await Scrollable.ensureVisible(
        tester.element(ninetyDays),
        alignment: 0.45,
      );
      await tester.pumpAndSettle();
      await tester.tap(ninetyDays);
      await tester.pumpAndSettle();

      final redeem = find.byKey(
        SavingsExportPage.scopeKey(SavingsExportScope.redeem),
      );
      await Scrollable.ensureVisible(tester.element(redeem), alignment: 0.45);
      await tester.pumpAndSettle();
      await tester.tap(redeem);
      await tester.pumpAndSettle();

      final apyHistory = find.byKey(SavingsExportPage.optionKey('apy-history'));
      await Scrollable.ensureVisible(
        tester.element(apyHistory),
        alignment: 0.45,
      );
      await tester.pumpAndSettle();
      await tester.tap(apyHistory);
      await tester.pumpAndSettle();

      final exportButton = find.byKey(SavingsExportPage.exportButtonKey);
      await Scrollable.ensureVisible(
        tester.element(exportButton),
        alignment: 0.82,
      );
      await tester.pumpAndSettle();
      await tester.tap(exportButton);
      await tester.pumpAndSettle();

      expect(find.text('Xem trước & Xuất PDF'), findsOneWidget);
      expect(find.byKey(SavingsExportPage.previewBannerKey), findsOneWidget);
      expect(find.textContaining('Bản xem trước PDF'), findsOneWidget);
    },
  );

  testWidgets('SC-348 history tab shows generated export files', (
    tester,
  ) async {
    await pumpExport(tester);

    await tester.tap(find.text('Lịch sử (4)'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsExportPage.historyListKey), findsOneWidget);
    expect(find.text('savings_transactions_2026Q1.csv'), findsOneWidget);
    expect(find.text('savings_tax_report_2025.pdf'), findsOneWidget);
  });

  testWidgets('SC-348 savings insight edge opens export page', (tester) async {
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

    await tester.scrollUntilVisible(
      find.byKey(SavingsPage.moreToolsKey),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(SavingsPage.moreToolsKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsPage.moreToolsSheetKey), findsOneWidget);
    await tester.tap(find.byKey(SavingsPage.exportInsightKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsExportPage), findsOneWidget);
  });
}
