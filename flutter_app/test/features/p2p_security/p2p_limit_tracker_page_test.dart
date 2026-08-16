import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_limit_tracker_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_transaction_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpLimitTracker(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pLimitsTracker,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-265 mock repository exposes limit tracker BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getLimitTracker();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-limits-tracker');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.usages.map((item) => item.period), [
      'daily',
      'weekly',
      'monthly',
    ]);
    expect(snapshot.usageFor('daily').used, 35000000);
    expect(snapshot.usageFor('weekly').percentage, 60);
    expect(snapshot.breakdown, hasLength(4));
    expect(snapshot.breakdown.first.total, 35000000);
    expect(snapshot.parentRoute, AppRoutePaths.p2pLimits);
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

  testWidgets('SC-265 renders P2P limit tracker baseline', (tester) async {
    await pumpLimitTracker(tester);

    expect(find.byType(P2PLimitTrackerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Limit Tracker'), findsOneWidget);
    expect(find.text('Hạn mức · P2P'), findsOneWidget);
    expect(find.byKey(P2PLimitTrackerPage.periodTabsKey), findsOneWidget);
    expect(find.text('Hôm nay'), findsOneWidget);
    expect(find.text('Tuần'), findsOneWidget);
    expect(find.text('Tháng'), findsOneWidget);
    expect(find.byKey(P2PLimitTrackerPage.usageHeroKey), findsOneWidget);
    expect(find.text('35,000,000 VND'), findsOneWidget);
    expect(find.text('70% / 50,000,000 VND'), findsOneWidget);
    expect(find.byKey(P2PLimitTrackerPage.historyKey), findsOneWidget);
    expect(find.text('Lịch sử gần đây'), findsOneWidget);
    expect(find.byKey(P2PLimitTrackerPage.dayKey('05/03')), findsOneWidget);
    expect(find.text('Tổng: 35M'), findsOneWidget);
    expect(find.text('MUA'), findsNWidgets(4));
    expect(find.text('BÁN'), findsNWidgets(4));
  });

  testWidgets('SC-265 period tabs update usage state', (tester) async {
    await pumpLimitTracker(tester);

    await tester.tap(find.byKey(P2PLimitTrackerPage.periodKey('weekly')));
    await tester.pumpAndSettle();

    expect(find.text('180,000,000 VND'), findsOneWidget);
    expect(find.text('60% / 300,000,000 VND'), findsOneWidget);

    await tester.tap(find.byKey(P2PLimitTrackerPage.periodKey('monthly')));
    await tester.pumpAndSettle();

    expect(find.text('650,000,000 VND'), findsOneWidget);
    expect(find.text('65% / 1,000,000,000 VND'), findsOneWidget);
  });

  testWidgets('SC-265 back returns to transaction limits parent safely', (
    tester,
  ) async {
    await pumpLimitTracker(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PLimitTrackerPage), findsNothing);
    expect(find.byType(P2PTransactionLimitsPage), findsOneWidget);
  });
}
