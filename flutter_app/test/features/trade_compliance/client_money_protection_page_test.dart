import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/client_money/cass_reconciliation_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/client_money/client_money_protection_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpClientMoneyProtection(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyClientMoneyProtection,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-102 mock repository exposes client money BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getClientMoneyProtection();

    expect(snapshot.balance, 45230.50);
    expect(snapshot.trustAccount, 'Barclays UK');
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-client-money-protection',
    );
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(snapshot.protections.map((item) => item.title), [
      'Segregated Bank Accounts',
      'Daily Reconciliation',
      'FCA Supervision',
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

  testWidgets('SC-102 renders client money protection in Trade shell', (
    tester,
  ) async {
    await pumpClientMoneyProtection(tester);

    expect(find.byType(ClientMoneyProtectionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Client Money Protection'), findsOneWidget);
    expect(find.text('CASS 7 Compliance'), findsOneWidget);
    expect(find.text('Your Funds Are Protected'), findsOneWidget);
    expect(find.text('\$45,230.50'), findsOneWidget);
    expect(find.text('Segregated Bank Accounts'), findsOneWidget);
    expect(find.text('In Case of Insolvency'), findsOneWidget);
  });

  testWidgets('SC-102 first viewport reaches protection overview', (
    tester,
  ) async {
    await pumpClientMoneyProtection(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ClientMoneyProtectionPage',
      semanticLabel: 'Bảo vệ tiền của khách hàng theo quy định CASS 7',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ClientMoneyProtectionPage.overviewSectionKey),
      minVisibleHeight: 24,
      targetLabel: 'client money protection overview',
      reason:
          'Client money protection must show the segregation/protection '
          'overview above bottom navigation after the balance summary.',
    );
  });

  testWidgets('SC-102 reconciliation edge opens SC-103', (tester) async {
    await pumpClientMoneyProtection(tester);

    await tester.tap(
      find.byKey(ClientMoneyProtectionPage.tabKey('reconciliation')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(ClientMoneyProtectionPage.cassHistoryKey),
      findsOneWidget,
    );

    await tester.tap(find.byKey(ClientMoneyProtectionPage.cassHistoryKey));
    await tester.pumpAndSettle();

    expect(find.text('CASS Reconciliation'), findsOneWidget);
    expect(find.byType(CassReconciliationPage), findsOneWidget);
    expect(find.byType(ClientMoneyProtectionPage), findsNothing);
  });
}
