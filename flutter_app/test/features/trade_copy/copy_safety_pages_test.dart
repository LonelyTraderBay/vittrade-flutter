// Copy safety phone (coverage đợt 2 nhóm c): Safety Education + Safety Center
// dùng các widget common còn thiếu phủ (education_common, enforcement_common).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/safety_education_page.dart';

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

  // Coverage dòng 2 p3f: nhánh error safety education.
  testWidgets('safety education error qua override', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        overrides: [
          tradeSafetyEducationProvider.overrideWith(
            (ref) async => throw StateError('lỗi mạng'),
          ),
        ],
        routerConfig: createAppRouter(
          initialLocation: AppRoutePaths.tradeCopySafety,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3l: tab Red Flags render severity sections (common).
  testWidgets('safety education: tab Red Flags severity sections', (
    tester,
  ) async {
    await pumpPhone(tester, AppRoutePaths.tradeCopySafety);

    final redflagsTab = find.byKey(SafetyEducationPage.tabKey('redflags'));
    if (redflagsTab.evaluate().isNotEmpty) {
      await tester.ensureVisible(redflagsTab);
      await tester.pumpAndSettle();
      await tester.tap(redflagsTab);
      await tester.pumpAndSettle();
      // Severity section header (cao/ngay túc) hiện.
      expect(find.textContaining('Red Flag'), findsAtLeastNWidgets(1));
    }
    expect(tester.takeException(), isNull);
  });

  // Tab Scams + Verification + Report lần lượt (các nhánh body còn lại).
  testWidgets('safety education: scams/verification/report tabs', (
    tester,
  ) async {
    await pumpPhone(tester, AppRoutePaths.tradeCopySafety);

    for (final id in ['scams', 'verification', 'report']) {
      final tab = find.byKey(SafetyEducationPage.tabKey(id));
      if (tab.evaluate().isNotEmpty) {
        await tester.ensureVisible(tab);
        await tester.pumpAndSettle();
        await tester.tap(tab);
        await tester.pumpAndSettle();
      }
    }
    expect(tester.takeException(), isNull);
  });
}
