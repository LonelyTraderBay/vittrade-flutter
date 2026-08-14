import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/otp_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/two_fa_setup_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void _setPhoneViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(440, 956);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _app({ShellRenderMode shellRenderMode = ShellRenderMode.native}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const MockAuthRepository(delay: Duration.zero),
      ),
    ],
    child: VitTradeApp(
      shellRenderMode: shellRenderMode,
      routerConfig: createAppRouter(
        initialLocation: AppRoutePaths.auth2faSetup,
        shellRenderMode: shellRenderMode,
      ),
    ),
  );
}

Future<void> _openVerifyStep(WidgetTester tester) async {
  await tester.tap(find.byKey(TwoFASetupPage.submitKey));
  await tester.pumpAndSettle();
}

Future<void> _openBackupStep(WidgetTester tester) async {
  await _openVerifyStep(tester);
  await tester.enterText(find.byKey(TwoFASetupPage.codeFieldKey), '123456');
  await tester.pump();
  await tester.tap(find.byKey(TwoFASetupPage.submitKey));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('/auth/2fa-setup renders as a standalone auth route', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(TwoFASetupPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Thiết lập 2FA'), findsOneWidget);
    expect(find.text('Bước 1: Quét mã QR'), findsOneWidget);
  });

  testWidgets('SC-004 first viewport reaches 2FA setup controls', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-004 TwoFASetupPage',
      semanticLabel: 'Thiết lập 2FA',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TwoFASetupPage.copyKey),
      routeName: 'SC-004 TwoFASetupPage',
      actionLabel: 'the manual secret copy control',
    );
  });

  testWidgets('/auth/2fa-setup visual QA shell keeps fake status only', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(shellRenderMode: ShellRenderMode.visualQa));
    await tester.pumpAndSettle();

    expect(find.byType(TwoFASetupPage), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-004 copies the manual secret key', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('JBSWY3DPEHPK3PXP'), findsOneWidget);

    await tester.ensureVisible(find.byKey(TwoFASetupPage.copyKey));
    await tester.tap(find.byKey(TwoFASetupPage.copyKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã sao chép'), findsOneWidget);
  });

  testWidgets('SC-004 keeps verify disabled until six digits are entered', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openVerifyStep(tester);

    expect(find.text('Bước 2: Xác minh mã'), findsOneWidget);

    var button = tester.widget<VitCtaButton>(
      find.byKey(TwoFASetupPage.submitKey),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(find.byKey(TwoFASetupPage.codeFieldKey), '12345');
    await tester.pump();

    button = tester.widget<VitCtaButton>(find.byKey(TwoFASetupPage.submitKey));
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-004 verifies the authenticator code and shows backup codes', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openBackupStep(tester);

    expect(find.text('Bước 3: Mã dự phòng'), findsOneWidget);
    expect(find.text('84923-13721'), findsOneWidget);
    expect(find.text('Tôi đã lưu các mã dự phòng'), findsOneWidget);
  });

  testWidgets('SC-004 blocks completion until backup codes are saved', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openBackupStep(tester);

    var button = tester.widget<VitCtaButton>(
      find.byKey(TwoFASetupPage.submitKey),
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.byKey(TwoFASetupPage.backupSavedKey));
    await tester.pump();

    button = tester.widget<VitCtaButton>(find.byKey(TwoFASetupPage.submitKey));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('SC-004 complete action navigates to Home', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openBackupStep(tester);

    await tester.tap(find.byKey(TwoFASetupPage.backupSavedKey));
    await tester.pump();
    await tester.tap(find.byKey(TwoFASetupPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });

  testWidgets('SC-004 direct header back falls back to OTP', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(OTPPage), findsOneWidget);
    expect(find.byType(TwoFASetupPage), findsNothing);
  });
}
