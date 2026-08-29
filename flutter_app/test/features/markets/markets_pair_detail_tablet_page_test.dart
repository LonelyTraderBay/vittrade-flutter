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
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_token_info_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpPairPane(
    WidgetTester tester, {
    Size size = const Size(1180, 820),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
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
            initialLocation: '/pair/btcusdt',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-044 deep link renders the real pair analysis pane beside the '
      'master list', (tester) async {
    await pumpPairPane(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
    expect(find.byType(MarketsPairDetailPane), findsOneWidget);
    // Header carries the pair symbol.
    expect(find.text('BTC/USDT'), findsWidgets);
    // Price overview + view tabs + chart + risk + links + CTAs.
    expect(find.byKey(MarketsTabletKeys.pairPaneContent), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairViewTab('chart')), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneBuyCta), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneSellCta), findsOneWidget);
    expect(find.text('Giao dịch crypto có rủi ro cao.'), findsOneWidget);
    expect(find.text('Thông tin BTC'), findsOneWidget);
    // Phân tích độ sâu gom thành tab thứ tư (P1 2026-08-29) — link card
    // trang riêng đã bỏ.
    expect(find.byKey(MarketsTabletKeys.pairViewTab('depth')), findsOneWidget);
    expect(find.text('Mua định kỳ BTC'), findsOneWidget);
  });

  testWidgets('SC-044 switching view tabs swaps chart / order book / trades', (
    tester,
  ) async {
    await pumpPairPane(tester);

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('orderBook')));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsNothing);
    expect(find.text('Sổ lệnh BTC/USDT'), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('trades')));
    await tester.pumpAndSettle();

    expect(find.text('Khối lượng'), findsOneWidget);
    expect(find.text('Thời gian'), findsOneWidget);
  });

  testWidgets('SC-044 depth tab embeds the depth analysis inside the pane', (
    tester,
  ) async {
    await pumpPairPane(tester);

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('depth')));
    await tester.pumpAndSettle();

    // Reuse-public: các view công khai của pane độ sâu render tại chỗ.
    expect(find.text('Biểu đồ độ sâu'), findsOneWidget);
    expect(find.text('Tỷ lệ tường mua/bán'), findsOneWidget);
    expect(find.text('Lệnh lớn gần đây'), findsOneWidget);
  });

  testWidgets('SC-044 indicator pills are wired: MA/Vol toggle legend + data', (
    tester,
  ) async {
    await pumpPairPane(tester);

    // MA mặc định bật (seed {'MA'}) — legend MA (7) hiển thị.
    expect(find.text('MA (7)'), findsOneWidget);

    // Tắt MA — legend biến mất (nút wired thật, không còn nút giả).
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is VitChoicePill && widget.label == 'MA',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('MA (7)'), findsNothing);

    // Bật Vol — legend khối lượng xuất hiện.
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is VitChoicePill && widget.label == 'Vol',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Khối lượng'), findsOneWidget);
  });

  testWidgets('SC-044 buy CTA pushes the trade screen with side=buy', (
    tester,
  ) async {
    await pumpPairPane(tester);

    // CTA nằm cuối pane cuộn — kéo tới trước khi bấm.
    await tester.ensureVisible(find.byKey(MarketsTabletKeys.pairPaneBuyCta));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MarketsTabletKeys.pairPaneBuyCta));
    await tester.pumpAndSettle();

    expect(find.byType(TradeTabletPage), findsOneWidget);
  });

  testWidgets('SC-044 token info link opens the info route inside the shell', (
    tester,
  ) async {
    await pumpPairPane(tester);

    // Link card nằm cuối pane cuộn — kéo tới trước khi bấm.
    await tester.ensureVisible(find.text('Thông tin BTC'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thông tin BTC'));
    await tester.pumpAndSettle();

    // The info route now renders the real token info pane inside the
    // terminal shell beside the master list.
    expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
    expect(find.byType(MarketsPairDetailPane), findsNothing);
    expect(find.byType(MarketsTokenInfoPane), findsOneWidget);
  });
}
