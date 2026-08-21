import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/domain/repositories/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_pairs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_pairs_panel.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_movers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_tools.dart';
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
  Future<void> pumpTabletMarkets(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    MarketRepository? repository,
  }) async {
    // Default: iPad Air portrait — above AppBreakpoints.tablet (600) but
    // below the dashboard's own two-column threshold, so this exercises the
    // single-column tablet fallback.
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
            initialLocation: AppRoutePaths.markets,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SC-008 renders MarketsTabletPage, not MarketListPage, at tablet width',
    (tester) async {
      await pumpTabletMarkets(tester);

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

  testWidgets('SC-008 tablet dashboard renders both dashboard columns', (
    tester,
  ) async {
    await pumpTabletMarkets(tester);

    // Primary column's pair list.
    expect(find.byType(MarketListPairsPanel), findsOneWidget);
    // Secondary column's market snapshot.
    expect(find.text('Tăng mạnh'), findsOneWidget);
    expect(find.text('Giảm mạnh'), findsOneWidget);
    expect(find.text('Công cụ thị trường'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is MarketListTools && widget.tablet,
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-008 tablet rail navigates to Wallet', (tester) async {
    await pumpTabletMarkets(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_wallet')));
    await tester.pumpAndSettle();

    expect(find.byType(WalletTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-008 wide tablet renders the true two-column dashboard without '
    'overflow, secondary column framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above MarketsTabletPage's own two-column
      // threshold (900) — the width-capped Align+ConstrainedBox+VitCard
      // layout only engages at/above this width.
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(find.byType(MarketListPairsPanel), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Tăng mạnh'),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'SC-008 wide tablet keeps the market snapshot panel while the primary '
    'column reflects an active search filter',
    (tester) async {
      // Confirms the deliberate decoupling from `showMarketSummary`: on
      // phone, top movers/tools are hidden while searching (shared-scroll
      // space economy); the tablet secondary column has its own
      // independent scroll (R4), so it keeps rendering regardless — an
      // empty secondary panel while filtering would read as an accidental
      // gap, not an intentional sidebar (R7).
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      await tester.enterText(
        find.byKey(MarketsTabletKeys.search),
        'a currency that does not exist',
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Primary column now shows the empty-filtered state.
      expect(find.byType(VitEmptyState), findsOneWidget);
      // Secondary column's market snapshot is still fully present.
      expect(find.text('Tăng mạnh'), findsOneWidget);
      expect(find.text('Giảm mạnh'), findsOneWidget);
      expect(find.byType(MarketListTools), findsOneWidget);
    },
  );

  testWidgets(
    'SC-008 wide tablet keeps compact vertical rhythm between snapshot '
    'sections',
    (tester) async {
      await pumpTabletMarkets(tester, size: const Size(1180, 820));

      final movers = tester.getRect(find.byType(MarketListTopMovers));
      final toolsTitle = tester.getRect(find.text('Công cụ thị trường'));
      final discoverTitle = tester.getRect(find.text('Lối tắt từ Markets'));
      final discoverCard = tester.getRect(
        find
            .ancestor(
              of: find.text('Dự đoán thị trường'),
              matching: find.byType(VitCard),
            )
            .first,
      );

      expect(
        toolsTitle.top - movers.bottom,
        closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
      );
      expect(
        discoverCard.top - discoverTitle.bottom,
        closeTo(AppSpacing.pageRhythmCompactInnerGap, 0.01),
      );
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

  testWidgets('SC-008 tablet pair table sorts by tapping column headers', (
    tester,
  ) async {
    await pumpTabletMarkets(tester, size: const Size(1180, 820));

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

    // Fling inside the primary scrolling column — the pulse banner is
    // fixed and never scrolls.
    final primaryColumn = find.byType(SingleChildScrollView).first;
    await tester.fling(primaryColumn, const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.listFetchCount, 2);
    expect(find.byType(MarketsTabletPage), findsOneWidget);
    // The refreshed dashboard still carries the full tablet composition.
    expect(find.byKey(MarketsTabletKeys.pulseStrip), findsOneWidget);
    expect(find.byType(MarketListPairsPanel), findsOneWidget);
  });
}
