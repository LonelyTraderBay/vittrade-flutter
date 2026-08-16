import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/notifications/data/notifications_repository.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/phone/pages/notifications_page.dart';
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
            initialLocation: AppRoutePaths.notifications,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-291 mock repository exposes notifications BE draft', () async {
    final snapshot = await const MockNotificationsRepository(
      loadDelay: Duration.zero,
    ).getNotifications();

    expect(snapshot.endpoint, '/api/mobile/notifications/notifications');
    expect(snapshot.actionDraft, 'PATCH /user/settings or module settings');
    expect(snapshot.title, 'Thông báo');
    expect(snapshot.subtitle, 'Thông báo · Hệ thống');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.notifications, hasLength(15));
    expect(snapshot.notifications.where((item) => !item.isRead), hasLength(7));
    expect(snapshot.notifications.first.actionPath, '/trade/orders');
    expect(snapshot.contractNotes, contains('notificationsReferenceData'));
    expect(snapshot.screenState, NotificationsScreenState.ready);
    expect(
      snapshot.supportedStates,
      containsAll([
        NotificationsScreenState.loading,
        NotificationsScreenState.empty,
        NotificationsScreenState.error,
        NotificationsScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-291 renders notifications baseline', (tester) async {
    await pumpNotifications(tester);

    expect(find.byType(NotificationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Thông báo · Hệ thống'), findsOneWidget);
    expect(find.byKey(NotificationsPage.toolbarKey), findsOneWidget);
    expect(find.text('7 chưa đọc'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Đọc tất cả'), findsOneWidget);
    expect(
      find.byKey(NotificationsPage.notificationKey('notif001')),
      findsOneWidget,
    );
    expect(find.text('Lệnh đã khớp'), findsOneWidget);
    expect(find.text('Cảnh báo giá'), findsWidgets);
  });

  testWidgets('SC-291 filter, mark-read, and delete states update', (
    tester,
  ) async {
    await pumpNotifications(tester);

    await tester.tap(find.byKey(NotificationsPage.filterKey));
    await tester.pumpAndSettle();
    expect(find.text('Chưa đọc'), findsOneWidget);
    expect(
      find.byKey(NotificationsPage.notificationKey('notif001')),
      findsOneWidget,
    );
    expect(
      find.byKey(NotificationsPage.notificationKey('notif004')),
      findsNothing,
    );

    await tester.tap(find.byKey(NotificationsPage.deleteKey('notif001')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(NotificationsPage.notificationKey('notif001')),
      findsNothing,
    );
    expect(find.text('6 chưa đọc'), findsOneWidget);

    await tester.tap(find.byKey(NotificationsPage.markAllReadKey));
    await tester.pumpAndSettle();
    expect(find.text('0 chưa đọc'), findsOneWidget);
    expect(find.byKey(NotificationsPage.emptyKey), findsOneWidget);
    expect(find.text('Không có thông báo chưa đọc'), findsOneWidget);
  });

  testWidgets('SC-291 mark all read clears the shell unread badge', (
    tester,
  ) async {
    await pumpNotifications(tester);

    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(NotificationsPage.markAllReadKey));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsNothing,
    );
  });

  testWidgets('SC-291 notification action navigates through safe edge', (
    tester,
  ) async {
    await pumpNotifications(tester);

    final referralReward = find.byKey(
      NotificationsPage.notificationKey('notif008'),
    );
    await tester.ensureVisible(referralReward);
    await tester.tap(referralReward);
    await tester.pumpAndSettle();

    expect(find.text('Phần thưởng'), findsOneWidget);
  });

  testWidgets('SC-291 header back returns to home', (tester) async {
    await pumpNotifications(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('VitTrade'), findsOneWidget);
  });
}
