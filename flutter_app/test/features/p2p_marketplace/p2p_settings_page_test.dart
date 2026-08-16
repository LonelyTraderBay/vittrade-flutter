import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_blacklist_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_settings_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/device_management_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSettings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-279 mock repository exposes settings BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getSettings();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-settings');
    expect(snapshot.actionDraft, contains('PATCH /user/settings'));
    expect(snapshot.title, 'Cài đặt P2P');
    expect(snapshot.subtitle, 'Cài đặt · P2P');
    expect(snapshot.assetOptions, ['USDT', 'BTC', 'ETH', 'BNB']);
    expect(snapshot.currencyOptions, ['VND', 'USD', 'EUR']);
    expect(snapshot.paymentWindows, ['15', '30', '60']);
    expect(snapshot.defaultAsset, 'USDT');
    expect(snapshot.defaultCurrency, 'VND');
    expect(snapshot.defaultPaymentWindow, '15');
    expect(snapshot.notificationToggles, hasLength(5));
    expect(snapshot.privacyToggles, hasLength(4));
    expect(snapshot.securityToggles, hasLength(3));
    expect(snapshot.autoReply.buyTemplate, contains('chuyển khoản'));
    expect(snapshot.notificationsRoute, AppRoutePaths.p2pSettingsNotifications);
    expect(snapshot.trustedDevicesRoute, AppRoutePaths.profileDevices);
    expect(snapshot.blacklistRoute, AppRoutePaths.p2pBlacklist);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
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

  testWidgets('SC-279 renders P2P settings baseline', (tester) async {
    await pumpSettings(tester);

    expect(find.byType(P2PSettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cài đặt P2P'), findsOneWidget);
    expect(find.text('Cài đặt · P2P'), findsOneWidget);
    expect(find.byKey(P2PSettingsPage.tradeOptionsKey), findsOneWidget);
    expect(find.text('Tùy chọn giao dịch'), findsOneWidget);
    expect(find.text('Tài sản mặc định'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.text('15 phút'), findsOneWidget);
    expect(find.byKey(P2PSettingsPage.notificationsKey), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Đơn hàng'), findsOneWidget);
    expect(find.byKey(P2PSettingsPage.privacyKey), findsOneWidget);
    expect(find.text('Quyền riêng tư'), findsOneWidget);
    expect(find.byKey(P2PSettingsPage.securityKey), findsOneWidget);
    expect(find.text('Bảo mật giao dịch'), findsOneWidget);
    expect(find.text('Giờ giao dịch'), findsOneWidget);
    expect(find.text('Tin nhắn tự động'), findsOneWidget);
    expect(find.byKey(P2PSettingsPage.saveKey), findsOneWidget);
  });

  testWidgets('SC-279 supports option, toggle, and save states', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.tap(find.byKey(P2PSettingsPage.optionKey('asset', 'BTC')));
    await tester.pumpAndSettle();
    final btcChip = tester.widget<VitChoicePill>(
      find.byKey(P2PSettingsPage.optionKey('asset', 'BTC')),
    );
    expect(btcChip.selected, isTrue);

    await tester.ensureVisible(find.byKey(P2PSettingsPage.hoursKey));
    await tester.tap(find.text('Tùy chỉnh'));
    await tester.pumpAndSettle();
    expect(find.textContaining('08:00 đến 22:00'), findsOneWidget);

    await tester.tap(find.byKey(P2PSettingsPage.toggleKey('auto_reply')));
    await tester.pumpAndSettle();
    expect(find.text('Mẫu tin nhắn MUA'), findsNothing);

    await tester.tap(find.byKey(P2PSettingsPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã lưu thành công!'), findsOneWidget);
  });

  testWidgets('SC-279 blacklist navigation edge is wired', (tester) async {
    await pumpSettings(tester);

    await tester.ensureVisible(find.byKey(P2PSettingsPage.blacklistKey));
    await tester.tap(find.byKey(P2PSettingsPage.blacklistKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistPage), findsOneWidget);
  });

  testWidgets('SC-279 trusted devices navigation edge is wired', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.ensureVisible(find.byKey(P2PSettingsPage.trustedDevicesKey));
    await tester.tap(find.byKey(P2PSettingsPage.trustedDevicesKey));
    await tester.pumpAndSettle();

    expect(find.byType(DeviceManagementPage), findsOneWidget);
  });

  testWidgets('SC-279 header back returns to P2P parent', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PSettingsPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}
