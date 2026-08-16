import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_friend_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpFriendDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.referralFriend('friend001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-289 mock repository exposes friend detail BE draft', () async {
    final snapshot = await const MockReferralRepository(
      loadDelay: Duration.zero,
    ).getFriendDetail('friend001');

    expect(snapshot.endpoint, '/api/mobile/referral/referral-friend-friend001');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Chi tiết bạn bè');
    expect(snapshot.subtitle, 'Bạn bè · Referral');
    expect(snapshot.backRoute, AppRoutePaths.referralHistory);
    expect(snapshot.friendId, 'friend001');
    expect(snapshot.found, isFalse);
    expect(snapshot.emptyTitle, 'Không tìm thấy bạn bè');
    expect(snapshot.emptyMessage, 'ID không hợp lệ hoặc đã bị xóa');
    expect(snapshot.listRoute, AppRoutePaths.referralHistory);
    expect(snapshot.contractNotes, contains('Flutter not-found state'));
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

  testWidgets('SC-289 renders not-found friend detail baseline', (
    tester,
  ) async {
    await pumpFriendDetail(tester);

    expect(find.byType(ReferralFriendDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết bạn bè'), findsOneWidget);
    expect(find.text('Bạn bè · Referral'), findsOneWidget);
    expect(find.byKey(ReferralFriendDetailPage.emptyKey), findsOneWidget);
    expect(find.text('Không tìm thấy bạn bè'), findsOneWidget);
    expect(find.text('ID không hợp lệ hoặc đã bị xóa'), findsOneWidget);
    expect(find.text('Quay lại danh sách'), findsOneWidget);
  });

  testWidgets('SC-289 list CTA navigates back to referral history', (
    tester,
  ) async {
    await pumpFriendDetail(tester);

    await tester.tap(find.byKey(ReferralFriendDetailPage.listButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Lịch sử giới thiệu'), findsOneWidget);
  });

  testWidgets('SC-289 header back navigates back to referral history', (
    tester,
  ) async {
    await pumpFriendDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Lịch sử giới thiệu'), findsOneWidget);
  });
}
