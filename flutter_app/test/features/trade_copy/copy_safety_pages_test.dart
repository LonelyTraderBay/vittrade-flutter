// Copy safety phone (coverage đợt 2 nhóm c): Safety Education + Safety Center
// dùng các widget common còn thiếu phủ (education_common, enforcement_common).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

void main() {
  Future<void> pumpPhone(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: location),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('trang giáo dục an toàn copy render + tương tác mục', (
    tester,
  ) async {
    await pumpPhone(tester, AppRoutePaths.tradeCopySafety);
    expect(tester.takeException(), isNull);

    // Mở vài mục accordion nếu có.
    final expandables = find.byType(ExpansionTile);
    final count = expandables.evaluate().length;
    for (var i = 0; i < 2 && i < count; i++) {
      await tester.tap(expandables.at(i));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('trung tâm an toàn copy render + đổi tab', (tester) async {
    await pumpPhone(tester, AppRoutePaths.tradeCopySafetyCenter);
    expect(tester.takeException(), isNull);

    // Tab Enforcement render danh sách hành động xử phạt (enforcement
    // common) — nội dung đặc trưng: provider bị đình chỉ.
    final enforcementTab = find.text('Enforcement');
    expect(enforcementTab, findsOneWidget);
    await tester.ensureVisible(enforcementTab);
    await tester.pumpAndSettle();
    await tester.tap(enforcementTab);
    await tester.pumpAndSettle();
    expect(find.text('SUSPENDED'), findsWidgets);
    expect(find.text('Provider X'), findsOneWidget);

    // Tab Metrics render trust metrics.
    final metricsTab = find.text('Metrics');
    await tester.ensureVisible(metricsTab);
    await tester.pumpAndSettle();
    await tester.tap(metricsTab);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
