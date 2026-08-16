import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';

/// SEC-S45 (A-Plus GĐ3): route không khớp phải ra trang lỗi tiếng Việt
/// (errorBuilder), không phải ErrorScreen mặc định tiếng Anh của go_router,
/// và tuyệt đối không render một thực thể demo thay thế.
void main() {
  Future<void> pumpRoute(WidgetTester tester, String initialLocation) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('đường dẫn không tồn tại ra VitRouteErrorPage tiếng Việt', (
    tester,
  ) async {
    await pumpRoute(tester, '/duong-dan-khong-ton-tai');

    expect(find.byType(VitRouteErrorPage), findsOneWidget);
    expect(find.text('Không tìm thấy trang'), findsOneWidget);
    expect(
      find.text('Liên kết không hợp lệ hoặc nội dung đã bị gỡ.'),
      findsOneWidget,
    );
  });

  testWidgets('CTA "Về trang chủ" đưa về Home', (tester) async {
    await pumpRoute(tester, '/duong-dan-khong-ton-tai');

    await tester.tap(find.text('Về trang chủ'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(VitRouteErrorPage), findsNothing);
  });
}
