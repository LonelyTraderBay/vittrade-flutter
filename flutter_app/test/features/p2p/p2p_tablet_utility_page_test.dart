import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';

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

  testWidgets('SC-254 Tablet uses independent P2P security composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.p2pSecurity2fa);

    expect(find.byType(P2PTabletUtilityPage), findsOneWidget);
    expect(find.text('Cài đặt 2FA P2P'), findsOneWidget);
    await tester.tap(find.byKey(const Key('SC-254-tablet-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SC-254-tablet-cancel')), findsOneWidget);
  });

  testWidgets('SC-221 Tablet uses independent P2P dispute composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.p2pDispute('order-123'));

    expect(find.byType(P2PTabletUtilityPage), findsOneWidget);
    expect(find.text('Mở tranh chấp P2P'), findsOneWidget);
    expect(find.text('Chưa gửi'), findsOneWidget);
  });
}
