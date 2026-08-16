import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/forgot_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/two_fa_setup_page.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/activity_log_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/security_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSecurity(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.profileSecurity,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-158 mock repository exposes security BE draft', () async {
    final snapshot = await const MockProfileRepository().getSecurity();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-security');
    expect(
      snapshot.actionDraft,
      'PATCH /user/settings + local navigation to auth and activity routes',
    );
    expect(snapshot.score, 3);
    expect(snapshot.scoreLabel, 'Cao');
    expect(snapshot.scoreColorHex, 0xFF10B981);
    expect(snapshot.items.map((item) => item.id), [
      'two-factor',
      'password',
      'withdraw-whitelist',
      'devices',
      'activity',
    ]);
    expect(snapshot.devices, hasLength(3));
    expect(snapshot.devices.first.name, 'iPhone 14 Pro');
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=security'));
    expect(snapshot.supportRoute, contains('profile-security'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ]),
    );
  });

  testWidgets('SC-158 renders security baseline shell', (tester) async {
    await pumpSecurity(tester);

    expect(find.byType(SecurityPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(SecurityPage.supportKey), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('Bảo mật'), findsOneWidget);
    expect(find.text('Bảo mật · Profile'), findsOneWidget);
    expect(find.text('Điểm bảo mật'), findsOneWidget);
    expect(find.text('Cao (3/4)'), findsOneWidget);
    expect(find.text('Xác thực 2 lớp (2FA)'), findsOneWidget);
    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.text('Whitelist địa chỉ rút tiền'), findsOneWidget);
    expect(find.text('Quản lý thiết bị đăng nhập'), findsOneWidget);
    expect(find.text('Nhật ký hoạt động'), findsOneWidget);
    expect(find.text('Đang bật'), findsOneWidget);
    expect(find.text('Chưa cài đặt'), findsOneWidget);
    expect(find.text('Mã chống lừa đảo'), findsOneWidget);
    expect(find.text('Nhập mã 4–8 ký tự'), findsOneWidget);
    expect(find.text('Lưu'), findsOneWidget);
    expect(find.textContaining('Cần rà soát bảo mật'), findsOneWidget);
    expect(
      find.textContaining('Không hoàn tác sau khi xác nhận'),
      findsOneWidget,
    );
  });

  testWidgets('SC-158 first viewport reaches security action list', (
    tester,
  ) async {
    await pumpSecurity(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SecurityPage',
      semanticLabel: 'SC-158 SecurityPage',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(SecurityPage.itemKey('withdraw-whitelist')),
      minVisibleHeight: 20,
      targetLabel: 'withdraw whitelist security action',
      reason:
          'Security review must expose actionable account-protection rows '
          'above the bottom navigation, not only the risk/score summary.',
    );
  });

  testWidgets('SC-158 wires direct navigation and local device reveal', (
    tester,
  ) async {
    await pumpSecurity(tester);

    await tester.tap(find.byKey(SecurityPage.itemKey('two-factor')));
    await tester.pumpAndSettle();
    expect(find.byType(TwoFASetupPage), findsOneWidget);
    expect(find.text('Thiết lập 2FA'), findsOneWidget);

    await pumpSecurity(tester);
    await tester.tap(find.byKey(SecurityPage.itemKey('password')));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.text('Quên mật khẩu'), findsOneWidget);

    await pumpSecurity(tester);
    await tester.tap(find.byKey(SecurityPage.itemKey('devices')));
    await tester.pumpAndSettle();
    expect(find.text('iPhone 14 Pro'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsOneWidget);
    expect(find.text('Samsung Galaxy S23'), findsOneWidget);

    await pumpSecurity(tester);
    await tester.tap(find.byKey(SecurityPage.itemKey('activity')));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityLogPage), findsOneWidget);
    expect(
      find.text('Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng'),
      findsOneWidget,
    );
  });

  testWidgets('SC-158 anti-phishing save stays local', (tester) async {
    await pumpSecurity(tester);

    await tester.enterText(
      find.byKey(SecurityPage.antiPhishingFieldKey),
      'VIT4',
    );
    await tester.tap(find.byKey(SecurityPage.antiPhishingSaveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SecurityPage.antiPhishingConfirmKey));
    await tester.pump();
    expect(find.text('...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 320));
    expect(find.byType(SecurityPage), findsOneWidget);
  });

  testWidgets('SC-158 support opens contextual security support', (
    tester,
  ) async {
    await pumpSecurity(tester);

    await tester.ensureVisible(find.byKey(SecurityPage.supportKey));
    await tester.tap(find.byKey(SecurityPage.supportKey));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Account security support'), findsOneWidget);
    expect(find.text('profile-security'), findsOneWidget);
  });

  testWidgets('SC-413 settings security route uses settings chrome', (
    tester,
  ) async {
    await pumpSecurity(tester, initialLocation: AppRoutePaths.settingsSecurity);

    expect(find.text('C\u00E0i \u0111\u1EB7t \u00B7 Profile'), findsOneWidget);
    expect(find.text('B\u1EA3o m\u1EADt \u00B7 Profile'), findsNothing);
  });

  testWidgets('SC-405 biometric route uses focused subtitle', (tester) async {
    await pumpSecurity(
      tester,
      initialLocation: AppRoutePaths.settingsSecurityBiometric,
    );

    expect(
      find.text('Sinh tr\u1EAFc h\u1ECDc \u00B7 C\u00E0i \u0111\u1EB7t'),
      findsOneWidget,
    );
  });

  testWidgets('SC-406 change-password route uses focused subtitle', (
    tester,
  ) async {
    await pumpSecurity(
      tester,
      initialLocation: AppRoutePaths.settingsSecurityChangePassword,
    );

    expect(
      find.text('M\u1EADt kh\u1EA9u \u00B7 C\u00E0i \u0111\u1EB7t'),
      findsOneWidget,
    );
  });

  testWidgets('SC-158 direct header back returns to profile parent', (
    tester,
  ) async {
    await pumpSecurity(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(SecurityPage), findsNothing);
  });
}
