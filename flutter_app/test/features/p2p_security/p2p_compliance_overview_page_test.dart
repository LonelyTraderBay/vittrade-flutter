import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_transaction_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpComplianceOverview(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pComplianceOverview,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-267 mock repository exposes compliance overview BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getComplianceOverview();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-compliance-overview');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Compliance Overview');
    expect(snapshot.subtitle, 'Tuân thủ · P2P');
    expect(snapshot.heroTitle, 'Compliance Active');
    expect(snapshot.items, hasLength(4));
    expect(snapshot.items.map((item) => item.route), [
      AppRoutePaths.p2pKycStatus,
      AppRoutePaths.p2pComplianceAmlScreening,
      AppRoutePaths.p2pLimits,
      AppRoutePaths.p2pComplianceSourceOfFunds,
    ]);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-267 renders compliance overview baseline', (tester) async {
    await pumpComplianceOverview(tester);

    expect(find.byType(P2PComplianceOverviewPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Compliance Overview'), findsOneWidget);
    expect(find.text('Tuân thủ · P2P'), findsOneWidget);
    expect(find.byKey(P2PComplianceOverviewPage.heroKey), findsOneWidget);
    expect(find.byType(VitModuleHeroCard), findsOneWidget);
    expect(find.byType(VitMetricCard), findsOneWidget);
    expect(find.text('Compliance Active'), findsOneWidget);
    expect(find.text('Tài khoản tuân thủ đầy đủ quy định'), findsOneWidget);
    expect(find.byKey(P2PComplianceOverviewPage.checklistKey), findsOneWidget);
    expect(find.text('Compliance Checklist'), findsOneWidget);
    expect(find.text('KYC Status'), findsOneWidget);
    expect(find.text('Tier 1 Basic'), findsOneWidget);
    expect(find.text('AML Screening'), findsOneWidget);
    expect(find.text('Low Risk'), findsOneWidget);
    expect(find.text('Transaction Limits'), findsOneWidget);
    expect(find.text('50M/ngày'), findsOneWidget);
    expect(find.text('Source of Funds'), findsOneWidget);
    expect(find.text('Đã khai báo'), findsOneWidget);
  });

  testWidgets('SC-267 remains stable at 360px phone baseline', (tester) async {
    await pumpComplianceOverview(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PComplianceOverviewPage), findsOneWidget);
    expect(find.byKey(P2PComplianceOverviewPage.heroKey), findsOneWidget);
    expect(find.byType(VitModuleHeroCard), findsOneWidget);
    expect(find.byType(VitMetricCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-267 first viewport reaches checklist actions', (
    tester,
  ) async {
    await pumpComplianceOverview(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-267 P2PComplianceOverviewPage',
      semanticLabel: 'Tổng quan tuân thủ P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PComplianceOverviewPage.heroKey),
      routeName: 'SC-267 P2PComplianceOverviewPage',
      actionLabel: 'the compliance status summary',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      P2PComplianceOverviewPage.itemKey('kyc').finder,
      routeName: 'SC-267 P2PComplianceOverviewPage',
      actionLabel: 'the KYC checklist action',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      P2PComplianceOverviewPage.itemKey('aml').finder,
      routeName: 'SC-267 P2PComplianceOverviewPage',
      actionLabel: 'the AML checklist action',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-267 navigation opens confirmed checklist routes', (
    tester,
  ) async {
    await pumpComplianceOverview(tester);

    await tester.tap(P2PComplianceOverviewPage.itemKey('kyc').finder);
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);

    await pumpComplianceOverview(tester);
    await tester.tap(P2PComplianceOverviewPage.itemKey('limits').finder);
    await tester.pumpAndSettle();

    expect(find.byType(P2PTransactionLimitsPage), findsOneWidget);
  });

  testWidgets('SC-267 navigation uses confirmed compliance route edges', (
    tester,
  ) async {
    await pumpComplianceOverview(tester);

    await tester.tap(P2PComplianceOverviewPage.itemKey('aml').finder);
    await tester.pumpAndSettle();

    expect(find.byType(P2PComplianceOverviewPage), findsNothing);
    expect(find.text('AML Screening'), findsOneWidget);
    expect(find.text('Low Risk'), findsNothing);

    await pumpComplianceOverview(tester);
    await tester.tap(P2PComplianceOverviewPage.itemKey('sof').finder);
    await tester.pumpAndSettle();

    expect(find.byType(P2PComplianceOverviewPage), findsNothing);
    expect(find.text('Source of Funds'), findsOneWidget);
    expect(find.text('Đã khai báo'), findsNothing);
  });

  testWidgets('SC-267 back returns to P2P parent safely', (tester) async {
    await pumpComplianceOverview(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PComplianceOverviewPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
