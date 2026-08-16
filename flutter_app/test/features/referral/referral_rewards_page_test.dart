import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_rewards_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRewards(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.referralRewards,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-287 mock repository exposes referral rewards BE draft', () async {
    final snapshot = await const MockReferralRepository(
      loadDelay: Duration.zero,
    ).getRewards();

    expect(snapshot.endpoint, '/api/mobile/referral/referral-rewards');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Phần thưởng');
    expect(snapshot.subtitle, 'Phần thưởng · Referral');
    expect(snapshot.backRoute, AppRoutePaths.referral);
    expect(snapshot.totalCommission, 128.9);
    expect(snapshot.pendingCommission, 10);
    expect(snapshot.kycBonusTotal, 20);
    expect(snapshot.tradeCommissionTotal, 108.9);
    expect(snapshot.records.length, 14);
    expect(snapshot.completedCount, 12);
    expect(snapshot.pendingCount, 2);
    expect(snapshot.contractNotes, contains('read-only ledger'));
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

  testWidgets('SC-287 renders referral rewards baseline', (tester) async {
    await pumpRewards(tester);

    expect(find.byType(ReferralRewardsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phần thưởng'), findsOneWidget);
    expect(find.text('Phần thưởng · Referral'), findsOneWidget);
    expect(find.byKey(ReferralRewardsPage.heroKey), findsOneWidget);
    expect(find.text('\$128.90'), findsOneWidget);
    expect(find.text('Thưởng KYC'), findsWidgets);
    expect(find.text('Hoa hồng GD'), findsWidgets);
    expect(find.byKey(ReferralRewardsPage.chartKey), findsOneWidget);
    expect(find.byKey(ReferralRewardsPage.tabsKey), findsOneWidget);
    expect(find.byKey(ReferralRewardsPage.ledgerKey), findsOneWidget);
    expect(find.byKey(ReferralRewardsPage.recordKey('cr-01')), findsOneWidget);
    expect(find.text('Hoàng Đạt V.'), findsWidgets);
    expect(find.text('+\$22.30'), findsOneWidget);
  });

  testWidgets('SC-287 filter and sort controls update ledger state', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.tap(
      find.byKey(ReferralRewardsPage.tabKey(ReferralRewardFilter.kycBonus)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(ReferralRewardsPage.recordKey('cr-03')), findsOneWidget);
    expect(find.byKey(ReferralRewardsPage.recordKey('cr-01')), findsNothing);
    expect(find.text('~\$5.00'), findsWidgets);

    await tester.tap(
      find.byKey(ReferralRewardsPage.tabKey(ReferralRewardFilter.all)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ReferralRewardsPage.sortOptionKey(ReferralRewardSort.amount)),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(ReferralRewardsPage.sortOptionKey(ReferralRewardSort.amount)),
      findsOneWidget,
    );
    expect(find.byKey(ReferralRewardsPage.recordKey('cr-01')), findsOneWidget);
  });

  testWidgets('SC-287 first viewport reaches rewards chart', (tester) async {
    await pumpRewards(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-287 ReferralRewardsPage',
      semanticLabel: 'Phần thưởng',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ReferralRewardsPage.chartKey),
      targetLabel: 'the referral rewards chart',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-287 local export and dispute actions open safe sheets', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.tap(find.byKey(ReferralRewardsPage.exportKey));
    await tester.pumpAndSettle();
    expect(find.text('Xuất báo cáo hoa hồng'), findsOneWidget);
    final csvButtonTopLeft = tester.getTopLeft(
      find.ancestor(
        of: find.text('Tải xuống CSV'),
        matching: find.byType(VitCtaButton),
      ),
    );
    await tester.tapAt(csvButtonTopLeft + const Offset(24, 12));
    await tester.pumpAndSettle();

    final firstReport = find.byKey(ReferralRewardsPage.reportKey('cr-01'));
    await tester.ensureVisible(firstReport);
    await tester.tap(firstReport);
    await tester.pumpAndSettle();
    expect(find.text('Báo lỗi hoa hồng'), findsOneWidget);
    expect(find.text('Thiếu hoa hồng'), findsOneWidget);
    await tester.tap(find.text('Gửi báo lỗi'));
    await tester.pumpAndSettle();

    final disputeHistory = find.byKey(ReferralRewardsPage.disputeHistoryKey);
    await tester.ensureVisible(disputeHistory);
    await tester.tap(disputeHistory);
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử báo lỗi'), findsWidgets);
    expect(find.text('DISP-001'), findsOneWidget);
  });

  testWidgets('SC-287 back navigation opens migrated referral home', (
    tester,
  ) async {
    await pumpRewards(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Giới thiệu bạn bè'), findsOneWidget);
  });
}
