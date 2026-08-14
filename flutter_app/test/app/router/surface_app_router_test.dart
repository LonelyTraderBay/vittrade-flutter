import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_app_router.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/app/shell/phone/phone_app_shell.dart';
import 'package:vit_trade_flutter/app/shell/tablet/tablet_app_shell.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/phone/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/tablet/home_tablet_page.dart';

void main() {
  Future<void> setViewport(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(820, 1180);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('Phone router giữ Phone Home ở viewport Tablet', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(VitTradeApp(routerConfig: createPhoneAppRouter()));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(HomeTabletPage), findsNothing);
    expect(find.byType(PhoneAppShell), findsOneWidget);
    expect(find.byType(TabletAppShell), findsNothing);
  });

  testWidgets('Tablet router chọn Tablet Home trực tiếp', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(VitTradeApp(routerConfig: createTabletAppRouter()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(TabletAppShell), findsOneWidget);
    expect(find.byType(PhoneAppShell), findsNothing);
  });

  testWidgets('bootstrap tự chọn Tablet router theo viewport', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(const VitTradeApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('bootstrap tự chọn Phone router dưới breakpoint', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const VitTradeApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(HomeTabletPage), findsNothing);
  });

  test('compatibility router vẫn giữ API createAppRouter', () {
    final router = createAppRouter();
    addTearDown(router.dispose);
    expect(router.namedLocation(AppRouteNames.sc007Home), '/home');
  });
}
