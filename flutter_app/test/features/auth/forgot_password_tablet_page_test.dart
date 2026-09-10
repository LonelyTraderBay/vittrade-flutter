// ForgotPasswordTabletPage (coverage 2026-09-10: 86 dòng chưa phủ) —
// pump route tablet thật, request reset với email hợp lệ và không hợp lệ.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: AppRoutePaths.authForgotPassword,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('render form quên mật khẩu tablet', (tester) async {
    await pumpTablet(tester);

    expect(find.byType(ForgotPasswordTabletPage), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submit email hợp lệ không crash và còn ở trang', (tester) async {
    await pumpTablet(tester);

    await tester.enterText(find.byType(TextField).first, 'user@vittrade.vn');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ForgotPasswordTabletPage), findsOneWidget);
  });
}
