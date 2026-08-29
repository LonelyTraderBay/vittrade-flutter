import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
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

  // Terminal thuần (hướng C 2026-08-30): desk thay vùng cuộn bằng grid
  // cố định — meta strip 1 hàng, chart/độ sâu + sổ lệnh + giao dịch dạng
  // panel phẳng, mini-tab điều hướng, footer ghim.
  testWidgets('SC-044 desk renders the terminal grid beside the master list', (
    tester,
  ) async {
    await pumpPairPane(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
    expect(find.byType(MarketsPairDetailPane), findsOneWidget);
    expect(find.text('BTC/USDT'), findsWidgets);
    // Meta strip + OHLC readout + chart + 2 panel dữ liệu + footer.
    expect(find.byKey(MarketsTabletKeys.pairMetaStrip), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairOhlcReadout), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairBookPanel), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairTradesPanel), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairDeskFooter), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneBuyCta), findsOneWidget);
    // Mini-tab điều hướng thay banner + thẻ link kiểu web cũ.
    expect(find.byKey(MarketsTabletKeys.pairMiniTab('depth')), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairMiniTab('info')), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairMiniTab('dca')), findsOneWidget);
    // Terminal KHÔNG còn view-tab 4 ô và KHÔNG còn scroll trang.
    expect(find.byKey(MarketsTabletKeys.pairViewTab('chart')), findsNothing);
    expect(find.text('Giao dịch crypto có rủi ro cao.'), findsNothing);
  });

  // Khuôn pane hẹp giữ nguyên 4 tab + banner + khối giá (dưới ngưỡng 700).
  testWidgets('SC-044 narrow pane keeps the 4-tab scrolled composition', (
    tester,
  ) async {
    await pumpPairPane(tester, size: const Size(600, 820));

    expect(find.byKey(MarketsTabletKeys.pairMetaStrip), findsNothing);
    expect(find.byKey(MarketsTabletKeys.pairViewTab('chart')), findsOneWidget);
    expect(find.text('24h Cao'), findsOneWidget);
    expect(find.text('Giao dịch crypto có rủi ro cao.'), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('orderBook')));
    await tester.pumpAndSettle();
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsNothing);
    expect(find.text('Sổ lệnh BTC/USDT'), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('trades')));
    await tester.pumpAndSettle();
    expect(find.text('Thời gian'), findsOneWidget);
  });

  testWidgets('SC-044 narrow depth tab embeds the depth analysis', (
    tester,
  ) async {
    await pumpPairPane(tester, size: const Size(600, 820));

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('depth')));
    await tester.pumpAndSettle();

    expect(find.text('Biểu đồ độ sâu'), findsOneWidget);
    expect(find.text('Tỷ lệ tường mua/bán'), findsOneWidget);
  });

  // Mini-tab 'Độ sâu' đổi workspace trái của terminal (không push route).
  testWidgets('SC-044 desk mini-tab Độ sâu swaps the left workspace', (
    tester,
  ) async {
    await pumpPairPane(tester);

    await tester.tap(find.byKey(MarketsTabletKeys.pairMiniTab('depth')));
    await tester.pumpAndSettle();

    expect(find.text('Biểu đồ độ sâu'), findsOneWidget);
    // Panel sổ lệnh + giao dịch vẫn cạnh bên.
    expect(find.byKey(MarketsTabletKeys.pairBookPanel), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.pairMiniTab('depth')));
    await tester.pumpAndSettle();
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsOneWidget);
  });

  testWidgets('SC-044 indicator buttons are wired: MA/Vol toggle legend', (
    tester,
  ) async {
    await pumpPairPane(tester);

    expect(
      find.ancestor(
        of: find.text('MA (7)'),
        matching: find.byType(VitLegendItem),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(MarketsTabletKeys.pairIndicator('MA')));
    await tester.pumpAndSettle();
    expect(
      find.ancestor(
        of: find.text('MA (7)'),
        matching: find.byType(VitLegendItem),
      ),
      findsNothing,
    );

    await tester.tap(find.byKey(MarketsTabletKeys.pairIndicator('Vol')));
    await tester.pumpAndSettle();
    expect(
      find.ancestor(
        of: find.text('Khối lượng'),
        matching: find.byType(VitLegendItem),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-044 footer CTA pushes the trade screen with side=buy', (
    tester,
  ) async {
    await pumpPairPane(tester);

    await tester.tap(find.byKey(MarketsTabletKeys.pairPaneBuyCta));
    await tester.pumpAndSettle();

    expect(find.byType(TradeTabletPage), findsOneWidget);
  });

  testWidgets('SC-044 mini-tab Thông tin opens the token info pane', (
    tester,
  ) async {
    await pumpPairPane(tester);

    await tester.tap(find.byKey(MarketsTabletKeys.pairMiniTab('info')));
    await tester.pumpAndSettle();

    expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
    expect(find.byType(MarketsPairDetailPane), findsNothing);
    expect(find.byType(MarketsTokenInfoPane), findsOneWidget);
  });

  // Layout lock terminal: panel sổ lệnh CẠNH chart với gutter đúng
  // pairTerminalGutter, footer ghim đáy, OHLC nằm trên chart.
  testWidgets('SC-044 terminal layout lock: panels beside chart with the '
      'standard gutter and pinned footer', (tester) async {
    await pumpPairPane(tester);

    final chart = tester.getRect(find.byKey(MarketsTabletKeys.pairPaneChart));
    final book = tester.getRect(find.byKey(MarketsTabletKeys.pairBookPanel));
    final footer = tester.getRect(find.byKey(MarketsTabletKeys.pairDeskFooter));
    final meta = tester.getRect(find.byKey(MarketsTabletKeys.pairMetaStrip));
    final ohlc = tester.getRect(find.byKey(MarketsTabletKeys.pairOhlcReadout));

    // Chart key là vùng VẼ (đã trừ rail giá 56dp trong khung panel) —
    // gutter thực = book.left - chart.right - rail còn lại trong panel.
    expect(
      book.left - chart.right,
      lessThanOrEqualTo(
        MarketsSpacingTokens.pairTerminalGutter +
            MarketsSpacingTokens.pairDetailNativeBottomExtra,
      ),
      reason: 'Panel sổ lệnh phải nằm sát sau khung chart (gutter terminal).',
    );
    expect(
      book.left - chart.right,
      greaterThan(0),
      reason: 'Sổ lệnh phải nằm BÊN PHẢI chart, không chồng.',
    );
    expect(
      ohlc.bottom,
      lessThanOrEqualTo(chart.top + 1),
      reason: 'OHLC readout phải nằm trên mép chart.',
    );
    expect(
      footer.bottom,
      greaterThan(780),
      reason: 'Footer MUA/BÁN ghim sát đáy viewport (820dp).',
    );
    expect(meta.top, lessThan(chart.top), reason: 'Meta strip trên cùng.');
  });

  testWidgets('SC-044 chart toolbar keeps the in-panel flat rows wired', (
    tester,
  ) async {
    await pumpPairPane(tester);

    for (final tf in ['15m', '1H', '4H', '1D', '1W', '1M']) {
      expect(find.byKey(MarketsTabletKeys.pairInterval(tf)), findsOneWidget);
    }
    expect(find.byKey(MarketsTabletKeys.pairIndicator('MA')), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairIndicator('Vol')), findsOneWidget);

    final chart = tester.getRect(find.byKey(MarketsTabletKeys.pairPaneChart));
    final firstButton = tester.getRect(
      find.byKey(MarketsTabletKeys.pairInterval('15m')),
    );
    final indicator = tester.getRect(
      find.byKey(MarketsTabletKeys.pairIndicator('MA')),
    );
    expect(
      indicator.top,
      greaterThanOrEqualTo(firstButton.bottom),
      reason: 'MA phải ở hàng dưới hàng interval trong panel.',
    );
    expect(
      indicator.bottom,
      lessThanOrEqualTo(chart.top + 1),
      reason: 'Cả 2 hàng toolbar phải nằm trên OHLC/chart.',
    );

    await tester.tap(find.byKey(MarketsTabletKeys.pairInterval('4H')));
    await tester.pumpAndSettle();
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // Mật độ (Lô B): 12 mức mỗi bên + spread + 24 dòng giao dịch.
  testWidgets('SC-044 book panel shows 12 levels per side and 24 trades', (
    tester,
  ) async {
    await pumpPairPane(tester);

    for (var i = 0; i < 12; i++) {
      expect(
        find.byKey(MarketsTabletKeys.pairBookRow('ask', i)),
        findsOneWidget,
      );
      expect(
        find.byKey(MarketsTabletKeys.pairBookRow('bid', i)),
        findsOneWidget,
      );
    }
    expect(
      find.byKey(MarketsTabletKeys.pairBookRow('ask', 12)),
      findsNothing,
      reason: 'Đúng 12 mức mỗi bên — không thừa, không thiếu.',
    );
    expect(find.textContaining('Spread'), findsOneWidget);

    // ListView.builder render lười — kéo bảng giao dịch để thấy dòng 23.
    expect(find.byKey(MarketsTabletKeys.pairTradeRow(0)), findsOneWidget);
    final firstRow = tester.getRect(
      find.byKey(MarketsTabletKeys.pairTradeRow(0)),
    );
    final gesture = await tester.startGesture(firstRow.center);
    await gesture.moveBy(const Offset(0, -240));
    await tester.pump();
    await gesture.moveBy(const Offset(0, -240));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(
      find.byKey(MarketsTabletKeys.pairTradeRow(23)),
      findsOneWidget,
      reason: 'Fixture sinh 24 giao dịch (0..23).',
    );
    expect(find.byKey(MarketsTabletKeys.pairTradeRow(24)), findsNothing);
  });

  // Crosshair (Lô B): chạm chart → OHLC readout đổi theo nến đang chọn.
  testWidgets('SC-044 tapping the chart moves the crosshair OHLC readout', (
    tester,
  ) async {
    await pumpPairPane(tester);

    String readoutText() {
      final text = tester.widget<Text>(
        find
            .descendant(
              of: find.byKey(MarketsTabletKeys.pairOhlcReadout),
              matching: find.byType(Text),
            )
            .first,
      );
      return text.data ?? '';
    }

    final before = readoutText();
    final chart = tester.getRect(find.byKey(MarketsTabletKeys.pairPaneChart));
    // Chạm giữa chart rồi gần mép trái — 2 nến khác nhau phải cho 2 lần
    // đọc O khác nhau.
    await tester.tapAt(Offset(chart.center.dx, chart.center.dy));
    await tester.pumpAndSettle();
    final middle = readoutText();
    expect(middle, isNot(before), reason: 'Crosshair phải đọc nến đang chạm.');

    await tester.tapAt(Offset(chart.left + 20, chart.center.dy));
    await tester.pumpAndSettle();
    expect(
      readoutText(),
      isNot(middle),
      reason: 'Chạm nến khác phải đổi OHLC readout.',
    );
  });

  // S7 narrow: khuôn cuộn hẹp vẫn giữ section gap 13dp quanh banner.
  testWidgets('SC-044 narrow pane keeps the 13dp section rhythm (S7)', (
    tester,
  ) async {
    await pumpPairPane(tester, size: const Size(600, 820));

    final banner = tester.getRect(find.byType(VitBanner).first);
    final link1 = tester.getRect(
      find
          .ancestor(
            of: find.text('Thông tin BTC'),
            matching: find.byType(VitCard),
          )
          .first,
    );
    expect(
      link1.top - banner.bottom,
      AppSpacing.x4,
      reason: 'Gap banner → link card phải đúng 13dp (tier standard).',
    );
  });
}
