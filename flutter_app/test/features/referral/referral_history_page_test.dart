import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_history_page.dart';
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
            initialLocation: AppRoutePaths.referralHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-286 mock repository exposes referral history BE draft', () async {
    final snapshot = await const MockReferralRepository(
      loadDelay: Duration.zero,
    ).getHistory();

    expect(snapshot.endpoint, '/api/mobile/referral/referral-history');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Lịch sử giới thiệu');
    expect(snapshot.subtitle, 'Lịch sử · Referral');
    expect(snapshot.backRoute, AppRoutePaths.referral);
    expect(snapshot.stats.totalFriends, 8);
    expect(snapshot.stats.kycCompleted, 6);
    expect(snapshot.stats.activeFriends, 5);
    expect(snapshot.filters.map((filter) => filter.count), [8, 5, 1, 2]);
    expect(snapshot.friends.map((friend) => friend.id).first, 'friend001');
    expect(snapshot.contractNotes, contains('Referral history is read-only'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-286 renders referral history baseline', (tester) async {
    await pumpHistory(tester);

    expect(find.byType(ReferralHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử giới thiệu'), findsOneWidget);
    expect(find.text('Lịch sử · Referral'), findsOneWidget);
    expect(find.byKey(ReferralHistoryPage.statsKey), findsOneWidget);
    expect(find.text('Tổng bạn bè'), findsOneWidget);
    expect(find.text('Đã KYC'), findsWidgets);
    expect(find.text('Hoạt động'), findsOneWidget);
    expect(find.byKey(ReferralHistoryPage.searchKey), findsOneWidget);
    expect(find.byKey(ReferralHistoryPage.filtersKey), findsOneWidget);
    expect(find.text('Tất cả (8)'), findsOneWidget);
    expect(find.text('Đang GD (5)'), findsOneWidget);
    expect(find.text('Chờ KYC (2)'), findsOneWidget);
    expect(find.byKey(ReferralHistoryPage.sortKey), findsOneWidget);
    expect(find.text('Ngày tham gia'), findsOneWidget);
    expect(
      find.byKey(ReferralHistoryPage.friendKey('friend001')),
      findsOneWidget,
    );
    expect(find.text('Nguyễn Thanh T.'), findsOneWidget);
    expect(find.text('+\$46.90'), findsOneWidget);
  });

  testWidgets('SC-286 search, filter, sort, and reminder states update', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.enterText(find.byType(TextField).first, 'Trần');
    await tester.pumpAndSettle();
    expect(find.text('Trần Văn H.'), findsOneWidget);
    expect(find.text('Nguyễn Thanh T.'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    final pendingKycFilter = find.byKey(
      ReferralHistoryPage.filterKey(ReferralFriendFilter.pendingKyc),
    );
    await tester.ensureVisible(pendingKycFilter);
    await tester.tap(pendingKycFilter);
    await tester.pumpAndSettle();
    expect(find.text('Đỗ Quốc B.'), findsOneWidget);
    expect(find.text('Bùi Anh K.'), findsOneWidget);
    expect(find.text('Nguyễn Thanh T.'), findsNothing);

    await tester.tap(
      find.byKey(
        ReferralHistoryPage.sortOptionKey(ReferralHistorySort.commission),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Đỗ Quốc B.'), findsOneWidget);

    await tester.tap(find.byKey(ReferralHistoryPage.remindKey('friend007')));
    await tester.pumpAndSettle();
    expect(find.text('Đã nhắc KYC'), findsOneWidget);
  });

  testWidgets('SC-286 friend row navigation uses safe detail placeholder', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(ReferralHistoryPage.friendKey('friend001')));
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy bạn bè'), findsOneWidget);
  });
}
