import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/audit_trail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAuditTrail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyAuditTrail,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-115 mock repository exposes audit trail BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getAuditTrail();

    expect(snapshot.noticeTitle, 'Complete Record-Keeping');
    expect(snapshot.stats.map((stat) => stat.value), ['3', '12', '7yr']);
    expect(snapshot.tabs.map((tab) => tab.label), [
      'All Events',
      'Trades',
      'Compliance',
      'Client Actions',
    ]);
    expect(snapshot.entries.map((entry) => entry.id), [
      'AUD-2026-001234',
      'AUD-2026-001233',
      'AUD-2026-001232',
    ]);
    expect(snapshot.exportFormats, ['CSV', 'PDF']);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-audit-trail',
    );
    expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
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

  testWidgets('SC-115 renders audit trail baseline in Trade shell', (
    tester,
  ) async {
    await pumpAuditTrail(tester);

    expect(find.byType(AuditTrailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Audit Trail'), findsOneWidget);
    expect(find.text('MiFID II Record-Keeping'), findsOneWidget);
    expect(find.text('Complete Record-Keeping'), findsOneWidget);
    expect(find.text('Total Events'), findsOneWidget);
    expect(find.text('7yr'), findsOneWidget);
    expect(find.text('All Events'), findsOneWidget);
    expect(find.text('Audit Log'), findsOneWidget);
    expect(find.text('Order Executed'), findsOneWidget);
    expect(find.text('Suitability Assessment Passed'), findsOneWidget);
    expect(find.text('Copy Trading Activated'), findsOneWidget);
    expect(find.byKey(AuditTrailPage.exportKey('CSV')), findsOneWidget);
    expect(find.byKey(AuditTrailPage.exportKey('PDF')), findsOneWidget);
  });

  testWidgets('SC-115 tab and search narrow visible audit entries', (
    tester,
  ) async {
    await pumpAuditTrail(tester);

    await tester.tap(find.byKey(AuditTrailPage.tabKey('compliance')));
    await tester.pumpAndSettle();

    expect(find.text('Suitability Assessment Passed'), findsOneWidget);
    expect(find.text('Order Executed'), findsNothing);

    await tester.enterText(find.byKey(AuditTrailPage.searchKey), 'portfolio');
    await tester.pumpAndSettle();

    expect(find.text('Suitability Assessment Passed'), findsOneWidget);
    expect(find.text('Copy Trading Activated'), findsNothing);
  });

  testWidgets(
    'SC-115 export CSV shows a coming-soon SnackBar without crashing',
    (tester) async {
      // Regression test: the shared trade layout primitives (VitTradeHubScaffold
      // / VitPageLayout) never construct a real Scaffold, so
      // ScaffoldMessenger.of(context).showSnackBar previously crashed at
      // tap-time with a '_scaffolds.isNotEmpty' assertion. AuditTrailPage now
      // wraps its root in a page-scoped Scaffold to host the SnackBar.
      await pumpAuditTrail(tester);

      await tester.scrollUntilVisible(
        find.byKey(AuditTrailPage.exportKey('CSV')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(AuditTrailPage.exportKey('CSV')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Xuất nhật ký kiểm toán sẽ sớm ra mắt'), findsOneWidget);
    },
  );

  testWidgets('SC-115 first viewport reaches audit search', (tester) async {
    await pumpAuditTrail(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-115 AuditTrailPage',
      semanticLabel: 'Nhật ký kiểm toán lưu trữ hồ sơ theo MiFID II',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(const Key('sc115_audit_trail_notice')),
      routeName: 'SC-115 AuditTrailPage',
      actionLabel: 'audit retention notice',
    );
  });
}
