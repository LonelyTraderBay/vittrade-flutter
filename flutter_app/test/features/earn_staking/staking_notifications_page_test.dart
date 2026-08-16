import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_notifications_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpNotifications(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnNotifications,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-371 mock repository exposes staking notifications BE draft',
    () async {
      final snapshot = await const MockStakingNotificationsRepository()
          .getNotifications();

      expect(snapshot.endpoint, '/api/mobile/earn/earn-notifications');
      expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
      expect(snapshot.settingsActionDraft, contains('PATCH /user/settings'));
      expect(snapshot.title, 'Thông báo');
      expect(snapshot.backRoute, AppRoutePaths.earnStaking);
      expect(snapshot.settings, hasLength(8));
      expect(snapshot.channels, hasLength(3));
      expect(snapshot.history, hasLength(5));
      expect(snapshot.history.where((item) => !item.read), hasLength(2));
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
    },
  );

  testWidgets('SC-371 renders notification settings baseline', (tester) async {
    await pumpNotifications(tester);

    expect(find.byType(StakingNotificationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.byKey(StakingNotificationsPage.infoKey), findsOneWidget);
    expect(find.text('Quản lý Thông báo'), findsOneWidget);
    expect(find.byKey(StakingNotificationsPage.settingsKey), findsOneWidget);
    expect(
      find.byKey(StakingNotificationsPage.settingKey('maturity')),
      findsOneWidget,
    );
    expect(find.text('Vị thế sắp đáo hạn'), findsOneWidget);
    expect(find.text('Thay đổi APY'), findsOneWidget);
    expect(find.text('Phần thưởng sẵn sàng'), findsOneWidget);
    expect(find.text('Quan trọng'), findsWidgets);
  });

  testWidgets('SC-371 toggles settings and channels', (tester) async {
    await pumpNotifications(tester);

    await tester.tap(
      find.byKey(StakingNotificationsPage.settingKey('reward-ready')),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(StakingNotificationsPage.channelsKey),
    );
    expect(find.text('Push Notification (App)'), findsOneWidget);
    await tester.tap(find.byKey(StakingNotificationsPage.channelKey('sms')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingNotificationsPage.channelsKey), findsOneWidget);
  });

  testWidgets('SC-371 history mark read flow works', (tester) async {
    await pumpNotifications(tester);

    await tester.ensureVisible(find.byKey(StakingNotificationsPage.historyKey));
    expect(find.text('Lịch sử (2 chưa đọc)'), findsOneWidget);

    await tester.tap(
      find.byKey(StakingNotificationsPage.notificationKey('n1')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử (1 chưa đọc)'), findsOneWidget);

    await tester.tap(find.byKey(StakingNotificationsPage.markAllReadKey));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử (0 chưa đọc)'), findsOneWidget);
  });

  testWidgets('SC-371 DND and back navigation are wired', (tester) async {
    await pumpNotifications(tester);

    await tester.ensureVisible(find.byKey(StakingNotificationsPage.dndKey));
    expect(find.text('Chế độ Không làm phiền'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
