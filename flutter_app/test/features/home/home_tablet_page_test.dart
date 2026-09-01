import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_more_products_sheet.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_status_content.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletHome(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    HomeRepository repository = const MockHomeRepository(
      loadDelay: Duration.zero,
    ),
    bool settle = true,
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
        overrides: [homeRepositoryProvider.overrideWithValue(repository)],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: AppRoutePaths.home,
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  testWidgets('SC-007 renders HomeTabletPage, not HomePage, at tablet width', (
    tester,
  ) async {
    await pumpTabletHome(tester);

    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets(
    'SC-007 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletHome(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets(
    'SC-007 tablet renders its dedicated dark reference composition',
    (tester) async {
      await pumpTabletHome(tester);

      expect(find.byType(HomeTabletReferenceHome), findsOneWidget);
      expect(find.byKey(const Key('vit_navigation_rail_light')), findsNothing);
      expect(find.text('Tổng tài sản ước tính'), findsOneWidget);
      expect(find.text('Hành động nhanh'), findsOneWidget);
      expect(find.text('Dự đoán & Thách đấu'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(VitSectionHeader),
          matching: find.text('Thị trường'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'SC-007 tablet KPI strip banner spans above the watchlist on one gap '
    'line (monitor-first composition)',
    (tester) async {
      await pumpTabletHome(tester, size: const Size(1024, 820));

      final kpiStrip = tester.getRect(find.byKey(HomeTabletKeys.portfolioCard));
      final marketHeader = tester.getRect(
        find.ancestor(
          of: find.descendant(
            of: find.byType(VitSectionHeader),
            matching: find.text('Thị trường'),
          ),
          matching: find.byType(VitSectionHeader),
        ),
      );

      // The banner sits one shared block gap above the columns.
      expect(
        marketHeader.top - kpiStrip.bottom,
        closeTo(TabletDashboardWidths.blockVerticalGap, 0.01),
      );
      // No phone ticker strip in the monitor-first composition.
      expect(find.byKey(HomeTabletKeys.marketTicker), findsNothing);
    },
  );

  testWidgets('SC-007 tablet uses law-12 spacing between sidebar sections', (
    tester,
  ) async {
    await pumpTabletHome(tester, size: const Size(1180, 820));

    final nextAction = tester.getRect(find.byKey(HomeTabletKeys.nextAction));
    final quickActions = tester.getRect(
      find.byKey(HomeTabletKeys.productsSection),
    );
    final recentProducts = tester.getRect(
      find.byKey(HomeTabletKeys.recentProductsSection),
    );

    // Luật 12dp (2026-08-31): mọi section gap khối tablet = 12.
    expect(
      quickActions.top - nextAction.bottom,
      closeTo(TabletSpacingTokens.x4, 0.01),
    );
    expect(
      recentProducts.top - quickActions.bottom,
      closeTo(TabletSpacingTokens.x4, 0.01),
    );
  });

  testWidgets('SC-007 tablet rail navigates to Markets', (tester) async {
    await pumpTabletHome(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pumpAndSettle();

    // Markets is also tablet-adaptive as of this batch — at this width it
    // resolves to its own single-column tablet fallback, not the raw phone
    // page (see markets_tablet_page_test.dart for its own dispatch tests).
    expect(find.byType(MarketsTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-007 tablet masks account metrics and trend when balance is hidden',
    (tester) async {
      await pumpTabletHome(tester);

      expect(find.text('\$54,276.79'), findsAtLeastNWidgets(1));
      await tester.tap(find.byTooltip('Ẩn số dư'));
      await tester.pumpAndSettle();

      expect(find.text('\$54,276.79'), findsNothing);
      expect(find.text('••••••'), findsAtLeastNWidgets(1));
    },
  );

  testWidgets(
    'SC-007 tablet prioritizes security announcements over campaigns like '
    'phone',
    (tester) async {
      await pumpTabletHome(
        tester,
        repository: _StaticHomeRepository(
          _homeSnapshotWithAnnouncements(const [
            HomeAnnouncement(
              id: 'campaign-test',
              text: 'Campaign test',
              type: HomeAnnouncementType.campaign,
            ),
            HomeAnnouncement(
              id: 'security-test',
              text: 'Security test',
              type: HomeAnnouncementType.security,
            ),
          ]),
        ),
      );

      expect(find.text('Security test'), findsOneWidget);
      expect(find.text('Campaign test'), findsNothing);
    },
  );

  testWidgets('SC-007 tablet notice line navigates on tap instead of cycling', (
    tester,
  ) async {
    await pumpTabletHome(
      tester,
      repository: _StaticHomeRepository(
        _homeSnapshotWithAnnouncements(const [
          HomeAnnouncement(
            id: 'security-test',
            text: 'Security test',
            type: HomeAnnouncementType.security,
            routePath: '/settings/security',
          ),
          HomeAnnouncement(
            id: 'campaign-test',
            text: 'Campaign test',
            type: HomeAnnouncementType.campaign,
          ),
        ]),
      ),
    );

    // Static single-announcement notice — the carousel is gone.
    expect(find.text('Security test'), findsOneWidget);
    expect(find.text('Campaign test'), findsNothing);

    await tester.tap(find.byKey(HomeTabletKeys.announcement));
    await tester.pumpAndSettle();

    // Tapping acts on the announcement: it navigates to its route
    // (settings renders its own tablet page, not Home's dashboard).
    expect(find.byType(HomeTabletPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-007 tablet exposes a loading state before data resolves', (
    tester,
  ) async {
    await pumpTabletHome(
      tester,
      size: const Size(768, 820),
      repository: const MockHomeRepository(loadDelay: Duration(seconds: 1)),
      settle: false,
    );

    expect(find.byType(HomeLoadingContent), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'SC-007 tablet loading keeps the two-column shape at wide widths',
    (tester) async {
      await pumpTabletHome(
        tester,
        size: const Size(1180, 820),
        repository: const MockHomeRepository(loadDelay: Duration(seconds: 1)),
        settle: false,
      );

      expect(find.byType(HomeLoadingContent), findsOneWidget);
      expect(find.byType(VitTwoColumnTabletDashboard), findsOneWidget);
      // Banner KPI skeleton spans above the columns; the primary column is
      // the watchlist skeleton alone.
      expect(find.byType(HomeKpiStripSkeleton), findsOneWidget);
      expect(find.byType(HomeMarketSkeleton), findsOneWidget);
      // The sidebar skeleton mirrors the loaded block order: notice →
      // next action → quick actions → recent → discovery.
      expect(find.byType(HomeAnnouncementSkeleton), findsOneWidget);
      expect(find.byType(HomeDiscoverySkeleton), findsOneWidget);
      double topOf(Type widgetType) =>
          tester.getTopLeft(find.byType(widgetType)).dy;
      expect(
        topOf(HomeAnnouncementSkeleton),
        lessThan(topOf(HomeNextActionSkeleton)),
      );
      expect(
        topOf(HomeNextActionSkeleton),
        lessThan(topOf(HomeProductsSkeleton)),
      );
      expect(
        topOf(HomeProductsSkeleton),
        lessThan(topOf(HomeRecentProductsSkeleton)),
      );
      expect(
        topOf(HomeRecentProductsSkeleton),
        lessThan(topOf(HomeDiscoverySkeleton)),
      );
      // One RefreshIndicator per independently scrolling column.
      expect(find.byType(RefreshIndicator), findsNWidgets(2));
      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byType(HomeTabletReferenceHome), findsOneWidget);
    },
  );

  testWidgets('SC-007 tablet pull-to-refresh re-fetches the snapshot', (
    tester,
  ) async {
    final repository = _CountingHomeRepository(
      const MockHomeRepository(loadDelay: Duration.zero),
    );
    await pumpTabletHome(
      tester,
      size: const Size(1180, 820),
      repository: repository,
    );

    expect(repository.fetchCount, 1);

    // Fling inside the primary scrolling column — the KPI banner is fixed
    // and never scrolls.
    final primaryColumn = find.byType(SingleChildScrollView).first;
    await tester.fling(primaryColumn, const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.fetchCount, 2);
    expect(find.byType(HomeTabletReferenceHome), findsOneWidget);
    // Refresh preserves the surface's own UI state (contract §7): the
    // balance stays masked after a refresh cycle.
    await tester.tap(find.byTooltip('Ẩn số dư'));
    await tester.pumpAndSettle();
    await tester.fling(primaryColumn, const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.fetchCount, 3);
    expect(find.text('\$54,276.79'), findsNothing);
    expect(find.text('••••••'), findsAtLeastNWidgets(1));
  });

  testWidgets('SC-007 tablet «Xem thêm» opens the catalog dialog without grid '
      'duplicates', (tester) async {
    await pumpTabletHome(tester);

    final moreAction = find.textContaining('Xem thêm');
    expect(moreAction, findsOneWidget);
    await tester.ensureVisible(moreAction);
    await tester.tap(moreAction);
    await tester.pumpAndSettle();

    // Tablet presents the catalog as a centered dialog, not the phone
    // bottom sheet.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(HomeMoreProductsSheet), findsNothing);
    // …and as compact list rows, not the old tile grid.
    expect(
      find.descendant(
        of: find.byKey(HomePage.moreProductsSheetKey),
        matching: find.byType(VitActionTileGrid),
      ),
      findsNothing,
    );
    expect(find.text('Tất cả sản phẩm'), findsOneWidget);
    expect(find.text('Đóng'), findsOneWidget);
    expect(find.text('Margin'), findsOneWidget);
    expect(find.text('Copy Trade'), findsOneWidget);
    expect(find.text('Bot'), findsOneWidget);
    // «Chủ đề» twice: the tile label plus its state badge share the text.
    expect(find.text('Chủ đề'), findsNWidgets(2));
    // The 3x3 grid holds all 9 quick actions — Launchpad included — so the
    // catalog carries only the product groups beyond them.
    expect(
      find.descendant(
        of: find.byKey(HomeTabletKeys.productsSection),
        matching: find.text('Launchpad'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(HomePage.moreProductsSheetKey),
        matching: find.text('Launchpad'),
      ),
      findsNothing,
    );
    // Products already visible in the sidebar grid stay out of the catalog.
    expect(
      find.descendant(
        of: find.byKey(HomePage.moreProductsSheetKey),
        matching: find.text('Staking'),
      ),
      findsNothing,
    );

    await tester.tap(find.text('Copy Trade'));
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.moreProductsSheetKey), findsNothing);
  });

  testWidgets('SC-007 tablet catalog dialog closes via «Đóng»', (tester) async {
    await pumpTabletHome(tester);

    final moreAction = find.textContaining('Xem thêm');
    await tester.ensureVisible(moreAction);
    await tester.tap(moreAction);
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.moreProductsSheetKey), findsOneWidget);

    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.moreProductsSheetKey), findsNothing);
  });

  testWidgets(
    'SC-007 tablet «Gần đây» renders vertical rows and navigates on tap',
    (tester) async {
      await pumpTabletHome(tester);

      // Vertical sidebar rows (tablet idiom), not the phone horizontal strip.
      expect(find.byType(VitCompactProductCard), findsNothing);
      final recentSection = find.byKey(HomeTabletKeys.recentProductsSection);
      expect(
        find.descendant(
          of: recentSection,
          matching: find.byType(VitIconListRow),
        ),
        findsAtLeastNWidgets(3),
      );
      expect(
        find.descendant(of: recentSection, matching: find.text('BTC/USDT')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: recentSection, matching: find.text('P2P USDT/VND')),
        findsOneWidget,
      );

      final row = find.byKey(HomeTabletKeys.recentProduct('spot-btc'));
      await tester.ensureVisible(row);
      await tester.tap(row);
      await tester.pumpAndSettle();

      expect(find.byType(HomeTabletPage), findsNothing);
      // Trade tablet giờ là terminal 3 vùng (2026-08-31), không còn
      // VitTwoColumnTabletDashboard.
      expect(find.byType(TradeTabletPage), findsOneWidget);
    },
  );

  testWidgets('SC-007 tablet exposes a retryable error state', (tester) async {
    await pumpTabletHome(
      tester,
      size: const Size(768, 820),
      repository: const MockHomeRepository(simulateError: true),
    );

    expect(find.byType(VitErrorState), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets(
    'SC-007 wide tablet renders independent primary and sidebar scrolls',
    (tester) async {
      await pumpTabletHome(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(find.byType(HomeTabletReferenceHome), findsOneWidget);
      expect(
        find.byKey(const Key('sc007_home_tablet_dashboard')),
        findsOneWidget,
      );
      expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(2));
      expect(find.text('Tổng tài sản ước tính'), findsOneWidget);
      expect(find.text('Dự đoán & Thách đấu'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  Future<void> expectSafeAtWidth(WidgetTester tester, double width) async {
    await pumpTabletHome(tester, size: Size(width, 820));
    expect(tester.takeException(), isNull, reason: 'width=$width');
    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(HomeTabletReferenceHome), findsOneWidget);
  }

  testWidgets('SC-007 shell is overflow-safe at 600px', (tester) async {
    await pumpTabletHome(tester, size: const Size(600, 820));
    expect(tester.takeException(), isNull);
    // Từ 600px bootstrap chọn surface Tablet: trang tablet tự fallback một
    // cột khi nội dung hẹp (VitTwoColumnTabletDashboard dưới 900px) — không
    // còn chế độ mixed tablet-shell + phone-content ở cạnh breakpoint.
    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('SC-007 tablet page starts safely once content reaches 600px', (
    tester,
  ) async {
    await expectSafeAtWidth(tester, 696);
  });

  testWidgets('SC-007 is overflow-safe at 768px', (tester) async {
    await expectSafeAtWidth(tester, 768);
  });

  testWidgets('SC-007 is overflow-safe at 1024px', (tester) async {
    await expectSafeAtWidth(tester, 1024);
  });

  testWidgets('SC-007 is overflow-safe at 1280px', (tester) async {
    await expectSafeAtWidth(tester, 1280);
  });
}

final class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository(this.snapshot);

  final HomeSnapshot snapshot;

  @override
  Future<HomeSnapshot> fetchHome() async => snapshot;
}

final class _CountingHomeRepository implements HomeRepository {
  _CountingHomeRepository(this._inner);

  final HomeRepository _inner;
  int fetchCount = 0;

  @override
  Future<HomeSnapshot> fetchHome() {
    fetchCount++;
    return _inner.fetchHome();
  }
}

HomeSnapshot _homeSnapshotWithAnnouncements(
  List<HomeAnnouncement> announcements,
) {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: announcements,
    quickActions: snapshot.quickActions,
    productGroups: snapshot.productGroups,
    nextAction: snapshot.nextAction,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}
