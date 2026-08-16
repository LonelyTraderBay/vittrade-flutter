import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_tax_reporting_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotTaxReporting(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotTaxReporting,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-133 mock repository exposes bot tax reporting BE draft', () async {
    final repo = const MockTradeBotsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getBotTaxReporting();
    final exportResult = await repo.createBotTaxReportExport(
      const TradeBotTaxReportExportRequest(
        year: '2025',
        reportTypeIds: ['irs-8949', 'turbotax'],
        costBasisMethod: 'FIFO',
      ),
    );

    expect(snapshot.taxYears, ['2026', '2025', '2024', '2023']);
    expect(snapshot.defaultYear, '2025');
    expect(snapshot.defaultCostBasisMethod, 'FIFO');
    expect(snapshot.summary.totalTrades, 1247);
    expect(snapshot.summary.netGainLoss, 2715.20);
    expect(snapshot.reportTypes, hasLength(4));
    expect(
      snapshot.reportTypes.where((item) => item.selectedByDefault),
      hasLength(2),
    );
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-tax-reporting');
    expect(snapshot.actionDraft, contains('POST /exports'));
    expect(exportResult.status, 'ready');
    expect(exportResult.reportCount, 2);
    expect(exportResult.exportId, 'BOT-TAX-2025-FIFO');
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

  testWidgets('SC-133 renders tax reporting baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotTaxReporting(tester);

    expect(find.byType(BotTaxReportingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Báo cáo thuế'), findsOneWidget);
    expect(find.text('Thông báo báo cáo thuế'), findsOneWidget);
    expect(find.text('Chọn năm thuế'), findsOneWidget);
    expect(find.text('Tóm tắt năm 2025'), findsOneWidget);
    expect(find.text('Tổng số giao dịch'), findsOneWidget);
    expect(find.text('Phương pháp tính giá vốn'), findsOneWidget);
    expect(find.text('IRS Form 8949'), findsOneWidget);
    expect(find.text('TurboTax CSV'), findsOneWidget);
    expect(find.text('Tạo 2 báo cáo cho năm 2025'), findsOneWidget);
  });

  testWidgets('SC-133 year, method, and report controls update CTA', (
    tester,
  ) async {
    await pumpBotTaxReporting(tester);

    await tester.tap(find.byKey(BotTaxReportingPage.yearKey('2026')));
    await tester.pumpAndSettle();
    expect(find.text('Tóm tắt năm 2026'), findsOneWidget);
    expect(find.text('Tạo 2 báo cáo cho năm 2026'), findsOneWidget);

    await tester.tap(find.byKey(BotTaxReportingPage.methodKey('LIFO')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotTaxReportingPage.reportKey('irs-8949')));
    await tester.pumpAndSettle();

    expect(find.text('Tạo 1 báo cáo cho năm 2026'), findsOneWidget);
    await tester.tap(find.byKey(BotTaxReportingPage.generateKey));
    await tester.pumpAndSettle();
    expect(find.text('Tạo 1 báo cáo cho năm 2026'), findsOneWidget);
  });

  testWidgets('SC-133 first viewport reaches report type selection', (
    tester,
  ) async {
    await pumpBotTaxReporting(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(BotTaxReportingPage.reportKey('turbotax')),
      routeName: 'BotTaxReportingPage',
      actionLabel: 'secondary report type selection',
    );
  });
}
