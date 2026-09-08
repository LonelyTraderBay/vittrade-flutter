import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_security_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_dispute_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_order_tablet_pages.dart';

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

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(P2PTabletUtilityPage), findsNothing);
    expect(find.byType(P2PTwoFactorSettingsTabletPage), findsOneWidget);
  });

  testWidgets('SC-221 Tablet uses independent P2P dispute composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.p2pDispute('order-123'));

    expect(find.byType(P2PTabletUtilityPage), findsNothing);
    expect(find.byType(P2PDisputeOpenTabletPage), findsOneWidget);
  });

  testWidgets('SC-282 Tablet uses independent P2P marketplace composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.p2p);

    expect(find.byType(P2PTabletUtilityPage), findsNothing);
    expect(find.byType(P2PHomeTabletPage), findsOneWidget);
  });

  testWidgets('SC-214 Tablet keeps order cancellation behind confirmation', (
    tester,
  ) async {
    await pumpTabletRoute(tester, '/p2p/order/cancel/order-123');

    expect(find.byType(P2PTabletUtilityPage), findsNothing);
    expect(find.byType(P2POrderCancelTabletPage), findsOneWidget);
  });
}
