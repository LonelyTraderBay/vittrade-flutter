import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_notifications_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpNotifications(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSettingsNotifications,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-278 mock repository exposes notifications BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getNotificationSettings();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-settings-notifications');
    expect(snapshot.actionDraft, contains('PATCH /user/settings'));
    expect(snapshot.title, 'Thông báo P2P');
    expect(snapshot.subtitle, 'Thông báo · P2P');
    expect(snapshot.heroTitle, 'Cài đặt thông báo');
    expect(snapshot.settings, hasLength(5));
    expect(snapshot.settings.first.id, 'order_updates');
    expect(snapshot.settings.first.channels['push'], isTrue);
    expect(snapshot.settings.first.channels['sms'], isFalse);
    expect(snapshot.parentRoute, AppRoutePaths.p2pSettings);
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

  testWidgets('SC-278 renders notification settings baseline', (tester) async {
    await pumpNotifications(tester);

    expect(find.byType(P2PNotificationsSettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thông báo P2P'), findsOneWidget);
    expect(find.text('Thông báo · P2P'), findsOneWidget);
    expect(find.byKey(P2PNotificationsSettingsPage.heroKey), findsOneWidget);
    expect(find.byType(VitModuleHeroCard), findsOneWidget);
    expect(find.byType(VitMetricCard), findsOneWidget);
    expect(find.text('Cài đặt thông báo'), findsOneWidget);
    expect(find.text('Cập nhật đơn hàng'), findsOneWidget);
    expect(find.text('Đã nhận thanh toán'), findsOneWidget);
    expect(find.text('Nhắc release'), findsOneWidget);
    expect(find.text('Cảnh báo bảo mật'), findsOneWidget);
    expect(find.text('Cập nhật KYC'), findsOneWidget);
    expect(
      find.byKey(
        P2PNotificationsSettingsPage.channelKey('order_updates', 'push'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-278 remains stable at the 360px phone baseline', (
    tester,
  ) async {
    await pumpNotifications(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PNotificationsSettingsPage), findsOneWidget);
    expect(find.byKey(P2PNotificationsSettingsPage.summaryKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-278 first viewport reaches notification controls', (
    tester,
  ) async {
    await pumpNotifications(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-278 P2PNotificationsSettingsPage',
      semanticLabel: 'Cài đặt thông báo P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(
        P2PNotificationsSettingsPage.channelKey('order_updates', 'push'),
      ),
      routeName: 'SC-278 P2PNotificationsSettingsPage',
      actionLabel: 'order update push toggle',
      minVisibleHeight: 44,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(
        P2PNotificationsSettingsPage.channelKey('payment_received', 'push'),
      ),
      routeName: 'SC-278 P2PNotificationsSettingsPage',
      actionLabel: 'payment received push toggle',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-278 toggles a notification channel', (tester) async {
    await pumpNotifications(tester);

    final smsKey = P2PNotificationsSettingsPage.channelKey(
      'order_updates',
      'sms',
    );
    final before = tester.widget<VitChoicePill>(find.byKey(smsKey));
    expect(before.selected, isFalse);

    await tester.tap(find.byKey(smsKey));
    await tester.pumpAndSettle();

    final after = tester.widget<VitChoicePill>(find.byKey(smsKey));
    expect(after.selected, isTrue);
  });

  testWidgets('SC-278 header back returns to settings parent', (tester) async {
    await pumpNotifications(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PNotificationsSettingsPage), findsNothing);
    expect(find.byType(P2PSettingsPage), findsOneWidget);
  });
}
