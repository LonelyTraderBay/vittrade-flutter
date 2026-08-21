import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart';

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

  testWidgets('SC-158 Tablet uses independent security composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.profileSecurity);

    expect(find.byType(ProfileTabletUtilityPage), findsOneWidget);
    expect(find.text('Bảo mật tài khoản'), findsOneWidget);
    await tester.tap(find.byKey(const Key('SC-158-tablet-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SC-158-tablet-cancel')), findsOneWidget);
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
}
