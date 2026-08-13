import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/phone/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/tablet/profile_tablet_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_discovery_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_hero_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_legal_accordion_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_menu_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_product_hub_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_vip_card_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/tablet/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpTabletProfile(
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
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.profile),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SC-156 renders ProfileTabletPage, not ProfilePage, at tablet width',
    (tester) async {
      await pumpTabletProfile(tester);

      expect(find.byType(ProfileTabletPage), findsOneWidget);
      expect(find.byType(ProfilePage), findsNothing);
    },
  );

  testWidgets(
    'SC-156 tablet shell shows the navigation rail, not the bottom nav',
    (tester) async {
      await pumpTabletProfile(tester);

      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
    },
  );

  testWidgets('SC-156 tablet dashboard renders both dashboard columns', (
    tester,
  ) async {
    await pumpTabletProfile(tester);

    // Primary column: identity hero + grouped menu sections.
    expect(find.byType(ProfileHeroPanel), findsOneWidget);
    expect(find.byType(ProfileMenuPanel), findsWidgets);
    // Secondary column: VIP progress card + Prediction/Arena summary
    // sidebar section.
    expect(find.byType(ProfileVipCardPanel), findsOneWidget);
    expect(find.text('Dự đoán & Thách đấu'), findsOneWidget);
  });

  testWidgets(
    'SC-156 tablet dashboard shows the KYC upgrade banner in the primary '
    'column',
    (tester) async {
      // Ports ProfilePage's own `if (snapshot.user.kycNeedsAction)` gate —
      // MockProfileRepository's user has kycStatus "Chưa hoàn tất", which
      // never contains "Đã xác minh", so kycNeedsAction is deterministically
      // true against the production mock.
      await pumpTabletProfile(tester);

      expect(find.byKey(ProfileTabletKeys.kycBanner), findsOneWidget);
    },
  );

  testWidgets('SC-156 tablet rail navigates to Wallet', (tester) async {
    await pumpTabletProfile(tester);

    await tester.tap(find.byKey(const Key('vit_navigation_rail_wallet')));
    await tester.pumpAndSettle();

    expect(find.byType(WalletTabletPage), findsOneWidget);
  });

  testWidgets(
    'SC-156 wide tablet renders the true two-column dashboard without '
    'overflow, secondary column framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above ProfileTabletPage's own two-column threshold
      // (900) — the width-capped Align+ConstrainedBox+VitCard layout only
      // engages at/above this width.
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileHeroPanel), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Dự đoán & Thách đấu'),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'SC-156 wide tablet keeps the legal accordion in the primary column, '
    'not inside the secondary column card',
    (tester) async {
      // Direct evidence for the deliberate column split documented on
      // ProfileTabletPage: the 39-item GOM legal/compliance accordion stays
      // with the rest of the account menu in the primary column instead of
      // drifting into the secondary column's VitCard(inner) sidebar wrapper.
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      expect(find.byType(ProfileLegalAccordionPanel), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(ProfileLegalAccordionPanel),
          matching: find.byType(VitCard),
        ),
        findsNothing,
      );
      // Differentiator sanity check: secondary column content does sit
      // inside the VitCard(inner) wrapper, so the assertion above is
      // actually distinguishing columns, not vacuously true.
      expect(
        find.ancestor(
          of: find.byType(ProfileVipCardPanel),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'SC-156 wide tablet keeps compact rhythm without stacked header gaps',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      final accountTitle = tester.getRect(find.text('TÀI KHOẢN'));
      final menu = tester.getRect(find.byType(ProfileMenuPanel).first);
      final predictionTitle = tester.getRect(find.text('Dự đoán & Thách đấu'));
      final prediction = tester.getRect(find.byType(ProfilePredictionCard));
      final arena = tester.getRect(find.byType(ProfileArenaCard));
      final productTitle = tester.getRect(find.text('LỐI TẮT SẢN PHẨM'));
      final productHub = tester.getRect(find.byType(ProfileProductHubPanel));

      expect(
        menu.top - accountTitle.bottom,
        closeTo(AppSpacing.pageRhythmCompactInnerGap, 0.01),
      );
      expect(
        prediction.top - predictionTitle.bottom,
        closeTo(AppSpacing.pageRhythmCompactInnerGap, 0.01),
      );
      expect(
        arena.top - prediction.bottom,
        closeTo(AppSpacing.pageRhythmStandardInnerGap, 0.01),
      );
      expect(
        productHub.top - productTitle.bottom,
        closeTo(AppSpacing.pageRhythmCompactInnerGap, 0.01),
      );
    },
  );
}
