import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_book_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_chart_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_tape_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_simple_order_form.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';

class _CountingTradeRepository implements TradeRepository {
  _CountingTradeRepository(this._inner);

  final TradeRepository _inner;
  int screenFetchCount = 0;

  @override
  Future<TradeScreenSnapshot> getTrade({String pairId = 'btcusdt'}) {
    screenFetchCount++;
    return _inner.getTrade(pairId: pairId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<void> pumpTabletTrade(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    String initialLocation = AppRoutePaths.trade,
    TradeRepository? repository,
  }) async {
    // Mặc định: tablet portrait (khoảng 732dp nội dung sau nav rail) —
    // tầng GÓN của terminal (chart | đặt lệnh + tape); mặt ngang hơn
    // (≥1000dp nội dung) vào tầng đầy đủ 3 vùng.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Same fix as trade_page_test.dart: previewOrder is watched by
          // family key = draft (changes every keystroke); the default
          // 300ms loadDelay leaves an orphaned pending timer when the old
          // draft autodisposes before its Future resolves.
          tradeRepositoryProvider.overrideWithValue(
            repository ?? const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: initialLocation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SC-048 renders TradeTabletPage, not TradePage, at tablet width',
    (tester) async {
      await pumpTabletTrade(tester);

      expect(find.byType(TradeTabletPage), findsOneWidget);
      expect(find.byType(TradePage), findsNothing);
    },
  );

  testWidgets(
    'SC-048 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletTrade(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets('SC-048 full tier renders the 3-zone terminal: meta strip, chart '
      'column, 12-level book + 24-print tape, and the always-visible entry '
      'panel', (tester) async {
    await pumpTabletTrade(tester, size: const Size(1280, 800));

    // Hàng meta dày đặc thay banner ticker.
    expect(find.byKey(TradeTabletKeys.metaStrip), findsOneWidget);
    expect(find.byKey(TradeTabletKeys.tickerStrip), findsNothing);
    // Cột chart: toolbar khung giờ + OHLC readout wired thật.
    expect(find.byType(TradeTerminalChartPanel), findsOneWidget);
    expect(find.byKey(TradeTabletKeys.ohlcReadout), findsOneWidget);
    // Sổ lệnh 12 mức/bên + tape 24 dòng (fixture dày hóa).
    expect(find.byType(TradeTerminalBookPanel), findsOneWidget);
    for (var i = 0; i < 12; i++) {
      expect(find.byKey(TradeTabletKeys.bookRow('ask', i)), findsOneWidget);
      expect(find.byKey(TradeTabletKeys.bookRow('bid', i)), findsOneWidget);
    }
    expect(find.byType(TradeTerminalTapePanel), findsOneWidget);
    // ListView.builder cuộn nội bộ chỉ dựng hàng nhìn thấy — khóa hàng
    // đầu (24 print đến từ fixture dày hóa, mật độ đủ 2/3 panel).
    expect(find.byKey(TradeTabletKeys.tapeRow(0)), findsOneWidget);
    // Tab dưới chart hấp thụ cột secondary cũ.
    expect(find.byKey(TradeTabletKeys.bottomPanel), findsOneWidget);
    expect(find.text('Lệnh mở'), findsOneWidget);
    expect(find.text('Vị thế'), findsOneWidget);
    // Không còn nudge "Tiếp theo" của dashboard cũ.
    expect(find.text('Tiếp theo'), findsNothing);
    // Disclaimer rủi ro giữ kề form.
    expect(
      find.text(
        'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'SC-048 compact tier (portrait) keeps chart | entry + tape and moves '
    'the book into a third bottom tab',
    (tester) async {
      await pumpTabletTrade(tester, size: const Size(820, 1180));

      expect(tester.takeException(), isNull);
      // Không có cột sổ lệnh riêng…
      expect(find.byType(TradeTerminalBookPanel), findsNothing);
      // …nhưng có tab "Sổ lệnh" dưới chart, và tape vẫn hiện.
      expect(find.text('Sổ lệnh'), findsOneWidget);
      expect(find.byType(TradeTerminalTapePanel), findsOneWidget);
      expect(find.byKey(TradeTabletKeys.entryPanel), findsOneWidget);
      // Bật tab Sổ lệnh — bảng book compact 12 dòng (6 ask + 6 bid).
      await tester.tap(find.byKey(TradeTabletKeys.bottomTab('book')));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có dữ liệu sổ lệnh'), findsNothing);
    },
  );

  testWidgets('SC-048 side query preselects sell at tablet width', (
    tester,
  ) async {
    await pumpTabletTrade(
      tester,
      size: const Size(1280, 800),
      initialLocation: '${AppRoutePaths.trade}?side=sell',
    );

    expect(
      find.byKey(const Key('sc048_trade_active_sell_side')),
      findsOneWidget,
    );
  });

  testWidgets('SC-048 tablet rail navigates to Markets', (tester) async {
    await pumpTabletTrade(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pumpAndSettle();

    expect(find.byType(MarketsTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-048 keeps the risk panel inside the always-visible entry panel, '
    'not in the data columns — the financial-safety column invariant',
    (tester) async {
      await pumpTabletTrade(tester, size: const Size(1280, 800));

      expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
      expect(find.byType(VitTradeSimpleOrderForm), findsOneWidget);
      // Cả hai cùng tổ tiên là panel ĐẶT LỆNH (luôn hiện, không cuộn trang).
      final entryPanel = find.ancestor(
        of: find.byKey(TradeTabletKeys.entryPanel),
        matching: find.byType(TradeTerminalPanel),
      );
      expect(
        find.ancestor(
          of: find.byType(VitHighRiskStatePanel),
          matching: entryPanel,
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byType(VitTradeSimpleOrderForm),
          matching: entryPanel,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'SC-048 no layout overflow at every QA viewport (portrait + landscape '
    'matrix)',
    (tester) async {
      for (final size in [
        const Size(768, 1024),
        const Size(800, 1280),
        const Size(834, 1112),
        const Size(1024, 768),
        const Size(1112, 834),
        const Size(1280, 800),
      ]) {
        await pumpTabletTrade(tester, size: size);
        expect(tester.takeException(), isNull, reason: 'overflow at $size');
      }
    },
  );

  testWidgets(
    'SC-048 pair switcher swaps the terminal onto the selected pair route',
    (tester) async {
      await pumpTabletTrade(tester, size: const Size(1280, 800));

      await tester.tap(find.byKey(TradeTabletKeys.pairPicker));
      await tester.pumpAndSettle();

      expect(find.text('Chọn cặp giao dịch'), findsOneWidget);
      await tester.tap(find.text('ETH/USDT').last);
      await tester.pumpAndSettle();

      final router = GoRouter.of(tester.element(find.byType(TradeTabletPage)));
      expect(router.state.uri.path, AppRoutePaths.tradePair('ethusdt'));
      // Meta strip của terminal mới theo cặp ETH.
      expect(find.text('ETH/USDT'), findsAtLeast(1));
    },
  );

  testWidgets(
    'SC-048 refresh button in the meta strip re-fetches the trade screen',
    (tester) async {
      final repository = _CountingTradeRepository(
        const MockTradeRepository(loadDelay: Duration.zero),
      );
      await pumpTabletTrade(
        tester,
        size: const Size(1280, 800),
        repository: repository,
      );

      expect(repository.screenFetchCount, 1);

      await tester.tap(find.byKey(TradeTabletKeys.refresh));
      await tester.pumpAndSettle();

      expect(repository.screenFetchCount, 2);
      // Terminal còn nguyên composition sau khi làm mới.
      expect(find.byKey(TradeTabletKeys.metaStrip), findsOneWidget);
      expect(find.byType(VitTradeSimpleOrderForm), findsOneWidget);
    },
  );

  testWidgets(
    'SC-048 chart toolbar is wired: timeframe buttons switch series, MA '
    'toggle draws the legend',
    (tester) async {
      await pumpTabletTrade(tester, size: const Size(1280, 800));

      // Mặc định chỉ Vol bật → chưa có legend MA.
      expect(find.text('MA (7)'), findsNothing);

      await tester.tap(find.byKey(TradeTabletKeys.timeframe('1D')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(TradeTabletKeys.indicator('MA')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('MA (7)'), findsOneWidget);
      expect(find.byKey(TradeTabletKeys.ohlcReadout), findsOneWidget);
    },
  );
}
