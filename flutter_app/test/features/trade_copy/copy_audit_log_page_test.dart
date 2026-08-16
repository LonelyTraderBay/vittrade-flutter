import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/copy_audit_log_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyAuditLog(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyAuditLog('copy001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-077 mock repository exposes copy audit BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getCopyAuditLog(copyId: 'copy001');
    final export = await repo.createCopyAuditExport(
      const TradeCopyAuditExportRequest(
        copyId: 'copy001',
        format: 'csv',
        filterId: 'all',
        searchQuery: '',
      ),
    );

    expect(snapshot.copyId, 'copy001');
    expect(snapshot.retentionYears, 5);
    expect(snapshot.events, hasLength(7));
    expect(snapshot.tabs.map((tab) => tab.id), [
      'all',
      'trade',
      'config',
      'risk',
      'system',
    ]);
    expect(snapshot.exportFormats.map((item) => item.id), [
      'csv',
      'pdf',
      'json',
    ]);
    expect(export.status, 'ready');
    expect(export.downloadUrl, '/exports/copy-audit-copy001.csv');
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

  testWidgets('SC-077 renders audit timeline inside the Trade shell', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    expect(find.byType(CopyAuditLogPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Nhật ký kiểm toán'), findsOneWidget);
    expect(find.text('MiFID II Compliant Audit Trail'), findsOneWidget);
    expect(find.text('Trade Executed'), findsOneWidget);
    expect(find.text('Risk Alert Triggered'), findsOneWidget);
    expect(find.text('Thống kê tổng quan'), findsOneWidget);
  });

  testWidgets('SC-077 first viewport reaches first audit event', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'CopyAuditLogPage',
      semanticLabel: 'Nhật ký kiểm toán sao chép giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(CopyAuditLogPage.eventKey('evt-1')),
      minVisibleHeight: 24,
      targetLabel: 'first audit event',
      reason:
          'Copy audit log must show the first timeline event above bottom '
          'navigation after compliance notice, review, search, and tabs.',
    );
  });

  testWidgets('SC-077 search and filter tabs narrow the audit list', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    await tester.tap(find.byKey(CopyAuditLogPage.tabKey('risk')));
    await tester.pumpAndSettle();

    expect(find.text('Risk Alert Triggered'), findsOneWidget);
    expect(find.text('Trade Executed'), findsNothing);

    await tester.enterText(find.byKey(CopyAuditLogPage.searchFieldKey), 'DOGE');
    await tester.pumpAndSettle();

    expect(find.byKey(CopyAuditLogPage.emptyStateKey), findsOneWidget);
    expect(find.text('Không tìm thấy event phù hợp'), findsOneWidget);
  });

  testWidgets('SC-077 export action opens CSV/PDF/JSON choices', (
    tester,
  ) async {
    await pumpCopyAuditLog(tester);

    await tester.tap(find.byKey(CopyAuditLogPage.exportActionKey));
    await tester.pumpAndSettle();

    expect(find.text('Export Audit Log'), findsOneWidget);
    expect(find.text('CSV'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('JSON'), findsOneWidget);

    await tester.tap(find.byKey(CopyAuditLogPage.exportFormatKey('csv')));
    await tester.pumpAndSettle();

    expect(find.text('Export Audit Log'), findsNothing);
  });
}
