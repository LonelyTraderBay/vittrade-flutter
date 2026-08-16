import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/active_copies_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_notifications_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyNotifications(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyNotifications,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-068 mock repository exposes copy notifications BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getCopyNotifications();

    expect(snapshot.notifications, hasLength(7));
    expect(snapshot.defaultTab, 'all');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'all',
      'unread',
      'trade',
      'risk',
      'update',
      'system',
    ]);
    expect(
      snapshot.notifications.first.actionPath,
      AppRoutePaths.tradeCopyActive,
    );
    expect(
      snapshot.notifications.first.severity,
      TradeCopyNotificationSeverity.critical,
    );
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-068 renders CopyNotificationsPage inside the Trade shell', (
    tester,
  ) async {
    await pumpCopyNotifications(tester);

    expect(find.byType(CopyNotificationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('3 thông báo chưa đọc'), findsOneWidget);
    expect(find.text('Cảnh báo rủi ro cao'), findsOneWidget);
    expect(find.text('Lệnh mới được copy'), findsOneWidget);
    expect(find.text('Chốt lời thành công'), findsOneWidget);
  });

  testWidgets('SC-068 first viewport reaches notification filters', (
    tester,
  ) async {
    await pumpCopyNotifications(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-068 CopyNotificationsPage',
      semanticLabel: 'Thông báo',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(CopyNotificationsPage.tabKey('all')),
      routeName: 'SC-068 CopyNotificationsPage',
      actionLabel: 'the all notifications filter',
    );
  });

  testWidgets('SC-068 filters by risk notifications', (tester) async {
    await pumpCopyNotifications(tester);

    final riskTab = find.byKey(CopyNotificationsPage.tabKey('risk'));
    await tester.ensureVisible(riskTab);
    await tester.pumpAndSettle();
    await tester.tap(riskTab);
    await tester.pumpAndSettle();

    expect(find.text('Cảnh báo rủi ro cao'), findsOneWidget);
    expect(find.text('Đã đạt ngưỡng take-profit'), findsOneWidget);
    expect(find.text('Lệnh mới được copy'), findsNothing);
  });

  testWidgets('SC-068 mark all read clears unread summary', (tester) async {
    await pumpCopyNotifications(tester);

    await tester.tap(find.byKey(CopyNotificationsPage.markAllReadKey));
    await tester.pumpAndSettle();

    expect(find.text('3 thông báo chưa đọc'), findsNothing);
    expect(find.text('Cảnh báo rủi ro cao'), findsOneWidget);
  });

  testWidgets('SC-068 settings action navigates to SC-067', (tester) async {
    await pumpCopyNotifications(tester);

    await tester.tap(find.byKey(CopyNotificationsPage.settingsKey));
    await tester.pumpAndSettle();

    expect(find.byType(CopySettingsPage), findsOneWidget);
    expect(find.byType(CopyNotificationsPage), findsNothing);
  });

  testWidgets(
    'SC-068 notification action navigates to SC-066 allowlisted edge',
    (tester) async {
      await pumpCopyNotifications(tester);

      await tester.tap(find.byKey(CopyNotificationsPage.notificationKey('n1')));
      await tester.pumpAndSettle();

      expect(find.byType(ActiveCopiesPage), findsOneWidget);
      expect(find.byType(CopyNotificationsPage), findsNothing);
    },
  );
}
