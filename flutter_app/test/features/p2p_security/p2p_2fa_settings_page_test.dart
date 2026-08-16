import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_2fa_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<GoRouter> pumpTwoFactorSettings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(
      initialLocation: AppRoutePaths.p2pSecurity2fa,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    return router;
  }

  test('SC-254 mock repository exposes 2FA settings BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getTwoFactorSettings();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-security-2fa');
    expect(
      snapshot.actionDraft,
      'POST /auth/verify-factor; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.methods, hasLength(3));
    expect(snapshot.thresholds, hasLength(3));
    expect(snapshot.methods.first.isPrimary, isTrue);
    expect(snapshot.methods[1].setupRequired, isTrue);
    expect(snapshot.thresholds[1].enabled, isFalse);
    expect(snapshot.parentRoute, AppRoutePaths.p2pSecurityCenter);
    expect(snapshot.contractNotes, contains('High-risk action'));
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

  testWidgets('SC-254 renders 2FA settings baseline', (tester) async {
    await pumpTwoFactorSettings(tester);

    expect(find.byType(P2P2FASettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('2FA cho P2P'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2P2FASettingsPage.statusKey), findsOneWidget);
    expect(find.text('2FA đã bật (2 phương thức)'), findsOneWidget);
    expect(find.text('Phương thức chính: SMS OTP'), findsOneWidget);
    expect(find.byKey(P2P2FASettingsPage.methodsKey), findsOneWidget);
    expect(find.text('Phương thức xác thực'), findsOneWidget);
    expect(find.text('SMS OTP'), findsOneWidget);
    expect(find.text('Authenticator App'), findsOneWidget);
    expect(find.text('Email OTP'), findsOneWidget);
    expect(
      find.text('Cần setup Authenticator App trước khi sử dụng'),
      findsOneWidget,
    );
    expect(find.byKey(P2P2FASettingsPage.thresholdsKey), findsOneWidget);
    expect(find.text('Ngưỡng giao dịch'), findsOneWidget);
    expect(find.text('Release Escrow'), findsOneWidget);
    expect(find.text('Create Order'), findsOneWidget);
    expect(find.text('Cancel Order'), findsOneWidget);
    expect(find.byKey(P2P2FASettingsPage.recommendationKey), findsOneWidget);
    expect(find.text('Khuyến nghị bảo mật'), findsOneWidget);
  });

  testWidgets('SC-254 toggles a disabled transaction threshold', (
    tester,
  ) async {
    await pumpTwoFactorSettings(tester);

    expect(find.text('≥ 50,000,000 VND'), findsNothing);

    await tester.tap(
      find.byKey(P2P2FASettingsPage.thresholdSwitchKey('create_order')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2P2FASettingsPage.dialogConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('≥ 50,000,000 VND'), findsOneWidget);
  });

  testWidgets('SC-254 can enable authenticator method in mock state', (
    tester,
  ) async {
    await pumpTwoFactorSettings(tester);

    expect(find.text('2FA đã bật (2 phương thức)'), findsOneWidget);

    await tester.tap(
      find.byKey(P2P2FASettingsPage.methodSwitchKey('2fa_authenticator')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2P2FASettingsPage.dialogConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('2FA đã bật (3 phương thức)'), findsOneWidget);
    expect(
      find.text('Cần setup Authenticator App trước khi sử dụng'),
      findsNothing,
    );
  });

  testWidgets('SC-254 can set a new primary 2FA method', (tester) async {
    await pumpTwoFactorSettings(tester);

    expect(find.text('Phương thức chính: SMS OTP'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(P2P2FASettingsPage.methodKey('2fa_email')),
        matching: find.text('Đặt làm phương thức chính'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2P2FASettingsPage.dialogConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức chính: Email OTP'), findsOneWidget);
  });

  testWidgets('SC-254 back returns to security center', (tester) async {
    await pumpTwoFactorSettings(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
  });

  testWidgets('SC-254 round-trip: enabling authenticator method survives '
      'navigating away and back (state lives in the Notifier)', (tester) async {
    final router = await pumpTwoFactorSettings(tester);

    await tester.tap(
      find.byKey(P2P2FASettingsPage.methodSwitchKey('2fa_authenticator')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2P2FASettingsPage.dialogConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('2FA đã bật (3 phương thức)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);

    router.go(AppRoutePaths.p2pSecurity2fa);
    await tester.pumpAndSettle();

    expect(find.text('2FA đã bật (3 phương thức)'), findsOneWidget);
    expect(
      find.text('Cần setup Authenticator App trước khi sử dụng'),
      findsNothing,
    );
  });
}
