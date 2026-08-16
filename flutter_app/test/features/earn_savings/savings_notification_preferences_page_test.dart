import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_notification_preferences_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpPreferences(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsNotificationPreferences,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-345 mock repository exposes notification preferences BE draft',
    () async {
      final snapshot =
          await const MockSavingsNotificationPreferencesRepository()
              .getPreferences();

      expect(
        snapshot.endpoint,
        '/api/mobile/earn/earn-savings-notification-preferences',
      );
      expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
      expect(snapshot.title, 'Cài đặt thông báo');
      expect(snapshot.backRoute, AppRoutePaths.earnSavings);
      expect(snapshot.tabs.map((tab) => tab.label), [
        'Sự kiện',
        'Sản phẩm',
        'Kênh & Lịch',
      ]);
      expect(snapshot.alerts, hasLength(13));
      expect(snapshot.alerts.where((alert) => alert.enabled), hasLength(10));
      expect(snapshot.channels, hasLength(4));
      expect(
        snapshot.channels.where((channel) => channel.enabled),
        hasLength(3),
      );
      expect(snapshot.digestFrequency, SavingsDeliveryFrequency.instant);
      expect(snapshot.quietHours.enabled, isFalse);
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

  testWidgets('SC-345 renders event preferences baseline', (tester) async {
    await pumpPreferences(tester);

    expect(find.byType(SavingsNotificationPreferencesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cài đặt thông báo'), findsOneWidget);
    expect(
      find.byKey(SavingsNotificationPreferencesPage.summaryKey),
      findsOneWidget,
    );
    expect(find.text('Thông báo đang bật'), findsOneWidget);
    expect(find.text('10/13 loại thông báo đang hoạt động'), findsOneWidget);
    expect(
      find.byKey(SavingsNotificationPreferencesPage.statsKey),
      findsOneWidget,
    );
    expect(find.text('3/4'), findsOneWidget);
    expect(find.text('Ngay lập tức'), findsOneWidget);
    expect(
      find.byKey(SavingsNotificationPreferencesPage.eventsListKey),
      findsOneWidget,
    );
    expect(find.text('Sản phẩm'), findsWidgets);
    expect(find.text('Thay đổi APY'), findsOneWidget);
    expect(find.text('Sắp đáo hạn'), findsOneWidget);
  });

  testWidgets('SC-345 supports product and delivery tabs', (tester) async {
    await pumpPreferences(tester);

    await tester.tap(find.text('Sản phẩm').first);
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsNotificationPreferencesPage.productsListKey),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsNotificationPreferencesPage.productKey('ms2')),
      findsOneWidget,
    );
    expect(find.text('BTC Cố định 60D'), findsOneWidget);

    await tester.tap(find.text('Kênh & Lịch'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsNotificationPreferencesPage.deliveryListKey),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsNotificationPreferencesPage.channelKey('push')),
      findsOneWidget,
    );
    expect(find.text('Push Notification'), findsOneWidget);
    expect(find.text('Lưu tất cả cài đặt'), findsOneWidget);
  });

  testWidgets('SC-345 master toggle disables alert count locally', (
    tester,
  ) async {
    await pumpPreferences(tester);

    await tester.tap(
      find.byKey(SavingsNotificationPreferencesPage.masterToggleKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thông báo đã tắt'), findsOneWidget);
    expect(find.text('0/13 loại thông báo đang hoạt động'), findsOneWidget);
  });

  testWidgets('SC-345 header back returns to savings overview', (tester) async {
    await pumpPreferences(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
