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
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';

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
}
