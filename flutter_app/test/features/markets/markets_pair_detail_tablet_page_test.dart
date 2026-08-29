import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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

  // S7 (2026-08-29): khóa layout thật của nhịp dọc pane — scaffold owns
  // section gap nên khoảng giữa các section phải ĐÚNG 13dp (tier
  // standard), không còn margin Phone chồng lên; lề trái các khối thẳng
  // hàng ở contentPad.
  testWidgets('SC-044 pane section gaps follow the 13dp scaffold rhythm '
      '(S7 layout lock)', (tester) async {
    await pumpPairPane(tester);

    final chart = tester.getRect(find.byKey(MarketsTabletKeys.pairPaneChart));
    final banner = tester.getRect(find.byType(VitBanner).first);
    final linkCards = find.ancestor(
      of: find.text('Thông tin BTC'),
      matching: find.byType(VitCard),
    );
    final link1 = tester.getRect(linkCards.first);
    final timeframe = tester.getRect(
      find.byType(VitPresetChipRow<String>).first,
    );

    expect(
      banner.top - chart.bottom,
      13,
      reason:
          'Gap chart → banner cảnh báo phải đúng section gap 13dp '
          '(trước S7 từng stack thành 23dp).',
    );
    expect(
      link1.top - banner.bottom,
      13,
      reason: 'Gap banner → link card phải đúng 13dp (từng 26dp).',
    );

    // Lề trái: hàng khung giờ, khung chart và khối giá thẳng hàng
    // contentPad (từng lệch 24 literal / dải trống 56dp của painter).
    expect(
      timeframe.left,
      chart.left,
      reason: 'Hàng khung giờ phải thẳng lề với khung chart.',
    );
    final priceStat = tester.getRect(find.text('24h Cao'));
    expect(
      (priceStat.left - chart.left).abs(),
      lessThan(1),
      reason: 'Khối giá phải thẳng lề với khung chart (contentPad).',
    );
  });

  // 2026-08-29 (Phương án A — user duyệt): chip khung giờ ôm nội dung với
  // gap x3, cùng nhịp hàng MA/Vol — khóa chống quay lại Tier S3 fullWidth
  // (chip căng đều 124dp + gap x1 3dp từng đọc là "một thanh dính nhau"
  // trên pane tablet rộng).
  testWidgets('SC-044 timeframe chips hug content with the x3 pill rhythm', (
    tester,
  ) async {
    await pumpPairPane(tester);

    Rect pillOf(String label) => tester.getRect(
      find
          .ancestor(of: find.text(label), matching: find.byType(VitChoicePill))
          .first,
    );

    final labels = ['15m', '1H', '4H', '1D', '1W', '1M'];
    final rects = [for (final label in labels) pillOf(label)];

    // Gap giữa mọi cặp chip liên tiếp đúng x3 (8dp) — không còn 2-3dp.
    for (var i = 1; i < rects.length; i++) {
      expect(
        rects[i].left - rects[i - 1].right,
        closeTo(AppSpacing.x3, 0.01),
        reason: 'Gap ${labels[i - 1]}→${labels[i]} phải đúng x3 (8dp).',
      );
    }

    // Chip ôm nội dung: chip "15m" (3 ký tự) rộng hơn "1H" (2 ký tự) và
    // không chip nào phình kiểu fullWidth (từng 124dp trên pane 780dp).
    expect(
      rects[0].width,
      greaterThan(rects[1].width),
      reason:
          'Chip phải co theo nội dung — bằng nhau nghĩa là fullWidth '
          'đã quay lại.',
    );
    for (final rect in rects) {
      expect(
        rect.width,
        lessThan(100),
        reason:
            'Chip không được căng đều kiểu Tier S3 fullWidth trên pane '
            'tablet.',
      );
    }

    // Cùng nhịp với hàng indicator: gap MA→Vol cũng là x3.
    final ma = pillOf('MA');
    final vol = pillOf('Vol');
    expect(
      vol.left - ma.right,
      closeTo(AppSpacing.x3, 0.01),
      reason: 'Hàng khung giờ và hàng MA/Vol phải cùng một nhịp gap x3.',
    );
  });
}
