// Thư viện preset Arena (coverage 2026-09-10: part-file demo widgets 109
// dòng chưa phủ) — pump route phone thật qua router mặc định.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_universal_preset_library_page.dart';

void main() {
  Future<void> pumpPhone(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudioPresets,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('render thư viện preset với dữ liệu mock', (tester) async {
    await pumpPhone(tester);

    expect(find.byType(ArenaUniversalPresetLibraryPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // Coverage đợt 2: duyệt đủ 4 section (domains/suggestions/dropdowns/
  // demo_flows) — section demo_flows render bộ card luồng demo.
  testWidgets('đổi section: suggestions, dropdowns, demo flows', (
    tester,
  ) async {
    await pumpPhone(tester);

    for (final id in ['suggestions', 'dropdowns', 'demo_flows']) {
      final tab = find.byKey(ArenaUniversalPresetLibraryPage.sectionKey(id));
      await Scrollable.ensureVisible(tester.element(tab));
      await tester.pumpAndSettle();
      await tester.tap(tab);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: id);
    }
    expect(find.byType(ArenaUniversalPresetLibraryPage), findsOneWidget);
  });
}
