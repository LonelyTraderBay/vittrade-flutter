// Batch test tablet các trang Trade nâng cao (coverage 2026-09-10:
// execution-quality 65, advanced-tools 59, advanced-demo 87 dòng chưa phủ).
// Khuôn theo p2p_batch_a_tablet_pages_test: pump route thật qua tablet router.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_tools_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_trading_demo_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/execution_quality_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_overview.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
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

  testWidgets('trang chất lượng thực thi render thật, không utility', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.tradeExecutionQuality);

    expect(find.byType(ExecutionQualityTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // Coverage đợt 2: bấm các feature card để đổi tab execution/amendment/slippage
  // + mở 3 sheet cấu hình từ từng tab (onOpen).
  testWidgets('chất lượng thực thi: đổi tab + mở 3 sheet cấu hình', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.tradeExecutionQuality);

    // Tab slippage (mặc định) -> sheet Configure Slippage Protection.
    final slippageOpen = find.textContaining('Configure Slippage Protection');
    if (slippageOpen.evaluate().isNotEmpty) {
      await tester.ensureVisible(slippageOpen.first);
      await tester.pumpAndSettle();
      await tester.tap(slippageOpen.first);
      await tester.pumpAndSettle();
      expect(find.textContaining('Ngưỡng'), findsAtLeastNWidgets(1));
      // Đóng sheet bằng nút đầu tiên nếu có.
      final close = find.byType(VitCtaButton);
      if (close.evaluate().isNotEmpty) {
        await tester.tap(close.first);
        await tester.pumpAndSettle();
      }
    }

    // Đổi sang tab execution qua feature card thứ hai, mở sheet report.
    final cards = find.byType(ExecutionQualityFeatureCard);
    expect(cards.evaluate(), isNotEmpty);
    if (cards.evaluate().length > 1) {
      await tester.tap(cards.at(1));
      await tester.pumpAndSettle();
      final reportOpen = find.textContaining('View Sample Execution Report');
      if (reportOpen.evaluate().isNotEmpty) {
        await tester.ensureVisible(reportOpen.first);
        await tester.pumpAndSettle();
        await tester.tap(reportOpen.first);
        await tester.pumpAndSettle();
      }
    }

    // Tab amendment, mở sheet Modify Open Order.
    if (cards.evaluate().length > 2) {
      await tester.tap(cards.at(2));
      await tester.pumpAndSettle();
      final modify = find.textContaining('Modify Open Order');
      if (modify.evaluate().isNotEmpty) {
        await tester.ensureVisible(modify.first);
        await tester.pumpAndSettle();
        await tester.tap(modify.first);
        await tester.pumpAndSettle();
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang công cụ nâng cao render thật, không utility', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.tradeAdvancedTools);

    expect(find.byType(AdvancedToolsTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang demo margin nâng cao render thật, không utility', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.tradeMarginAdvancedDemo);

    expect(find.byType(AdvancedTradingDemoTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // Coverage đợt 2: các nhánh tương tác — đổi tab Vị thế/Lệnh/Phân tích,
  // đổi chip chế độ vị thế, bấm hành động demo (card "Đã chọn" ở cột phụ).
  testWidgets('đổi tab, chế độ vị thế và hành động demo', (tester) async {
    await pumpTablet(tester, AppRoutePaths.tradeMarginAdvancedDemo);

    // Chip chế độ vị thế: một chiều -> hai chiều.
    await tester.tap(
      find.byKey(AdvancedTradingDemoTabletPage.modeKey('hedge')),
    );
    await tester.pumpAndSettle();

    // Tab Lệnh: card lệnh render thay card vị thế.
    await tester.tap(find.text('Lệnh'));
    await tester.pumpAndSettle();
    expect(find.byType(AdvancedTradingDemoTabletPage), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Tab Phân tích: metric hiệu suất + PnL.
    await tester.tap(find.text('Phân tích'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Về tab Vị thế và bấm hành động demo -> card "Đã chọn hành động demo".
    await tester.tap(find.text('Vị thế'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(VitCtaButton).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Đã chọn hành động demo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
