import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/trade_history_export_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTradeExport(
    WidgetTester tester, {
    TradeRepository repository = const MockTradeRepository(),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [tradeRepositoryProvider.overrideWithValue(repository)],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeExport,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-054 mock repository exposes export BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getTradeExport();
    final result = await repo.createTradeExport(
      const TradeExportRequest(
        format: 'csv',
        period: '30d',
        includeIds: ['spot', 'fees'],
      ),
    );

    expect(snapshot.trade.pairs, hasLength(3));
    expect(snapshot.stats.totalTrades, 847);
    expect(snapshot.stats.totalVolume, 2458300);
    expect(snapshot.stats.totalFees, 2340.56);
    expect(snapshot.stats.netPnl, 12456.78);
    expect(snapshot.formats.map((item) => item.id), ['csv', 'pdf']);
    expect(snapshot.periods.map((item) => item.id), [
      '7d',
      '30d',
      '90d',
      '1y',
      'custom',
    ]);
    expect(snapshot.includes.where((item) => item.checked), hasLength(6));
    expect(result.status, 'ready');
    expect(result.downloadUrl, '/exports/EXP-TRADE-054.csv');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-054 renders export page inside the Trade shell', (
    tester,
  ) async {
    await pumpTradeExport(tester);

    expect(find.byType(TradeHistoryExportPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xuất lịch sử giao dịch'), findsOneWidget);
    expect(find.text('Định dạng file'), findsOneWidget);
    expect(find.text('CSV'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Khoảng thời gian'), findsOneWidget);
    expect(find.text('30 ngày'), findsOneWidget);
    expect(find.text('Bao gồm dữ liệu'), findsOneWidget);
    expect(find.text('Spot Trading'), findsOneWidget);
    expect(find.text('Xuất CSV (30d)'), findsOneWidget);
  });

  testWidgets('SC-054 first viewport reaches export format selector', (
    tester,
  ) async {
    await pumpTradeExport(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TradeHistoryExportPage',
      semanticLabel: 'Xuất lịch sử giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(TradeHistoryExportPage.formatKey('csv')),
      minVisibleHeight: 36,
      targetLabel: 'CSV export format selector',
      reason:
          'Trade export should expose the primary format selector before '
          'sticky export actions on the QA phone viewport.',
    );
  });

  testWidgets('SC-054 format and period selections update the CTA', (
    tester,
  ) async {
    await pumpTradeExport(tester);

    await tester.tap(find.byKey(TradeHistoryExportPage.formatKey('pdf')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeHistoryExportPage.periodKey('90d')));
    await tester.pumpAndSettle();

    expect(find.text('Xuất PDF (90d)'), findsOneWidget);
  });

  testWidgets('SC-054 include toggles are sent to export request', (
    tester,
  ) async {
    final repository = _CapturingTradeRepository();
    await pumpTradeExport(tester, repository: repository);

    await tester.tap(find.byKey(TradeHistoryExportPage.includeKey('spot')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeHistoryExportPage.exportKey));
    await tester.pump();
    expect(find.text('Đang tạo file...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 260));
    await tester.pumpAndSettle();

    expect(repository.lastRequest, isNotNull);
    expect(repository.lastRequest!.format, 'csv');
    expect(repository.lastRequest!.period, '30d');
    expect(repository.lastRequest!.includeIds, isNot(contains('spot')));
    expect(repository.lastRequest!.includeIds, contains('fees'));
    expect(find.text('File đã sẵn sàng tải xuống'), findsOneWidget);
    expect(find.text('Tải CSV'), findsOneWidget);
  });

  testWidgets('SC-054 new export resets the ready state', (tester) async {
    await pumpTradeExport(tester);

    await tester.tap(find.byKey(TradeHistoryExportPage.exportKey));
    await tester.pump(const Duration(milliseconds: 260));
    await tester.pumpAndSettle();
    // Export-ready notice sheet is shown — dismiss it before interacting
    // with the footer action buttons behind the modal barrier.
    expect(find.text('File đã sẵn sàng tải xuống'), findsOneWidget);
    await tester.tap(find.text('Tiếp tục'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TradeHistoryExportPage.newExportKey));
    await tester.pumpAndSettle();

    expect(find.text('Xuất CSV (30d)'), findsOneWidget);
    expect(find.text('File đã sẵn sàng tải xuống'), findsNothing);
  });
}

class _CapturingTradeRepository implements TradeRepository {
  final MockTradeRepository _delegate = const MockTradeRepository(
    loadDelay: Duration.zero,
  );
  TradeExportRequest? lastRequest;

  @override
  Future<TradeExportSnapshot> getTradeExport() {
    return _delegate.getTradeExport();
  }

  @override
  Future<TradeExportResult> createTradeExport(TradeExportRequest request) {
    lastRequest = request;
    return _delegate.createTradeExport(request);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
