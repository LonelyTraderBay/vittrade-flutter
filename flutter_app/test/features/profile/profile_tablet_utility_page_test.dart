import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_security_pane.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: location,
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-158 Tablet uses the real security pane composition', (
    tester,
  ) async {
    // The security sub-route migrated off the placeholder into the
    // master-detail real pane (2026-08) — deep-linking straight to it still
    // lands on the full security content inside the shell.
    await pumpTabletRoute(tester, AppRoutePaths.profileSecurity);

    expect(find.byType(ProfileSecurityPane), findsOneWidget);
    expect(find.byType(ProfileTabletUtilityPage), findsNothing);
    expect(find.text('Bảo mật'), findsWidgets);
    expect(find.text('Cao (3/4)'), findsOneWidget);
  });

  testWidgets('SC-159 Tablet uses the real KYC pane composition', (
    tester,
  ) async {
    // The KYC sub-route migrated off the placeholder into the master-detail
    // real pane (2026-08) — deep-linking straight to it still lands on the
    // full verification content inside the shell.
    await pumpTabletRoute(tester, AppRoutePaths.profileKyc);

    expect(find.byType(ProfileKycPane), findsOneWidget);
    expect(find.byType(ProfileTabletUtilityPage), findsNothing);
    expect(find.text('Xác minh danh tính'), findsOneWidget);
    expect(find.text('KYC Cấp 2 — Đã xác minh'), findsOneWidget);
  });

  testWidgets(
    'SC-163 placeholder pane renders one hero card without legacy scaffolding',
    (tester) async {
      // Trimmed placeholder template: the pane carries the route's business
      // description, its topic icon (mirroring the account menu row), and a
      // completion note — no static facts table, fake CTA flow, or duplicate
      // risk/confirmation scaffolding.
      await pumpTabletRoute(tester, AppRoutePaths.profileApi);

      expect(find.byType(ProfileTabletUtilityPage), findsOneWidget);
      expect(
        find.text(
          'Rà soát các khóa API, phạm vi quyền và trạng thái truy cập trước '
          'khi quản lý.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Trình quản lý đầy đủ cho mục này đang được hoàn thiện.'),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ProfileTabletUtilityPage),
          matching: find.byIcon(Icons.key_rounded),
        ),
        findsOneWidget,
      );
      expect(find.byType(VitHighRiskStatePanel), findsNothing);
      expect(find.text('Thông tin chính'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(ProfileTabletUtilityPage),
          matching: find.byType(VitCtaButton),
        ),
        findsNothing,
      );
    },
  );

  testWidgets('SC-405 biometric placeholder carries its own copy', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.settingsSecurityBiometric);

    expect(find.byType(ProfileTabletUtilityPage), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
    expect(
      find.text('Bật hoặc tắt xác thực sinh trắc học cho thiết bị này.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-406 change-password placeholder carries its own copy', (
    tester,
  ) async {
    // SC-405 and SC-406 used to share byte-identical placeholder copy; each
    // route now describes its own flow.
    await pumpTabletRoute(tester, AppRoutePaths.settingsSecurityChangePassword);

    expect(find.byType(ProfileTabletUtilityPage), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(
      find.text('Đặt mật khẩu mới và xác minh qua bước bảo mật tiếp theo.'),
      findsOneWidget,
    );
  });
}
