// TwoFaSetupTabletPage (coverage đợt 2: 55 dòng thiếu) — luồng xác minh mã,
// xác nhận đã lưu mã khôi phục, hoàn tất.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/two_fa_setup_tablet_page.dart';

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
            initialLocation: AppRoutePaths.auth2faSetup,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('luồng 2FA: mã sai độ dài, mã đúng, lưu mã, hoàn tất', (
    tester,
  ) async {
    await pumpTablet(tester);
    expect(find.text('Thiết lập xác thực hai lớp'), findsOneWidget);

    // Mã ngắn -> lỗi độ dài.
    await tester.enterText(find.byKey(TwoFaSetupTabletPage.codeFieldKey), '12');
    await tester.tap(find.byKey(TwoFaSetupTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập đủ 6 chữ số xác minh.'), findsOneWidget);

    // Mã đúng 123456 -> sang trạng thái đã xác minh.
    await tester.enterText(
      find.byKey(TwoFaSetupTabletPage.codeFieldKey),
      '123456',
    );
    await tester.tap(find.byKey(TwoFaSetupTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Lưu mã khôi phục'), findsOneWidget);

    // Hoàn tất khi chưa xác nhận lưu mã -> lỗi nhắc.
    await tester.tap(find.text('Hoàn tất bảo mật'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Hãy xác nhận đã lưu mã khôi phục'),
      findsOneWidget,
    );

    // Tick xác nhận đã lưu -> hoàn tất được.
    await tester.tap(find.text('Tôi đã lưu các mã khôi phục ở nơi an toàn.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hoàn tất bảo mật'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
