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
    // Khuôn 1 cột 4 tab chỉ còn ở pane HẸP — desk rộng đã tách sổ lệnh +
    // giao dịch thành cột phụ luôn hiện (test desk riêng bên dưới).
    await pumpPairPane(tester, size: const Size(600, 820));

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('orderBook')));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsNothing);
    expect(find.text('Sổ lệnh BTC/USDT'), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.pairViewTab('trades')));
    await tester.pumpAndSettle();

    expect(find.text('Khối lượng'), findsOneWidget);
    expect(find.text('Thời gian'), findsOneWidget);
  });

  // Hướng 1 "Trading Desk" (2026-08-29): pane đủ rộng tách 2 cột — chart
  // nến và SỔ LỆNH + GIAO DỊCH cùng nhìn thấy một lần, kèm dải đáy ghim
  // giá + MUA/BÁN không cuộn.
  testWidgets('SC-044 desk composition: chart beside order book + trades '
      'with pinned trade footer', (tester) async {
    await pumpPairPane(tester);

    expect(find.byKey(MarketsTabletKeys.pairDeskRow), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsOneWidget);
    // V2-C: cột phụ là MỘT panel tabbed Sổ lệnh | Giao dịch (Bybit).
    expect(find.byKey(MarketsTabletKeys.pairBookTab('book')), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairBookTab('trades')), findsOneWidget);
    expect(find.textContaining('Mid'), findsOneWidget);
    // Tab thu gọn còn Biểu đồ | Độ sâu — tab Sổ lệnh/Giao dịch không còn.
    expect(find.byKey(MarketsTabletKeys.pairViewTab('depth')), findsOneWidget);
    expect(
      find.byKey(MarketsTabletKeys.pairViewTab('orderBook')),
      findsNothing,
    );
    // Dải đáy ghim: giá + MUA/BÁN ngoài scroll.
    expect(find.byKey(MarketsTabletKeys.pairDeskFooter), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneBuyCta), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairPaneSellCta), findsOneWidget);
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
    await tester.tap(find.byKey(MarketsTabletKeys.pairIndicator('MA')));
    await tester.pumpAndSettle();
    expect(find.text('MA (7)'), findsNothing);

    // Bật Vol — legend khối lượng xuất hiện (desk luôn hiện header bảng
    // giao dịch cùng chữ — scope theo VitLegendItem của legend chart).
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
  // hàng ở contentPad. Desk (rộng): chart nằm trong desk row — gap đo từ
  // đáy DESK ROW (cột phụ có thể cao hơn chart); khóa thêm cột phụ đứng
  // CẠNH chart và footer ghim đáy.
  testWidgets('SC-044 pane section gaps follow the 13dp scaffold rhythm '
      '(S7 layout lock)', (tester) async {
    await pumpPairPane(tester);

    final deskRow = tester.getRect(find.byKey(MarketsTabletKeys.pairDeskRow));
    final chart = tester.getRect(find.byKey(MarketsTabletKeys.pairPaneChart));
    final banner = tester.getRect(find.byType(VitBanner).first);
    final linkCards = find.ancestor(
      of: find.text('Thông tin BTC'),
      matching: find.byType(VitCard),
    );
    final link1 = tester.getRect(linkCards.first);
    final firstInterval = tester.getRect(
      find.byKey(MarketsTabletKeys.pairInterval('15m')),
    );
    final footer = tester.getRect(find.byKey(MarketsTabletKeys.pairDeskFooter));

    expect(
      banner.top - deskRow.bottom,
      13,
      reason:
          'Gap desk row → banner cảnh báo phải đúng section gap 13dp '
          '(trước S7 từng stack thành 23dp).',
    );
    expect(
      link1.top - banner.bottom,
      13,
      reason: 'Gap banner → link card phải đúng 13dp (từng 26dp).',
    );

    // Desk: chart nằm gọn trong cột chính của desk row.
    expect(chart.top, greaterThanOrEqualTo(deskRow.top));
    expect(chart.bottom, lessThanOrEqualTo(deskRow.bottom));

    // Cột phụ (panel tabbed sổ lệnh) đứng CẠNH chart — không stacked.
    final bookTab = tester.getRect(
      find.byKey(MarketsTabletKeys.pairBookTab('book')),
    );
    expect(
      bookTab.left,
      greaterThan(chart.right),
      reason: 'Panel sổ lệnh phải nằm bên phải chart (2 cột desk).',
    );

    // Footer ghim đáy pane — không cuộn theo nội dung.
    expect(
      footer.bottom,
      greaterThan(780),
      reason: 'Dải giá + MUA/BÁN phải ghim sát đáy viewport (820dp).',
    );

    // Lề trái trong panel chart: nút interval đầu tiên thụng đúng
    // padding toolbar (x3) từ mép chart — không lệch thang tự phát.
    expect(
      firstInterval.left - chart.left,
      closeTo(AppSpacing.x3, 0.5),
      reason: 'Toolbar trong panel phải thụng lề nhất quán từ mép chart.',
    );
    final priceStat = tester.getRect(find.text('24h Cao'));
    expect(
      (priceStat.left - chart.left).abs(),
      lessThan(1),
      reason: 'Khối giá phải thẳng lề với khung chart (contentPad).',
    );
  });

  // V2 Bybit (2026-08-30): thanh công cụ MỘT hàng trong panel chart —
  // nút khung giờ text phẳng wired thật (đổi TF đổi dữ liệu nến), thay
  // cho 3 hàng rời (chips + pills + legend) từng bị gạch "dính nhau".
  testWidgets('SC-044 chart toolbar is one in-panel row of flat wired '
      'interval buttons', (tester) async {
    await pumpPairPane(tester);

    // Đủ 6 nút khung giờ + 2 chỉ báo trong CÙNG panel chart.
    for (final tf in ['15m', '1H', '4H', '1D', '1W', '1M']) {
      expect(find.byKey(MarketsTabletKeys.pairInterval(tf)), findsOneWidget);
    }
    expect(find.byKey(MarketsTabletKeys.pairIndicator('MA')), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pairIndicator('Vol')), findsOneWidget);

    // Toolbar nằm TRONG panel: nút đầu tiên và MA cùng MỘT hàng, ngay
    // trên mép chart (không còn các hàng rời phía trên chart).
    final chart = tester.getRect(find.byKey(MarketsTabletKeys.pairPaneChart));
    final firstButton = tester.getRect(
      find.byKey(MarketsTabletKeys.pairInterval('15m')),
    );
    final indicator = tester.getRect(
      find.byKey(MarketsTabletKeys.pairIndicator('MA')),
    );
    expect(
      firstButton.bottom,
      lessThanOrEqualTo(chart.top + 1),
      reason: 'Toolbar phải nằm trên chart trong cùng panel.',
    );
    // Hai hàng toolbar gọn trong panel: hàng interval rồi tới hàng MA/Vol.
    expect(
      indicator.top,
      greaterThanOrEqualTo(firstButton.bottom),
      reason: 'MA phải ở hàng dưới (hoặc sát) hàng interval trong panel.',
    );
    expect(
      indicator.bottom,
      lessThanOrEqualTo(chart.top + 1),
      reason: 'Cả 2 hàng toolbar phải nằm trên mép chart trong panel.',
    );

    // Wired thật: bấm 4H đổi timeframe — chart vẫn render không lỗi.
    await tester.tap(find.byKey(MarketsTabletKeys.pairInterval('4H')));
    await tester.pumpAndSettle();
    expect(find.byKey(MarketsTabletKeys.pairPaneChart), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // V2-C (Bybit pattern): panel tabbed cột phụ — bấm tab Giao dịch đổi
  // nội dung sang bảng giao dịch.
  testWidgets('SC-044 book panel tabs swap order book / recent trades', (
    tester,
  ) async {
    await pumpPairPane(tester);

    // Tab Sổ lệnh mặc định: có giá Mid trong header panel.
    expect(find.textContaining('Mid'), findsOneWidget);

    await tester.tap(find.byKey(MarketsTabletKeys.pairBookTab('trades')));
    await tester.pumpAndSettle();

    // Bảng giao dịch hiện header Thời gian; Mid là header PANEL nên vẫn
    // hiển thị ở cả 2 tab (kiến trúc tab, không phải nội dung tab).
    expect(find.text('Thời gian'), findsOneWidget);
    expect(find.textContaining('Mid'), findsOneWidget);
  });
}
