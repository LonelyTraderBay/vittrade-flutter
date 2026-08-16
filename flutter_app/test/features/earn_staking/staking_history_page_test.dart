import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-360 mock repository exposes staking history BE draft', () async {
    final snapshot = await const MockStakingHistoryRepository().getHistory();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-history');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Lịch sử Staking');
    expect(snapshot.backRoute, AppRoutePaths.earnDashboard);
    expect(snapshot.totalStakedUsd, 17577);
    expect(snapshot.totalEarnedUsd, 92.07);
    expect(snapshot.totalUnstakedUsd, 6656);
    expect(snapshot.transactions, hasLength(12));
    expect(
      snapshot.transactions.last.type,
      StakingHistoryTransactionType.claim,
    );
    expect(snapshot.contractNotes, contains('riskData'));
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

  testWidgets('SC-360 renders staking history baseline', (tester) async {
    await pumpHistory(tester);

    expect(find.byType(StakingHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử Staking'), findsOneWidget);
    expect(find.byKey(StakingHistoryPage.summaryKey), findsOneWidget);
    expect(find.text(r'$17,577.00'), findsOneWidget);
    expect(find.text(r'+$92.07'), findsOneWidget);
    expect(find.text(r'$6,656.00'), findsAtLeastNWidgets(1));
    expect(find.byKey(StakingHistoryPage.searchKey), findsOneWidget);
    expect(find.byKey(StakingHistoryPage.resultCountKey), findsOneWidget);
    expect(find.text('12 giao dịch'), findsOneWidget);
    expect(find.byKey(StakingHistoryPage.firstTransactionKey), findsOneWidget);
    expect(find.text('BTC Fixed 90D • 01/01/2026 14:23'), findsOneWidget);
  });

  testWidgets('SC-360 filter and search state narrows transaction list', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(StakingHistoryPage.filterButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(StakingHistoryPage.filterPanelKey), findsOneWidget);

    final claimFilter = find.descendant(
      of: find.byKey(StakingHistoryPage.filterPanelKey),
      matching: find.text('Nhận lãi'),
    );
    await tester.tap(claimFilter);
    await tester.pumpAndSettle();
    expect(find.text('4 giao dịch (đã lọc từ 12)'), findsOneWidget);
    expect(find.text('Nhận lãi'), findsWidgets);
    expect(find.byKey(StakingHistoryPage.transactionKey('tx10')), findsNothing);

    await tester.enterText(find.byKey(StakingHistoryPage.searchKey), 'LP');
    await tester.pumpAndSettle();
    expect(find.text('1 giao dịch (đã lọc từ 12)'), findsOneWidget);
    expect(find.text('ETH-USDT LP • 25/02/2026 00:00'), findsOneWidget);
  });

  testWidgets('SC-360 transaction detail state opens inline detail', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(StakingHistoryPage.firstTransactionKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingHistoryPage.detailKey), findsOneWidget);
    expect(find.text('Tx Hash'), findsOneWidget);
    expect(find.text('0x1234...5678'), findsOneWidget);
  });

  testWidgets('SC-360 header back returns to staking dashboard', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingDashboardPage), findsOneWidget);
    expect(find.text('Staking Dashboard'), findsOneWidget);
  });
}
