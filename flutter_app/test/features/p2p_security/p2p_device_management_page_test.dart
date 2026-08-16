import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_device_management_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpDeviceManagement(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSecurityDevices,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-255 mock repository exposes device management BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDeviceManagement();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-security-devices');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.devices, hasLength(4));
    expect(snapshot.trustedDevices, hasLength(3));
    expect(snapshot.untrustedDevices, hasLength(1));
    expect(snapshot.securityTips, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2pSecurityCenter);
    expect(snapshot.contractNotes, contains('Reference/admin surface'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-255 renders device management baseline', (tester) async {
    await pumpDeviceManagement(tester);

    expect(find.byType(P2PDeviceManagementPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Quản lý thiết bị'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2PDeviceManagementPage.statsKey), findsOneWidget);
    expect(find.text('Tổng số'), findsOneWidget);
    expect(find.text('Tin cậy'), findsOneWidget);
    expect(find.text('Chưa tin cậy'), findsOneWidget);
    expect(find.byKey(P2PDeviceManagementPage.infoKey), findsOneWidget);
    expect(find.text('Thiết bị tin cậy'), findsOneWidget);
    expect(
      find.byKey(P2PDeviceManagementPage.trustedSectionKey),
      findsOneWidget,
    );
    expect(find.text('Thiết bị tin cậy (3)'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsOneWidget);
    expect(find.text('iPad Pro'), findsOneWidget);
    expect(find.byKey(P2PDeviceManagementPage.otherSectionKey), findsOneWidget);
    expect(find.text('Thiết bị khác (1)'), findsOneWidget);
    expect(find.text('Samsung Galaxy S24'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PDeviceManagementPage.tipsKey));
    expect(find.text('Mẹo bảo mật'), findsOneWidget);
    expect(
      find.text('Kiểm tra thường xuyên danh sách thiết bị'),
      findsOneWidget,
    );
  });

  testWidgets('SC-255 expands and trusts an untrusted device', (tester) async {
    await pumpDeviceManagement(tester);

    await tester.tap(
      find.byKey(P2PDeviceManagementPage.deviceKey('device_samsung_s24')),
    );
    await tester.pumpAndSettle();

    expect(find.text('IP Address'), findsOneWidget);
    expect(find.text('14.231.56.12'), findsOneWidget);
    expect(
      find.byKey(P2PDeviceManagementPage.trustButtonKey('device_samsung_s24')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(P2PDeviceManagementPage.trustButtonKey('device_samsung_s24')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(P2PDeviceManagementPage.trustButtonKey('device_samsung_s24')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thiết bị tin cậy (4)'), findsOneWidget);
    expect(find.text('Thiết bị khác (1)'), findsNothing);
    expect(find.text('Hủy tin cậy'), findsOneWidget);
  });

  testWidgets('SC-255 revokes trust after confirming the dialog', (
    tester,
  ) async {
    await pumpDeviceManagement(tester);

    await tester.tap(
      find.byKey(P2PDeviceManagementPage.deviceKey('device_macbook')),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(P2PDeviceManagementPage.revokeButtonKey('device_macbook')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(P2PDeviceManagementPage.revokeButtonKey('device_macbook')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thu hồi tin cậy thiết bị?'), findsOneWidget);

    await tester.tap(find.byKey(P2PDeviceManagementPage.revokeConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('Thiết bị tin cậy (2)'), findsOneWidget);
    expect(find.text('Thiết bị khác (2)'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsOneWidget);
  });

  testWidgets('SC-255 removes a device after confirming the dialog', (
    tester,
  ) async {
    await pumpDeviceManagement(tester);

    await tester.tap(
      find.byKey(P2PDeviceManagementPage.deviceKey('device_ipad_pro')),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(P2PDeviceManagementPage.removeButtonKey('device_ipad_pro')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(P2PDeviceManagementPage.removeButtonKey('device_ipad_pro')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Xóa thiết bị?'), findsOneWidget);

    await tester.tap(find.byKey(P2PDeviceManagementPage.removeConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('Thiết bị tin cậy (2)'), findsOneWidget);
    expect(find.text('iPad Pro'), findsNothing);
  });

  testWidgets('SC-255 back returns to P2P security center', (tester) async {
    await pumpDeviceManagement(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
  });
}
