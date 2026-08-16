import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/maintenance_gate_page.dart';

/// GĐ4-F1 kill-switch: SC-417 hiển thị đủ tiêu đề/mô tả/nút. Cờ
/// `AppConfig.maintenanceMode` được bật khi pump vì redirect toàn cục (bài
/// test riêng trong test/app/router) sẽ đưa người dùng ra khỏi gate khi cờ
/// tắt — trang này không phải một route duyệt tự do.
void main() {
  Future<void> pumpMaintenanceGate(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.maintenanceGate,
            appConfig: AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: Uri.parse('https://api.vittrade.local'),
              maintenanceMode: true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-417 renders title, description and retry CTA', (
    tester,
  ) async {
    await pumpMaintenanceGate(tester);

    expect(find.byType(MaintenanceGatePage), findsOneWidget);
    expect(find.byKey(MaintenanceGatePage.contentKey), findsOneWidget);
    expect(find.text('Hệ thống đang bảo trì'), findsOneWidget);
    expect(
      find.text(
        'VitTrade đang nâng cấp hạ tầng. Vui lòng quay lại sau ít phút.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(MaintenanceGatePage.retryButtonKey), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('retry CTA re-attempts home but the global redirect holds while '
      'maintenanceMode stays on', (tester) async {
    await pumpMaintenanceGate(tester);

    await tester.tap(find.byKey(MaintenanceGatePage.retryButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(MaintenanceGatePage), findsOneWidget);
  });
}
