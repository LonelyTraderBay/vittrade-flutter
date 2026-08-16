import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_audit_reports_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpReports(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnAuditReports,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-374 mock repository exposes audit reports BE draft', () async {
    final snapshot = await const MockStakingAuditReportsRepository()
        .getAuditReports();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-audit-reports');
    expect(snapshot.actionDraft, contains('POST /exports'));
    expect(snapshot.title, 'Audit Reports');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.defaultTabId, 'all');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'all',
      'smart-contract',
      'financial',
      'security',
    ]);
    expect(snapshot.stats, hasLength(3));
    expect(snapshot.reports, hasLength(5));
    expect(snapshot.bugBounty.payouts, hasLength(4));
    expect(snapshot.contractNotes, contains('riskData'));
    expect(snapshot.contractNotes, contains('POST /exports'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-374 renders audit reports baseline', (tester) async {
    await pumpReports(tester);

    expect(find.byType(StakingAuditReportsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Audit Reports'), findsOneWidget);
    expect(find.byKey(StakingAuditReportsPage.heroKey), findsOneWidget);
    expect(find.text('Transparency & Trust'), findsOneWidget);
    expect(find.byKey(StakingAuditReportsPage.statsKey), findsOneWidget);
    expect(find.text('Published Audits'), findsOneWidget);
    expect(find.text('Critical Issues'), findsOneWidget);
    expect(find.text('Bug Bounty'), findsOneWidget);
    expect(find.byKey(StakingAuditReportsPage.tabsKey), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Smart Contract'), findsWidgets);
    expect(find.text('Financial'), findsWidgets);
    expect(find.text('Security'), findsWidgets);
    expect(
      find.byKey(StakingAuditReportsPage.reportKey('sc-2026-q1')),
      findsOneWidget,
    );
    expect(find.text('Q1 2026 Smart Contract Security Audit'), findsOneWidget);
    expect(find.text('Findings Summary'), findsWidgets);
    expect(find.text('Download PDF'), findsWidgets);
  });

  testWidgets('SC-374 tabs filter financial and security reports', (
    tester,
  ) async {
    await pumpReports(tester);

    await tester.tap(find.text('Financial').first);
    await tester.pumpAndSettle();
    expect(find.text('2025 Annual Financial Audit'), findsOneWidget);
    expect(find.text('Q1 2026 Smart Contract Security Audit'), findsNothing);

    await tester.tap(find.text('Security').first);
    await tester.pumpAndSettle();
    expect(find.text('SOC 2 Type II Audit 2025'), findsOneWidget);
    expect(find.text('2025 Annual Financial Audit'), findsNothing);
  });

  testWidgets('SC-374 report actions and bug bounty CTA emit feedback', (
    tester,
  ) async {
    await pumpReports(tester);

    final downloadButton = find.byKey(
      StakingAuditReportsPage.downloadButtonKey('sc-2026-q1'),
    );
    await tester.ensureVisible(downloadButton);
    await tester.tap(downloadButton);
    await tester.pumpAndSettle();
    expect(find.textContaining('Preparing Q1 2026'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(StakingAuditReportsPage.bugBountyCtaKey),
    );
    await tester.tap(find.byKey(StakingAuditReportsPage.bugBountyCtaKey));
    await tester.pumpAndSettle();
    expect(find.text('Opening Immunefi bug bounty program'), findsOneWidget);
  });

  testWidgets('SC-374 back returns to staking hub', (tester) async {
    await pumpReports(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
