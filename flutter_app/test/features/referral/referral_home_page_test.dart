import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.referral,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-290 mock repository exposes referral home BE draft', () async {
    final snapshot = await const MockReferralRepository(
      loadDelay: Duration.zero,
    ).getHome();

    expect(snapshot.endpoint, '/api/mobile/referral/referral');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Giới thiệu bạn bè');
    expect(snapshot.subtitle, 'Chương trình · Referral');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.referralCode, 'VITTA-A2B3C');
    expect(snapshot.stats.totalFriends, 8);
    expect(snapshot.stats.kycCompleted, 6);
    expect(snapshot.stats.activeFriends, 5);
    expect(snapshot.currentTier.name, 'Bạc');
    expect(snapshot.nextTier?.name, 'Vàng');
    expect(snapshot.campaign.title, 'Chương trình tháng 3');
    expect(snapshot.detailLinks.map((link) => link.route), [
      AppRoutePaths.referralHistory,
      AppRoutePaths.referralRewards,
      AppRoutePaths.referralRules,
    ]);
    expect(snapshot.contractNotes, contains('Referral home is a read-only'));
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

  testWidgets('SC-290 renders referral home baseline structure', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.byType(ReferralHomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Giới thiệu bạn bè'), findsOneWidget);
    expect(find.text('Chương trình · Referral'), findsOneWidget);
    expect(find.byKey(ReferralHomePage.campaignKey), findsOneWidget);
    expect(find.text('Chương trình tháng 3'), findsWidgets);
    expect(find.byKey(ReferralHomePage.pendingKycKey), findsOneWidget);
    expect(find.byKey(ReferralHomePage.heroKey), findsOneWidget);
    expect(find.text('VITTA-A2B3C'), findsOneWidget);
    expect(find.text('Sao chép link'), findsOneWidget);
    expect(find.byKey(ReferralHomePage.milestoneKey('ms-10')), findsOneWidget);
  });

  testWidgets('SC-290 first viewport reaches referral hero', (tester) async {
    await pumpHome(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-290 ReferralHomePage',
      semanticLabel: 'Giới thiệu bạn bè',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ReferralHomePage.heroKey),
      targetLabel: 'the referral code and sharing hero',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-290 copy and share states are local actions', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(ReferralHomePage.copyLinkKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã sao chép link'), findsOneWidget);

    await tester.ensureVisible(find.byKey(ReferralHomePage.shareKey));
    await tester.tap(find.byKey(ReferralHomePage.shareKey));
    await tester.pumpAndSettle();
    expect(find.text('Chia sẻ lời mời'), findsOneWidget);
    expect(find.text('Sao chép lời mời'), findsOneWidget);
  });

  testWidgets('SC-290 detail links navigate to referral child routes', (
    tester,
  ) async {
    await pumpHome(tester);

    final historyLink = find.byKey(ReferralHomePage.detailHistoryKey);
    await tester.ensureVisible(historyLink);
    await tester.tap(historyLink);
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử giới thiệu'), findsOneWidget);

    await pumpHome(tester);
    final rewardsLink = find.byKey(ReferralHomePage.detailRewardsKey);
    await tester.ensureVisible(rewardsLink);
    await tester.tap(rewardsLink);
    await tester.pumpAndSettle();
    expect(find.text('Phần thưởng'), findsOneWidget);

    await pumpHome(tester);
    final rulesLink = find.byKey(ReferralHomePage.detailRulesKey);
    await tester.ensureVisible(rulesLink);
    await tester.tap(rulesLink);
    await tester.pumpAndSettle();
    expect(find.text('Quy tắc chương trình'), findsOneWidget);
  });

  testWidgets('SC-290 pending KYC banner navigates to history', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(ReferralHomePage.pendingKycKey));
    await tester.pumpAndSettle();

    expect(find.text('Lịch sử giới thiệu'), findsOneWidget);
  });
}
