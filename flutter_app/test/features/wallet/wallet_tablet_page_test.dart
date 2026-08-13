import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tablet/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/phone/wallet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/tablet/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tablet/wallet_page_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tablet/wallet_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletWallet(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
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
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SC-135 renders WalletTabletPage, not WalletPage, at tablet width',
    (tester) async {
      await pumpTabletWallet(tester);

      expect(find.byType(WalletTabletPage), findsOneWidget);
      expect(find.byType(WalletPage), findsNothing);
    },
  );

  testWidgets(
    'SC-135 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletWallet(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets('SC-135 tablet dashboard renders both dashboard columns', (
    tester,
  ) async {
    await pumpTabletWallet(tester);

    // Primary column's asset section header. "Ví" also labels the
    // persistent nav rail's Wallet destination, so this scopes to the
    // section-header text style rather than a bare text match.
    expect(
      find.descendant(
        of: find.byType(VitSectionHeader),
        matching: find.text('Tài sản'),
      ),
      findsOneWidget,
    );
    // Secondary column.
    expect(find.text('Công cụ ví'), findsOneWidget);
    expect(find.text('Mua định kỳ'), findsOneWidget);
  });

  testWidgets('SC-135 tablet rail navigates to Markets', (tester) async {
    await pumpTabletWallet(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pumpAndSettle();

    // Markets is also tablet-adaptive as of this batch — at this width it
    // resolves to its own single-column tablet fallback, not the raw phone
    // page (see markets_tablet_page_test.dart for its own dispatch tests).
    expect(find.byType(MarketsTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-135 wide tablet renders the true two-column dashboard without '
    'overflow, secondary column framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above WalletTabletPage's own two-column threshold
      // (900) — the width-capped Align+ConstrainedBox+VitCard layout only
      // engages at/above this width.
      await pumpTabletWallet(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(VitSectionHeader),
          matching: find.text('Tài sản'),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.text('Công cụ ví'),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'SC-135 wide tablet switches to the Phân bổ allocation tab without '
    'overflow',
    (tester) async {
      // WalletAllocationCard (fixed-size donut + Expanded legend row) is
      // the layout-riskiest widget in the primary column at this width —
      // verify it actually renders clean, not just by code inspection.
      await pumpTabletWallet(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(WalletTabletKeys.tab('chart')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(WalletAllocationCard), findsOneWidget);
    },
  );

  testWidgets('SC-135 wide tablet keeps compact section and inner rhythm', (
    tester,
  ) async {
    await pumpTabletWallet(tester, size: const Size(1180, 820));

    final toolsSectionFinder = find.ancestor(
      of: find.text('Công cụ ví'),
      matching: find.byType(VitPageSection),
    );
    final toolsSection = tester.getRect(toolsSectionFinder);
    final dcaSectionFinder = find.ancestor(
      of: find.text('Mua định kỳ'),
      matching: find.byType(VitPageSection),
    );
    final dcaSection = tester.getRect(dcaSectionFinder);
    final compactHeaderPadding = find.byWidgetPredicate(
      (widget) =>
          widget is Padding &&
          widget.padding ==
              const EdgeInsetsDirectional.only(
                bottom: AppSpacing.pageRhythmCompactInnerGap,
              ),
    );

    expect(
      dcaSection.top - toolsSection.bottom,
      closeTo(AppSpacing.pageRhythmCompactSectionGap, 0.01),
    );
    expect(
      find.descendant(of: dcaSectionFinder, matching: compactHeaderPadding),
      findsOneWidget,
    );
    expect(
      find.descendant(of: toolsSectionFinder, matching: compactHeaderPadding),
      findsOneWidget,
    );
  });
}
