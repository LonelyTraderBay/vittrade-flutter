import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

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

  testWidgets('SC-294 Tablet uses the independent support composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.support);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Hỗ trợ VitTrade'), findsOneWidget);
  });

  testWidgets('SC-319 Tablet uses the independent rewards composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.rewards);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Trung tâm phần thưởng'), findsOneWidget);
  });

  testWidgets('SC-410 Tablet keeps admin settings behind the internal gate', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.adminSettings);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Cài đặt quản trị'), findsOneWidget);
  });
}
