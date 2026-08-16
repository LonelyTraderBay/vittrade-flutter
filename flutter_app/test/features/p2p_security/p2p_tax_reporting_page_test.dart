import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_tax_reporting_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpTaxReporting(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pTaxReporting,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-272 mock repository exposes tax reporting BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getTaxReporting();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-tax-reporting');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /exports',
    );
    expect(snapshot.title, 'Tax Reporting');
    expect(snapshot.subtitle, 'Thuế · P2P');
    expect(snapshot.selectedYear, 2025);
    expect(snapshot.selectedJurisdiction.code, 'US');
    expect(snapshot.years, [2026, 2025, 2024, 2023]);
    expect(snapshot.jurisdictions, hasLength(4));
    expect(snapshot.summary.totalTransactions, 156);
    expect(snapshot.documents, hasLength(3));
    expect(snapshot.detailRoute, AppRoutePaths.p2pTaxReportDetailed('2025'));
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

  testWidgets('SC-272 renders tax reporting baseline', (tester) async {
    await pumpTaxReporting(tester);

    expect(find.byType(P2PTaxReportingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tax Reporting'), findsOneWidget);
    expect(find.text('Thuế · P2P'), findsOneWidget);
    expect(find.byKey(P2PTaxReportingPage.heroKey), findsOneWidget);
    expect(find.text('Tax Year 2025'), findsOneWidget);
    expect(find.text('United States · Form 1099'), findsOneWidget);
    expect(find.byKey(P2PTaxReportingPage.yearsKey), findsOneWidget);
    expect(find.text('Select Tax Year'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('2025'), findsOneWidget);
    expect(find.byKey(P2PTaxReportingPage.jurisdictionsKey), findsOneWidget);
    expect(find.text('Jurisdiction'), findsOneWidget);
    expect(find.text('United States'), findsOneWidget);
    expect(find.text('European Union'), findsOneWidget);
    expect(find.text('United Kingdom'), findsOneWidget);
    expect(find.text('Vietnam'), findsOneWidget);
    expect(find.byKey(P2PTaxReportingPage.summaryKey), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('156'), findsOneWidget);
    expect(find.text('Total Volume'), findsOneWidget);
    expect(find.text('1.250M'), findsOneWidget);
    expect(find.text('Capital Gains'), findsOneWidget);
    expect(find.text('+45M'), findsOneWidget);
    expect(find.text('Capital Losses'), findsOneWidget);
    expect(find.text('-12M'), findsOneWidget);
  });

  testWidgets('SC-272 supports year and jurisdiction state changes', (
    tester,
  ) async {
    await pumpTaxReporting(tester);

    await tester.tap(P2PTaxReportingPage.yearKey(2026).finder);
    await tester.tap(P2PTaxReportingPage.jurisdictionKey('VN').finder);
    await tester.pumpAndSettle();

    expect(find.text('Tax Year 2026'), findsOneWidget);
    expect(find.text('Vietnam · Tax Declaration'), findsOneWidget);
  });

  testWidgets('SC-272 detailed report CTA opens year-scoped report page', (
    tester,
  ) async {
    await pumpTaxReporting(tester);

    await tester.ensureVisible(find.byKey(P2PTaxReportingPage.detailCtaKey));
    await tester.tap(find.byKey(P2PTaxReportingPage.detailCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PTaxReportingPage), findsOneWidget);
    expect(find.text('Tax Year 2025'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
