import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/widgets/markets_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_depth_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';

void main() {
  Future<void> pumpDepth(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          marketRepositoryProvider.overrideWithValue(
            const MockMarketRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: '/pair/btcusdt/depth',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-046 deep link renders the real depth pane inside the shell', (
    tester,
  ) async {
    await pumpDepth(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
    expect(find.byType(MarketsPairDepthPane), findsOneWidget);
    expect(find.text('Độ sâu BTC'), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.depthPaneContent), findsOneWidget);
    // Banner tham khảo của trang Phone được giữ nguyên (financial safety).
    expect(find.text('Dữ liệu depth chỉ mang tính tham khảo'), findsOneWidget);
  });
}
