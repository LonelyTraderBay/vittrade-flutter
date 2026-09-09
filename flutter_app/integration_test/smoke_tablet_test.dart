import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

/// Smoke tier vận hành (nhóm A, 2026-09-10): khởi động app thật trên thiết bị
/// tablet ở composition tablet, xác nhận trang chủ render nội dung chính và
/// shell điều hướng sống. Chạy trên thiết bị/emulator:
/// `flutter test integration_test/smoke_tablet_test.dart -d <serial>`
/// (surface được pin tablet — không phụ thuộc độ rộng màn hình thiết bị).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('smoke: app khởi động trên composition tablet, trang chủ sống', (
    tester,
  ) async {
    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: '/home',
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Nội dung chính của trang chủ tablet (SC-007) phải hiển thị.
    expect(find.textContaining('Tổng tài sản'), findsWidgets);
    // Shell: rail điều hướng tồn tại (mục Trang chủ).
    expect(find.textContaining('Thị trường'), findsWidgets);
  });
}
