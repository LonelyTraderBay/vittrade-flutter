import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/points/arena_points_entry_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/points/arena_points_ledger_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_safety_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLedger(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaLedger,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-201 mock repository exposes Arena Points ledger BE draft', () async {
    const repository = MockArenaRepository(loadDelay: Duration.zero);
    final snapshot = await repository.getArenaPointsLedger();
    final detail = await repository.getArenaPointsEntryDetail('le001');

    expect(snapshot.endpoint, '/api/mobile/arena/arena-ledger');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.summary.currentBalance, 2220);
    expect(snapshot.summary.pointsEarned, 4520);
    expect(snapshot.summary.pointsSpent, 2300);
    expect(snapshot.filters.map((filter) => filter.id), [
      'all',
      'earned',
      'spent',
      'entry',
      'settlement',
      'refund',
      'adjustment',
    ]);
    expect(snapshot.entries.length, 15);
    expect(snapshot.entries.first.title, 'Check-in ngày 5');
    expect(snapshot.entries.map((entry) => entry.id), contains('le015'));
    expect(detail.entry?.refId, 'REF-D20260228-001');
    expect(detail.entry?.balanceAfter, 2220);
    expect(snapshot.disclaimer, contains('không có giá trị tiền tệ'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-201 renders Arena Points ledger baseline', (tester) async {
    await pumpLedger(tester);

    expect(find.byType(ArenaPointsLedgerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử Arena Points'), findsOneWidget);
    expect(find.text('Sổ điểm · Open Arena'), findsOneWidget);
    expect(find.text('Số dư hiện tại'), findsOneWidget);
    expect(find.text('2.2K pts'), findsOneWidget);
    expect(find.text('15 bản ghi'), findsOneWidget);
    expect(find.text('Check-in ngày 5'), findsOneWidget);
    expect(find.text('Đạt \$500 khối lượng Spot'), findsOneWidget);
    expect(find.text('Quy tắc cộng đồng'), findsOneWidget);
  });

  testWidgets('SC-201 first viewport exposes ledger controls and preview', (
    tester,
  ) async {
    await pumpLedger(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-201 ArenaPointsLedgerPage',
      semanticLabel: 'Lịch sử sổ điểm Arena Points trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaPointsLedgerPage.searchKey),
      routeName: 'SC-201 ArenaPointsLedgerPage',
      actionLabel: 'the ledger search field',
    );
    expectActionableInFirstViewport(
      tester,
      ArenaPointsLedgerPage.filterKey('all').finder,
      routeName: 'SC-201 ArenaPointsLedgerPage',
      actionLabel: 'the all ledger filter',
    );
    expectActionableInFirstViewport(
      tester,
      ArenaPointsLedgerPage.entryKey('le001').finder,
      routeName: 'SC-201 ArenaPointsLedgerPage',
      actionLabel: 'the first ledger entry',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-201 filters and searches ledger entries', (tester) async {
    await pumpLedger(tester);

    await tester.tap(ArenaPointsLedgerPage.filterKey('entry').finder);
    await tester.pumpAndSettle();
    expect(find.text('4 bản ghi'), findsOneWidget);
    expect(find.text('BTC \$70K? — Tuần 9'), findsOneWidget);
    expect(find.text('Check-in ngày 5'), findsNothing);

    await tester.enterText(find.byType(TextField), 'P2P');
    await tester.pumpAndSettle();
    expect(find.text('0 bản ghi'), findsOneWidget);
    expect(find.text('Không tìm thấy bản ghi'), findsOneWidget);

    await tester.tap(ArenaPointsLedgerPage.filterKey('all').finder);
    await tester.pumpAndSettle();
    expect(find.text('1 bản ghi'), findsOneWidget);
    expect(find.text('Giao dịch P2P hoàn tất'), findsOneWidget);
  });

  testWidgets('SC-201 rows navigate to entry detail', (tester) async {
    await pumpLedger(tester);

    await tester.tap(ArenaPointsLedgerPage.entryKey('le001').finder);
    await tester.pumpAndSettle();

    expect(find.byType(ArenaPointsEntryDetailPage), findsOneWidget);
    expect(find.text('+30'), findsOneWidget);
    expect(find.text('REF-D20260228-001'), findsOneWidget);
  });

  testWidgets('SC-201 community rules link uses Arena safety route', (
    tester,
  ) async {
    await pumpLedger(tester);

    await tester.ensureVisible(
      find.byKey(ArenaPointsLedgerPage.communityRulesKey),
    );
    await tester.tap(find.byKey(ArenaPointsLedgerPage.communityRulesKey));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaSafetyCenterPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
