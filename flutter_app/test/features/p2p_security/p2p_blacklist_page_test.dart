import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_blacklist_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBlacklist(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pBlacklist,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-277 mock repository exposes blacklist BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getBlacklist();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-blacklist');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Danh sách chặn');
    expect(snapshot.subtitle, 'An toàn · P2P');
    expect(snapshot.searchHint, 'Tìm người dùng đã chặn...');
    expect(snapshot.entries, hasLength(5));
    expect(snapshot.reasons, hasLength(5));
    expect(snapshot.reasonCounts['fake_payment'], 1);
    expect(snapshot.recent30dCount, 0);
    expect(snapshot.addRoute, AppRoutePaths.p2pBlacklistAdd);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-277 renders blacklist baseline', (tester) async {
    await pumpBlacklist(tester);

    expect(find.byType(P2PBlacklistPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Danh sách chặn'), findsOneWidget);
    expect(find.text('An toàn · P2P'), findsOneWidget);
    expect(find.byKey(P2PBlacklistPage.summaryKey), findsOneWidget);
    expect(find.text('5'), findsWidgets);
    expect(find.text('Đã chặn'), findsOneWidget);
    expect(find.text('30 ngày qua'), findsOneWidget);
    expect(find.byKey(P2PBlacklistPage.searchKey), findsOneWidget);
    expect(find.text('Tất cả (5)'), findsOneWidget);
    expect(find.text('Lừa đảo (1)'), findsOneWidget);
    expect(find.text('5 kết quả'), findsOneWidget);
    expect(find.byKey(P2PBlacklistPage.entryKey('bl001')), findsOneWidget);
    expect(find.text('FakeTrader88'), findsOneWidget);
    expect(find.text('SlowPay_VN'), findsOneWidget);
    expect(find.text('Về danh sách chặn'), findsOneWidget);
  });

  testWidgets('SC-277 first viewport reaches search and first entry', (
    tester,
  ) async {
    await pumpBlacklist(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-277 P2PBlacklistPage',
      semanticLabel: 'Danh sách chặn P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PBlacklistPage.searchKey),
      routeName: 'SC-277 P2PBlacklistPage',
      actionLabel: 'blacklist search',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PBlacklistPage.entryKey('bl001')),
      routeName: 'SC-277 P2PBlacklistPage',
      actionLabel: 'first blocked user row',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-277 filters blocked users by reason', (tester) async {
    await pumpBlacklist(tester);

    await tester.tap(find.byKey(P2PBlacklistPage.filterKey('scam')));
    await tester.pumpAndSettle();

    expect(find.text('1 kết quả'), findsOneWidget);
    expect(find.text('Scammer_X'), findsOneWidget);
    expect(find.text('FakeTrader88'), findsNothing);
  });

  testWidgets('SC-277 search filters blocked user list', (tester) async {
    await pumpBlacklist(tester);

    await tester.enterText(find.byType(TextField).first, 'slow');
    await tester.pumpAndSettle();

    expect(find.text('1 kết quả'), findsOneWidget);
    expect(find.text('SlowPay_VN'), findsOneWidget);
    expect(find.text('FakeTrader88'), findsNothing);
  });

  testWidgets('SC-277 add action navigates to blacklist add', (tester) async {
    await pumpBlacklist(tester);

    await tester.tap(find.byKey(P2PBlacklistPage.addKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistAddPage), findsOneWidget);
  });

  testWidgets('SC-277 expands and unblocks an entry', (tester) async {
    await pumpBlacklist(tester);

    await tester.tap(find.byKey(P2PBlacklistPage.entryKey('bl001')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Gửi biên lai'), findsOneWidget);

    await tester.tap(find.byKey(P2PBlacklistPage.unblockKey('bl001')));
    await tester.pumpAndSettle();

    expect(find.text('4 kết quả'), findsOneWidget);
    expect(find.text('FakeTrader88'), findsNothing);
  });

  testWidgets('SC-277 header back returns to P2P parent', (tester) async {
    await pumpBlacklist(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}
