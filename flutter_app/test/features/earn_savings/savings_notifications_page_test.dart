import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_notifications_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
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
            initialLocation: AppRoutePaths.earnSavingsNotifications,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-337 mock repository exposes savings notifications BE draft',
    () async {
      final snapshot = await const MockSavingsNotificationsRepository()
          .getNotifications();

      expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-notifications');
      expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
      expect(snapshot.settingsActionDraft, contains('PATCH /user/settings'));
      expect(snapshot.clearActionDraft, contains('DELETE'));
      expect(snapshot.title, 'Thông báo Tiết kiệm');
      expect(snapshot.backRoute, AppRoutePaths.earnSavings);
      expect(snapshot.history, hasLength(8));
      expect(snapshot.history.where((item) => !item.read), hasLength(3));
      expect(snapshot.settings, hasLength(8));
      expect(snapshot.settings.where((item) => item.enabled), hasLength(7));
      expect(snapshot.contractNotes, contains('module settings PATCH'));
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

  testWidgets('SC-337 renders notification history baseline', (tester) async {
    await pumpNotifications(tester);

    expect(find.byType(SavingsNotificationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thông báo Tiết kiệm'), findsOneWidget);
    expect(find.text('Thông báo (3)'), findsOneWidget);
    expect(find.text('Cài đặt'), findsOneWidget);
    expect(find.text('8 thông báo · 3 chưa đọc'), findsOneWidget);
    expect(find.byKey(SavingsNotificationsPage.historyListKey), findsOneWidget);
    expect(
      find.byKey(SavingsNotificationsPage.markAllReadButtonKey),
      findsOneWidget,
    );
    expect(find.text('BTC Cố định 60D sắp đáo hạn'), findsOneWidget);
    expect(find.text('APY USDT Linh hoạt tăng lên 4.8%'), findsOneWidget);
  });

  testWidgets('SC-337 marks notifications read and clears history', (
    tester,
  ) async {
    await pumpNotifications(tester);

    await tester.tap(find.byKey(SavingsNotificationsPage.firstNotificationKey));
    await tester.pumpAndSettle();
    expect(find.text('8 thông báo · 2 chưa đọc'), findsOneWidget);

    await tester.tap(find.byKey(SavingsNotificationsPage.markAllReadButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('8 thông báo · 0 chưa đọc'), findsOneWidget);
    expect(
      find.byKey(SavingsNotificationsPage.markAllReadButtonKey),
      findsNothing,
    );

    await tester.ensureVisible(
      find.byKey(SavingsNotificationsPage.clearAllButtonKey),
    );
    await tester.tap(find.byKey(SavingsNotificationsPage.clearAllButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có thông báo'), findsOneWidget);
    expect(find.text('0 thông báo · 0 chưa đọc'), findsOneWidget);
  });

  testWidgets('SC-337 settings tab toggles module notification setting', (
    tester,
  ) async {
    await pumpNotifications(tester);

    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsNotificationsPage.settingsListKey),
      findsOneWidget,
    );
    expect(find.text('Quản lý Thông báo'), findsOneWidget);
    expect(find.textContaining('Đang bật 7/8'), findsOneWidget);
    expect(find.text('Quan trọng'), findsOneWidget);
    expect(find.text('Trung bình'), findsOneWidget);
    expect(find.text('Phụ'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(SavingsNotificationsPage.settingKey('interest-paid')),
    );
    await tester.tap(
      find.byKey(SavingsNotificationsPage.settingKey('interest-paid')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Đang bật 8/8'), findsOneWidget);
  });

  testWidgets('SC-337 back navigation returns to savings page', (tester) async {
    await pumpNotifications(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
