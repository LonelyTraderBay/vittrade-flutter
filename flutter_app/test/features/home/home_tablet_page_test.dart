import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_status_content.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
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

  testWidgets('SC-007 tablet uses compact spacing between primary sections', (
    tester,
  ) async {
    await pumpTabletHome(tester, size: const Size(1024, 820));

    final portfolio = tester.getRect(find.byKey(HomeTabletKeys.portfolioCard));
    final ticker = tester.getRect(find.byKey(HomeTabletKeys.marketTicker));
    final marketHeader = tester.getRect(
      find.ancestor(
        of: find.descendant(
          of: find.byType(VitSectionHeader),
          matching: find.text('Thị trường'),
        ),
        matching: find.byType(VitSectionHeader),
      ),
    );

    expect(
      ticker.top - portfolio.bottom,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
    );
    expect(
      marketHeader.top - ticker.bottom,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
    );
  });

  testWidgets('SC-007 tablet uses compact spacing between sidebar sections', (
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

    expect(
      quickActions.top - nextAction.bottom,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
    );
    expect(
      recentProducts.top - quickActions.bottom,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
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

  testWidgets('SC-007 tablet announcement cycles on tap', (tester) async {
    await pumpTabletHome(
      tester,
      repository: _StaticHomeRepository(
        _homeSnapshotWithAnnouncements(const [
          HomeAnnouncement(
            id: 'security-test',
            text: 'Security test',
            type: HomeAnnouncementType.security,
          ),
          HomeAnnouncement(
            id: 'campaign-test',
            text: 'Campaign test',
            type: HomeAnnouncementType.campaign,
          ),
        ]),
      ),
    );

    expect(find.text('Security test'), findsOneWidget);

    await tester.tap(find.byKey(HomeTabletKeys.announcement));
    await tester.pumpAndSettle();

    expect(find.text('Campaign test'), findsOneWidget);
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
      expect(find.byType(HomeMarketTickerSkeleton), findsOneWidget);
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

    await tester.fling(
      find.text('Tổng tài sản ước tính'),
      const Offset(0, 400),
      1000,
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.fetchCount, 2);
    expect(find.byType(HomeTabletReferenceHome), findsOneWidget);
    // Refresh preserves the surface's own UI state (contract §7): the
    // balance stays masked after a refresh cycle.
    await tester.tap(find.byTooltip('Ẩn số dư'));
    await tester.pumpAndSettle();
    await tester.fling(
      find.text('Tổng tài sản ước tính'),
      const Offset(0, 400),
      1000,
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.fetchCount, 3);
    expect(find.text('\$54,276.79'), findsNothing);
    expect(find.text('••••••'), findsAtLeastNWidgets(1));
  });

  testWidgets('SC-007 tablet «Xem thêm» opens the catalog sheet without grid '
      'duplicates', (tester) async {
    await pumpTabletHome(tester);

    final moreAction = find.textContaining('Xem thêm');
    expect(moreAction, findsOneWidget);
    await tester.ensureVisible(moreAction);
    await tester.tap(moreAction);
    await tester.pumpAndSettle();

    expect(find.text('Thêm hành động'), findsOneWidget);
    expect(find.text('Margin'), findsOneWidget);
    expect(find.text('Copy Trade'), findsOneWidget);
    expect(find.text('Bot'), findsOneWidget);
    // «Chủ đề» twice: the tile label plus its state badge share the text.
    expect(find.text('Chủ đề'), findsNWidgets(2));
    // Products already visible in the sidebar grid stay out of the sheet.
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
