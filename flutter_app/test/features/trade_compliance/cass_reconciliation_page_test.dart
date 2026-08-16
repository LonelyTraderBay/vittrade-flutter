import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/client_money/cass_reconciliation_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCassReconciliation(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyCassReconciliation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-103 mock repository exposes CASS BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getCassReconciliation();

    expect(snapshot.reconciledCount, 3);
    expect(snapshot.resolvedCount, 1);
    expect(snapshot.outstandingCount, 0);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-cass-reconciliation',
    );
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(snapshot.records.map((record) => record.id), [
      'cass-2026-03-08',
      'cass-2026-03-07',
      'cass-2026-03-06',
      'cass-2026-03-05',
    ]);
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

  testWidgets('SC-103 renders CASS reconciliation in Trade shell', (
    tester,
  ) async {
    await pumpCassReconciliation(tester);

    expect(find.byType(CassReconciliationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('CASS Reconciliation'), findsOneWidget);
    expect(find.text('Daily Client Money Matching'), findsOneWidget);
    expect(find.text('Reconciliation Records'), findsOneWidget);
    expect(find.text('March 8, 2026'), findsOneWidget);
    expect(find.text('Pending deposit cleared'), findsOneWidget);
    expect(find.text('Export Reconciliation Report (CSV)'), findsOneWidget);
  });

  testWidgets('SC-103 first viewport reaches first reconciliation record', (
    tester,
  ) async {
    await pumpCassReconciliation(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-103 CASSReconciliationPage',
      semanticLabel: 'Đối soát CASS: khớp tiền của khách hàng theo từng ngày',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(CassReconciliationPage.recordKey('cass-2026-03-08')),
      targetLabel: 'the first CASS reconciliation record',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-103 switches tab state without losing records', (
    tester,
  ) async {
    await pumpCassReconciliation(tester);

    await tester.tap(find.byKey(CassReconciliationPage.tabKey('history')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(CassReconciliationPage.recordKey('cass-2026-03-06')),
      findsOneWidget,
    );
    expect(find.text('Resolved'), findsWidgets);
    expect(find.byKey(CassReconciliationPage.exportKey), findsOneWidget);
  });
}
