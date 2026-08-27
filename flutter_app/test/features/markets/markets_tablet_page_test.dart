import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/widgets/markets_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_tools.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_master_list.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class _CountingMarketRepository implements MarketRepository {
  _CountingMarketRepository(this._inner);

  final MarketRepository _inner;
  int listFetchCount = 0;

  @override
  Future<MarketListSnapshot> getMarketList() {
    listFetchCount++;
    return _inner.getMarketList();
  }

  // The pair rows keep watching the realtime ticker during the test.
  @override
  Stream<List<MarketPair>> watchTicker() => _inner.watchTicker();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  /// Id cặp đầu tiên của mock snapshot — master rows mang key
  /// `sc008_pair_<id>` nên test cần id thật thay vì đoán.
  Future<String> firstMockPairId() async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketList();
    return snapshot.marketPairs.first.id;
  }

  Future<void> pumpTabletMarkets(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    MarketRepository? repository,
    String initialLocation = AppRoutePaths.markets,
  }) async {
    // Default: iPad Air portrait — above AppBreakpoints.tablet (600) but
    // below the terminal shell's own two-column threshold (900), so this
    // exercises the single-column tablet fallback.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (repository != null)
            marketRepositoryProvider.overrideWithValue(repository),
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
    'SC-008 renders the terminal master-detail shell, not MarketListPage, '
    'at tablet width',
    (tester) async {
      await pumpTabletMarkets(tester);

      expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
      expect(find.byType(MarketsTabletPage), findsOneWidget);
      expect(find.byType(MarketListPage), findsNothing);
    },
  );

  testWidgets(
    'SC-008 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletMarkets(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets(
    'SC-008 master list carries the watchlist-first tab, search and the '
    'compact sort row; overview pane carries the market snapshot',
    (tester) async {
      await pumpTabletMarkets(tester);

      // Master column.
      expect(find.byType(MarketsMasterList), findsOneWidget);
      expect(find.byKey(MarketsTabletKeys.search), findsOneWidget);
      // Watchlist-first: chip «Yêu thích» đứng trước mọi chip danh mục.
      expect(
        find.byKey(MarketsTabletKeys.category('Yêu thích')),
        findsOneWidget,
      );
      expect(find.byKey(MarketsTabletKeys.sortColumn('price')), findsOneWidget);
      expect(
        find.byKey(MarketsTabletKeys.sortColumn('volume')),
        findsOneWidget,
      );

      // Overview detail pane.
      expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
      expect(find.text('Tăng mạnh'), findsOneWidget);
      expect(find.text('Giảm mạnh'), findsOneWidget);
      expect(find.text('Công cụ thị trường'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is MarketListTools && widget.tablet,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('SC-008 tablet rail navigates to Wallet', (tester) async {
    await pumpTabletMarkets(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_wallet')));
    await tester.pumpAndSettle();

    expect(find.byType(WalletTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-008 wide tablet renders the master column framed beside the detail '
    'pane without overflow',
    (tester) async {
      // Landscape tablet, above the terminal shell's own two-column
      // threshold (900) — the width-capped Align+ConstrainedBox layout with
      // the framed master card only engages at/above this width.
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(find.byType(MarketsMasterList), findsOneWidget);
      // Master column is framed as a distinct panel (R7 idiom).
      expect(
        find.ancestor(
          of: find.byKey(MarketsTabletKeys.masterList),
          matching: find.byType(VitCard),
        ),
        findsOneWidget,
      );
      // Detail pane still carries the overview composition.
      expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
    },
  );

  testWidgets(
    'SC-008 portrait split keeps the master list beside the overview pane '
    '(no stacking, no full-page push)',
    (tester) async {
      // iPad-Settings portrait semantics (2026-08-27): between
      // masterDetailSplitMinWidth (680) and twoColumnMinWidth (900) the
      // shell keeps the split with the narrow 320 master — rotation
      // changes sizes, never the composition.
      await pumpTabletMarkets(tester, size: const Size(820, 1180));

      expect(tester.takeException(), isNull);
      expect(find.byType(MarketsMasterList), findsOneWidget);
      expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
      // Master sits BESIDE the overview: the search bar starts to the
      // left of the pane's pulse strip.
      expect(
        tester.getTopLeft(find.byKey(MarketsTabletKeys.search)).dx,
        lessThan(
          tester.getTopLeft(find.byKey(MarketsTabletKeys.pulseStrip)).dx,
        ),
      );
    },
  );

  testWidgets(
    'SC-008 stacked fallback below the split threshold stacks the master '
    'list above the overview pane without overflow',
    (tester) async {
      // Below the portrait split threshold (window-resize territory —
      // real tablets keep the split even in portrait): the shell's own
      // single-column fallback (master flex5 above overview flex6).
      await pumpTabletMarkets(tester, size: const Size(700, 900));

      expect(tester.takeException(), isNull);
      expect(find.byType(MarketsMasterList), findsOneWidget);
      expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
      // Master sits above the overview: search bar.top < pulse strip.top.
      expect(
        tester.getTopLeft(find.byKey(MarketsTabletKeys.search)).dy,
        lessThan(
          tester.getTopLeft(find.byKey(MarketsTabletKeys.pulseStrip)).dy,
        ),
      );
    },
  );

  testWidgets(
    'SC-008 watchlist mode filters the master list and comes back to the '
    'full list',
    (tester) async {
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      // Watchlist-first: the master list opens on «Yêu thích». The mock
      // seed decides between filtered rows and the guiding empty state —
      // either way the pane must never look broken.
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(MarketsTabletKeys.category('Tất cả')));
      await tester.pumpAndSettle();

      // Full list shows real pair rows again.
      final firstPairId = await firstMockPairId();
      expect(find.byKey(MarketsTabletKeys.pair(firstPairId)), findsOneWidget);
    },
  );

  testWidgets('SC-008 short watchlist shows a see-all hint below the rows', (
    tester,
  ) async {
    await pumpTabletMarkets(tester, size: const Size(1180, 820));

    // Watchlist-first mở với 3 cặp mock (≤ ngưỡng ngắn) → hint hiện ngay
    // dưới hàng cuối, lấp dead space của khung master full-height.
    expect(find.byKey(MarketsTabletKeys.watchlistShortHint), findsOneWidget);
    expect(find.text('Chỉ có 3 cặp trong Yêu thích'), findsOneWidget);

    await tester.tap(find.text('Xem tất cả cặp'));
    await tester.pumpAndSettle();

    // Về danh sách đầy đủ: hint biến mất, cặp không-favorite xuất hiện.
    expect(find.byKey(MarketsTabletKeys.watchlistShortHint), findsNothing);
    expect(find.byKey(MarketsTabletKeys.pair('solusdt')), findsOneWidget);
  });

  testWidgets(
    'SC-008 tapping a master row opens the pair route inside the detail '
    'pane while the master column stays put',
    (tester) async {
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(MarketsTabletKeys.category('Tất cả')));
      await tester.pumpAndSettle();

      final firstPairId = await firstMockPairId();
      await tester.tap(find.byKey(MarketsTabletKeys.pair(firstPairId)));
      await tester.pumpAndSettle();

      // Selection is route-driven: the shell and master list survive the
      // navigation; the pair route renders in the detail pane (slice 1:
      // the utility placeholder carries it until the real pane lands).
      expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
      expect(find.byType(MarketsMasterList), findsOneWidget);
      expect(find.byType(MarketsTabletPage), findsNothing);
    },
  );

  testWidgets(
    'SC-008 deep link straight into /pair/btcusdt still frames the master '
    'column',
    (tester) async {
      await pumpTabletMarkets(
        tester,
        size: const Size(1180, 820),
        initialLocation: '/pair/btcusdt',
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
      expect(find.byType(MarketsMasterList), findsOneWidget);
      // Route-derived selection: btcusdt is the highlighted master row.
      expect(find.byKey(MarketsTabletKeys.pair('btcusdt')), findsOneWidget);
    },
  );

  testWidgets('SC-008 system back from a pair pane returns to the overview', (
    tester,
  ) async {
    await pumpTabletMarkets(tester, size: const Size(1180, 820));

    await tester.tap(find.byKey(MarketsTabletKeys.category('Tất cả')));
    await tester.pumpAndSettle();

    final firstPairId = await firstMockPairId();
    await tester.tap(find.byKey(MarketsTabletKeys.pair(firstPairId)));
    await tester.pumpAndSettle();
    expect(find.byType(MarketsTabletPage), findsNothing);

    // Push-first semantics: back pops the pane and lands on the overview
    // with the master column intact — not out of the tab.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MarketsTabletPage), findsOneWidget);
    expect(find.byType(MarketsTabletMasterShell), findsOneWidget);
  });

  testWidgets(
    'SC-008 overview keeps rendering while the master list reflects an '
    'active search filter',
    (tester) async {
      // The master list and the overview pane scroll independently; an
      // empty-filtered master must not blank the detail pane (R7 spirit —
      // no accidental-gap reads).
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      await tester.enterText(
        find.byKey(MarketsTabletKeys.search),
        'zzz-khong-ton-tai',
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(VitEmptyState), findsOneWidget);
      expect(find.text('Tăng mạnh'), findsOneWidget);
      expect(find.byType(MarketListTools), findsOneWidget);
    },
  );

  test('nextSortForColumn cycles through the shared sort options', () {
    expect(nextSortForColumn('price', 'default'), 'price_desc');
    expect(nextSortForColumn('price', 'price_desc'), 'price_asc');
    expect(nextSortForColumn('price', 'price_asc'), 'default');
    // volume has no ascending step in the shared sort set.
    expect(nextSortForColumn('volume', 'default'), 'volume_desc');
    expect(nextSortForColumn('volume', 'volume_desc'), 'default');
    expect(nextSortForColumn('change', 'change_desc'), 'change_asc');
    // Unknown columns never touch the active sort.
    expect(nextSortForColumn('unknown', 'price_desc'), 'price_desc');
  });

  testWidgets('SC-008 tablet market pulse banner aggregates the snapshot', (
    tester,
  ) async {
    await pumpTabletMarkets(tester);

    expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
    expect(find.text('Vốn hóa thị trường'), findsOneWidget);
    expect(find.text('Khối lượng 24h'), findsOneWidget);
    expect(find.text('Điểm tăng/giảm'), findsOneWidget);
    expect(find.text('Tăng mạnh nhất'), findsOneWidget);
    expect(find.text('Giảm mạnh nhất'), findsOneWidget);
  });

  testWidgets('SC-008 master list sorts by tapping the compact sort row', (
    tester,
  ) async {
    await pumpTabletMarkets(tester, size: const Size(1180, 820));

    await tester.tap(find.byKey(MarketsTabletKeys.category('Tất cả')));
    await tester.pumpAndSettle();

    final changeHeader = find.byKey(MarketsTabletKeys.sortColumn('change'));
    expect(changeHeader, findsOneWidget);
    // Inactive first: the neutral unfold_more affordance, no active arrow.
    expect(
      find.descendant(
        of: changeHeader,
        matching: find.byIcon(Icons.unfold_more_rounded),
      ),
      findsOneWidget,
    );

    await tester.tap(changeHeader);
    await tester.pumpAndSettle();

    // First tap lands on change_desc — the descending arrow is active.
    expect(
      find.descendant(
        of: changeHeader,
        matching: find.byIcon(Icons.keyboard_arrow_down_rounded),
      ),
      findsOneWidget,
    );

    await tester.tap(changeHeader);
    await tester.pumpAndSettle();

    // Second tap flips to change_asc.
    expect(
      find.descendant(
        of: changeHeader,
        matching: find.byIcon(Icons.keyboard_arrow_up_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-008 tablet pull-to-refresh re-fetches the market list', (
    tester,
  ) async {
    final repository = _CountingMarketRepository(
      const MockMarketRepository(loadDelay: Duration.zero),
    );
    await pumpTabletMarkets(
      tester,
      size: const Size(1180, 820),
      repository: repository,
    );

    expect(repository.listFetchCount, 1);

    // Fling inside the overview pane's scroll — the only fixed chrome is
    // the shell's header; the pane scrolls and refreshes.
    final overviewScroll = find.byType(SingleChildScrollView).first;
    await tester.fling(overviewScroll, const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.listFetchCount, 2);
    expect(find.byType(MarketsTabletPage), findsOneWidget);
    // The refreshed shell still carries the full terminal composition.
    expect(find.byKey(MarketsTabletKeys.masterList), findsOneWidget);
    expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
  });
}
