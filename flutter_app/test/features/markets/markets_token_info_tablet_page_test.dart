import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/widgets/markets_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_token_info_pane.dart';

void main() {
  Future<void> pumpTokenInfo(WidgetTester tester) async {
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
            initialLocation: '/pair/btcusdt/info',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SC-045 deep link renders the real token info pane inside the shell',
    (tester) async {
      await pumpTokenInfo(tester);

      expect(tester.takeException(), isNull);
      expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
      expect(find.byType(MarketsTokenInfoPane), findsOneWidget);
      expect(find.text('BTC · Thông tin'), findsOneWidget);
      expect(find.byKey(MarketsTabletKeys.tokenPaneContent), findsOneWidget);
      expect(find.text('Thống kê thị trường'), findsOneWidget);
      expect(find.byKey(MarketsTabletKeys.tokenStatsCard), findsOneWidget);
      expect(find.text('Cung token'), findsOneWidget);
      expect(find.text('Kỷ lục giá'), findsOneWidget);
    },
  );

  testWidgets('SC-045 switching tabs swaps overview / on-chain / project', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.tap(find.byKey(MarketsTabletKeys.tokenTab('onchain')));
    await tester.pumpAndSettle();

    expect(find.text('Hoạt động mạng lưới (24h)'), findsOneWidget);
    expect(find.text('Thông tin mạng lưới'), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.tokenTab('project')));
    await tester.pumpAndSettle();

    expect(find.text('Giới thiệu'), findsOneWidget);
    expect(find.text('Liên kết'), findsOneWidget);
    expect(find.text('Website'), findsOneWidget);
  });

  testWidgets(
    'SC-045 chart link returns to the pair detail pane inside the shell',
    (tester) async {
      await pumpTokenInfo(tester);

      await tester.ensureVisible(find.byKey(MarketsTabletKeys.tokenChartLink));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(MarketsTabletKeys.tokenChartLink));
      await tester.pumpAndSettle();

      expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
      expect(find.byType(MarketsTokenInfoPane), findsNothing);
      expect(find.byType(MarketsPairDetailPane), findsOneWidget);
    },
  );
}
