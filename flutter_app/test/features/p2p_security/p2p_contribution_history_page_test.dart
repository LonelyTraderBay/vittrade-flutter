import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_contribution_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PContributionHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pContributionHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-242 mock repository exposes contribution history BE draft',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getContributionHistory();

      expect(
        snapshot.endpoint,
        '/api/mobile/p2p/p2p-insurance-contribution-history',
      );
      expect(
        snapshot.actionDraft,
        'POST /p2p/* workflow action where applicable',
      );
      expect(snapshot.totalContributed, 309700);
      expect(snapshot.totalTrades, 15);
      expect(snapshot.averagePerTrade, 20647);
      expect(snapshot.monthlyGroups, hasLength(3));
      expect(snapshot.monthlyGroups.first.monthLabel, 'Tháng 3/2026');
      expect(snapshot.monthlyGroups.first.totalAmount, 67700);
      expect(snapshot.contributionRateLabel, '0.1%');
      expect(snapshot.parentRoute, AppRoutePaths.p2pInsurance);
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
    },
  );

  testWidgets('SC-242 renders grouped contribution history in P2P shell', (
    tester,
  ) async {
    await pumpP2PContributionHistory(tester);

    expect(find.byType(P2PContributionHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử đóng góp'), findsOneWidget);
    expect(find.text('Bảo hiểm · P2P'), findsOneWidget);
    expect(find.byKey(P2PContributionHistoryPage.summaryKey), findsOneWidget);
    expect(find.text('Tổng quan đóng góp'), findsOneWidget);
    expect(find.text('309.700 đ'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('20.647 đ'), findsOneWidget);
    expect(find.byKey(P2PContributionHistoryPage.exportKey), findsOneWidget);
    expect(find.text('Tháng 3/2026'), findsOneWidget);
    expect(find.text('P2P-78470'), findsOneWidget);
    expect(find.text('+7.200 đ'), findsOneWidget);

    await tester.ensureVisible(find.text('Tháng 1/2026'));
    expect(find.text('Tháng 1/2026'), findsOneWidget);
    expect(find.text('P2P-78180'), findsOneWidget);
  });

  testWidgets('SC-242 navigation and export feedback work', (tester) async {
    await pumpP2PContributionHistory(tester);

    await tester.tap(find.byKey(P2PContributionHistoryPage.exportKey));
    await tester.pumpAndSettle();
    expect(find.byKey(P2PContributionHistoryPage.feedbackKey), findsOneWidget);
    expect(find.textContaining('báo cáo CSV'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);
  });
}
