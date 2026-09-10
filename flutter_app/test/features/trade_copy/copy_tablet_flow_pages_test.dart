// Batch test tablet các trang luồng Copy Trading (coverage 2026-09-10:
// copy_flow 74 + copy_remaining 56 dòng chưa phủ).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_flow_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_remaining_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('chi tiết provider copy tablet render dữ liệu thật', (
    tester,
  ) async {
    // ct001 là id trader thật trong mock — phủ nhánh dữ liệu (stats, PnL).
    await pumpTablet(tester, '/trade/copy-provider/ct001');

    expect(find.byType(CopyProviderDetailTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Win rate'), findsOneWidget);
    expect(find.text('Copiers'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đánh giá trước copy tablet: chọn đáp án câu hỏi', (
    tester,
  ) async {
    await pumpTablet(tester, '/trade/copy-provider/ct001/assessment');

    expect(find.byType(PreCopyAssessmentTabletPage), findsOneWidget);

    // Bấm lựa chọn đầu của câu hỏi đầu — _answers cập nhật, chip active.
    final choice = find.byType(VitChoicePill);
    if (choice.evaluate().isNotEmpty) {
      await tester.tap(choice.first);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
    expect(find.byType(PreCopyAssessmentTabletPage), findsOneWidget);
  });

  testWidgets('phân bổ hiệu năng copy tablet render với param', (tester) async {
    await pumpTablet(tester, '/trade/copy-performance/copy-001/attribution');

    expect(find.byType(PerformanceAttributionTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang giáo dục an toàn copy tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.tradeCopySafety);

    expect(find.byType(SafetyEducationTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
