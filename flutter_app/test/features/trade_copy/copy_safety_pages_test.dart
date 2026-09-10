// Copy safety phone (coverage đợt 2 nhóm c): Safety Education + Safety Center
// dùng các widget common còn thiếu phủ (education_common, enforcement_common).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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

    // Đổi tab qua segmented bar (đủ nhánh _activeTabId của Safety Center).
    final tabs = find.descendant(
      of: find.byType(VitSegmentedTabBar),
      matching: find.byType(Text),
    );
    final count = tabs.evaluate().length;
    for (var i = 0; i < count && i < 4; i++) {
      await tester.tap(tabs.at(i));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
