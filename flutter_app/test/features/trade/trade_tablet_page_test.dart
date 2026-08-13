import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tablet/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/phone/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/tablet/trade_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_positions_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_simple_hero.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_simple_order_form.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletTrade(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    String initialLocation = AppRoutePaths.trade,
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
          // Same fix as trade_page_test.dart: previewOrder is watched by
          // family key = draft (changes every keystroke); the default
          // 300ms loadDelay leaves an orphaned pending timer when the old
          // draft autodisposes before its Future resolves.
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
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

  testWidgets('SC-048 tablet dashboard renders both dashboard columns', (
    tester,
  ) async {
    await pumpTabletTrade(tester);

    // Primary column: order-entry backbone.
    expect(find.byType(VitTradeSimpleHero), findsOneWidget);
    expect(find.byType(VitTradeSimpleOrderForm), findsOneWidget);
    // Secondary column: glanceable/cross-sell content.
    expect(find.text('Tiếp theo'), findsOneWidget);
    expect(find.text('Tài sản của bạn'), findsOneWidget);
    // Same disclaimer VitTradeSimpleShell appends unconditionally on phone.
    expect(
      find.text(
        'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-048 side query preselects sell at tablet width', (
    tester,
  ) async {
    await pumpTabletTrade(
      tester,
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
    'SC-048 wide tablet renders the true two-column dashboard without '
    'overflow, secondary column framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above TradeTabletPage's own two-column threshold
      // (900) — the width-capped Align+ConstrainedBox+VitCard layout only
      // engages at/above this width.
      await pumpTabletTrade(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(find.byType(VitTradeSimpleHero), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Tài sản của bạn'),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets('SC-048 wide tablet keeps the risk panel beside Hero/Form in the '
      'primary column, not inside the secondary column card', (tester) async {
    // Direct evidence for the deliberate financial-safety column split:
    // "Đánh giá rủi ro" must stay adjacent to the order-entry backbone
    // rather than drifting into the secondary column's VitCard(inner)
    // wrapper — see TradeTabletPage's doc comment.
    await pumpTabletTrade(tester, size: const Size(1180, 820));

    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byType(VitHighRiskStatePanel),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
    // Differentiator sanity check: secondary column content does sit
    // inside the VitCard(inner) wrapper, so the assertion above is
    // actually distinguishing columns, not vacuously true.
    expect(
      find.ancestor(
        of: find.byType(TradePositionsPanel),
        matching: find.byType(VitCard),
      ),
      findsWidgets,
    );
  });

  testWidgets(
    'SC-048 wide tablet keeps compact section rhythm in both columns',
    (tester) async {
      await pumpTabletTrade(tester, size: const Size(1180, 820));

      final hero = tester.getRect(find.byType(VitTradeSimpleHero));
      final orderForm = tester.getRect(find.byType(VitTradeSimpleOrderForm));
      final nextSection = tester.getRect(
        find.ancestor(
          of: find.byKey(TradeTabletKeys.nextAction),
          matching: find.byType(VitTradeSection),
        ),
      );
      final assetsSection = tester.getRect(
        find.ancestor(
          of: find.text('Tài sản của bạn'),
          matching: find.byType(VitTradeSection),
        ),
      );

      expect(
        orderForm.top - hero.bottom,
        closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
      );
      expect(
        assetsSection.top - nextSection.bottom,
        closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
      );
    },
  );
}
