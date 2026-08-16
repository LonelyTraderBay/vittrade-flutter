import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_mode_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/points/arena_points_entry_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpEntry(WidgetTester tester, String entryId) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaLedgerEntry(entryId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-200 mock repository exposes Arena Points entry BE draft', () async {
    const repository = MockArenaRepository(loadDelay: Duration.zero);
    final missing = await repository.getArenaPointsEntryDetail('entry001');
    final detail = await repository.getArenaPointsEntryDetail('entry-demo');

    expect(missing.endpoint, '/api/mobile/arena/arena-ledger-entry-entry001');
    expect(
      missing.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(missing.entry, isNull);
    expect(missing.emptyTitle, 'Không tìm thấy');
    expect(missing.emptySubtitle, 'Giao dịch điểm không tồn tại');
    expect(detail.entry?.amount, 240);
    expect(detail.entry?.linkedChallengeId, 'ch003');
    expect(detail.entry?.linkedModeId, 'mode001');
    expect(detail.disclaimer, contains('không phải ví giao dịch hoặc PnL'));
    expect(
      missing.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-200 renders missing entry baseline', (tester) async {
    await pumpEntry(tester, 'entry001');

    expect(find.byType(ArenaPointsEntryDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết giao dịch điểm'), findsOneWidget);
    expect(find.text('Arena Points · Open Arena'), findsOneWidget);
    expect(find.text('Không tìm thấy'), findsOneWidget);
    expect(find.text('Giao dịch điểm không tồn tại'), findsOneWidget);
  });

  testWidgets('SC-200 first viewport exposes linked Arena context', (
    tester,
  ) async {
    await pumpEntry(tester, 'entry-demo');

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-200 ArenaPointsEntryDetailPage',
      semanticLabel: 'Chi tiết giao dịch điểm Arena Points trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaPointsEntryDetailPage.challengeLinkKey),
      routeName: 'SC-200 ArenaPointsEntryDetailPage',
      actionLabel: 'the linked challenge',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-200 detail state supports copy and safe navigation', (
    tester,
  ) async {
    await pumpEntry(tester, 'entry-demo');

    expect(find.text('+240'), findsOneWidget);
    expect(find.text('Challenge reward'), findsOneWidget);
    expect(find.text('ARENA-LEDGER-20260523-ENTRY-DEMO'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ArenaPointsEntryDetailPage.copyRefKey),
    );
    await tester.tap(find.byKey(ArenaPointsEntryDetailPage.copyRefKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã chép'), findsOneWidget);

    await tester.tap(find.text('BTC \$70K? - Tuần 9'));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);

    await pumpEntry(tester, 'entry-demo');
    await tester.ensureVisible(
      find.byKey(ArenaPointsEntryDetailPage.modeLinkKey),
    );
    await tester.tap(find.text('BTC Weekly Predict'));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaModeDetailPage), findsOneWidget);

    await pumpEntry(tester, 'entry-demo');
    await tester.ensureVisible(
      find.byKey(ArenaPointsEntryDetailPage.supportKey),
    );
    await tester.tap(find.byKey(ArenaPointsEntryDetailPage.supportKey));
    await tester.pumpAndSettle();
    expect(find.text('Hỗ trợ đã nhận yêu cầu'), findsOneWidget);
  });
}
