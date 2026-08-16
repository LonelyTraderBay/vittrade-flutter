import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/force_update_gate_page.dart';

/// GĐ4-F1 kill-switch: SC-418 hiển thị đủ tiêu đề/mô tả/nút. Cờ
/// `AppConfig.forceUpdateRequired` được bật (qua `minSupportedBuild` >
/// `buildNumber`) khi pump vì redirect toàn cục (bài test riêng trong
/// test/app/router) sẽ đưa người dùng ra khỏi gate khi cờ tắt — trang này
/// không phải một route duyệt tự do.
void main() {
  Future<void> pumpForceUpdateGate(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.forceUpdateGate,
            appConfig: AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: Uri.parse('https://api.vittrade.local'),
              minSupportedBuild: 10,
              buildNumber: 1,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-418 renders title, description and retry CTA', (
    tester,
  ) async {
    await pumpForceUpdateGate(tester);

    expect(find.byType(ForceUpdateGatePage), findsOneWidget);
    expect(find.byKey(ForceUpdateGatePage.contentKey), findsOneWidget);
    expect(find.text('Cần cập nhật phiên bản mới'), findsOneWidget);
    expect(
      find.text(
        'Phiên bản hiện tại không còn được hỗ trợ. Vui lòng cập nhật ứng '
        'dụng để tiếp tục giao dịch an toàn.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(ForceUpdateGatePage.retryButtonKey), findsOneWidget);
    expect(find.text('Đã cập nhật? Thử lại'), findsOneWidget);
  });

  testWidgets('retry CTA re-attempts home but the global redirect holds while '
      'forceUpdateRequired stays on', (tester) async {
    await pumpForceUpdateGate(tester);

    await tester.tap(find.byKey(ForceUpdateGatePage.retryButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(ForceUpdateGatePage), findsOneWidget);
  });
}
