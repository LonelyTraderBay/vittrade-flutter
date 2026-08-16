import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/device_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String route) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: route),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-165 mock repository exposes device management BE draft', () async {
    final snapshot = await const MockProfileRepository().getDeviceManagement();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-devices');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.devices, hasLength(4));
    expect(snapshot.currentDevice?.name, 'Chrome Desktop');
    expect(snapshot.otherDevices, hasLength(3));
    expect(snapshot.trustedCount, 3);
    expect(snapshot.untrustedCount, 1);
    expect(
      snapshot.supportedStates,
      containsAll([
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-165 renders devices with Profile bottom nav active', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileDevices);

    expect(find.byType(DeviceManagementPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('Qu\u1EA3n l\u00FD thi\u1EBFt b\u1ECB'), findsOneWidget);
    expect(find.byKey(DeviceManagementPage.summaryKey), findsOneWidget);
    expect(find.text('B\u1EA3o m\u1EADt thi\u1EBFt b\u1ECB'), findsOneWidget);
    expect(
      find.byKey(DeviceManagementPage.deviceCardKey('dev001')),
      findsOneWidget,
    );
    expect(
      find.byKey(DeviceManagementPage.deviceCardKey('dev004')),
      findsOneWidget,
    );
    expect(find.text('Unknown Device'), findsOneWidget);
    expect(find.text('\u0110\u00E1nh d\u1EA5u tin c\u1EADy'), findsOneWidget);
  });

  testWidgets('SC-165 first viewport reaches current device card', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileDevices);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'DeviceManagementPage',
      semanticLabel: 'Quản lý thiết bị',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(DeviceManagementPage.deviceCardKey('dev001')),
      minVisibleHeight: 24,
      targetLabel: 'current device card',
      reason:
          'Device management must preview the active session above the bottom '
          'navigation after summary and session-risk review.',
    );
  });

  testWidgets('SC-165 supports trust and logout state changes', (tester) async {
    await pumpRoute(tester, AppRoutePaths.profileDevices);

    await tester.ensureVisible(
      find.byKey(DeviceManagementPage.trustKey('dev004')),
    );
    await tester.tap(find.byKey(DeviceManagementPage.trustKey('dev004')));
    await tester.pumpAndSettle();

    expect(find.text('\u0110\u00E1nh d\u1EA5u tin c\u1EADy'), findsNothing);
    expect(find.text('Tin c\u1EADy'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(DeviceManagementPage.logoutKey('dev002')),
    );
    await tester.tap(find.byKey(DeviceManagementPage.logoutKey('dev002')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(DeviceManagementPage.logoutConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('iPhone 15 Pro'), findsNothing);

    await tester.ensureVisible(find.byKey(DeviceManagementPage.logoutAllKey));
    await tester.tap(find.byKey(DeviceManagementPage.logoutAllKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sc165_devices_logout_all_confirm')));
    await tester.pumpAndSettle();

    expect(find.text('MacBook Air'), findsNothing);
    expect(find.text('Unknown Device'), findsNothing);
    expect(
      find.text('C\u00C1C THI\u1EBET B\u1ECA KH\u00C1C (0)'),
      findsOneWidget,
    );
  });

  testWidgets('SC-165 navigation edge from Profile is wired', (tester) async {
    await pumpRoute(tester, AppRoutePaths.profile);

    expect(find.byType(ProfilePage), findsOneWidget);
    await tester.ensureVisible(find.byKey(ProfilePage.menuKey('devices')));
    await tester.tap(find.byKey(ProfilePage.menuKey('devices')));
    await tester.pumpAndSettle();

    expect(find.byType(DeviceManagementPage), findsOneWidget);
    expect(find.text('Chrome Desktop'), findsOneWidget);
  });
}
