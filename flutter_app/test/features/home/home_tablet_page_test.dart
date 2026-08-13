import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/phone/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/tablet/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_status_content.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tablet/markets_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletHome(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    MockHomeRepository repository = const MockHomeRepository(
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
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
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
    // The persistent 96px rail leaves 504px for page content, so the
    // dispatcher correctly keeps the phone reference at this edge width.
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(HomeTabletPage), findsNothing);
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
