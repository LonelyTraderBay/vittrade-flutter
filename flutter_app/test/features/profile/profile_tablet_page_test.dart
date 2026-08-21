import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/providers/profile_repository_provider.dart';
import 'package:vit_trade_flutter/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_account_hero.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_discovery_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_legal_accordion_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_menu_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_product_hub_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class _CountingProfileRepository implements ProfileRepository {
  _CountingProfileRepository(this._inner);

  final ProfileRepository _inner;
  int profileFetchCount = 0;
  int securityFetchCount = 0;

  @override
  Future<ProfileSnapshot> getProfile() {
    profileFetchCount++;
    return _inner.getProfile();
  }

  @override
  Future<ProfileSecuritySnapshot> getSecurity() {
    securityFetchCount++;
    return _inner.getSecurity();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<void> pumpTabletProfile(
    WidgetTester tester, {
    Size size = const Size(820, 1180),
    ProfileRepository? repository,
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
            profileRepositoryProvider.overrideWithValue(repository),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: AppRoutePaths.profile,
          ),
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

  testWidgets('SC-156 tablet renders the master menu beside the overview', (
    tester,
  ) async {
    await pumpTabletProfile(tester);

    // Master column: grouped menu sections under a compact identity line.
    expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
    expect(find.byType(ProfileMenuPanel), findsWidgets);
    // Detail pane (overview): identity hero, security score, Prediction/
    // Arena summary and product shortcuts in one scrolling column.
    expect(find.byType(ProfileAccountHero), findsOneWidget);
    expect(find.text('Điểm bảo mật'), findsOneWidget);
    expect(find.text('Dự đoán & Thách đấu'), findsOneWidget);
    expect(find.byType(ProfileProductHubPanel), findsOneWidget);
  });

  testWidgets('SC-156 tablet identity hero carries the identity facts', (
    tester,
  ) async {
    await pumpTabletProfile(tester);

    expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
    // The hero scrolls with the primary column — it must NOT be locked as
    // fixed chrome above the dashboard (it would eat a third of an 800dp
    // landscape screen; user feedback 2026-08-22).
    expect(
      find.ancestor(
        of: find.byKey(ProfileTabletKeys.accountHero),
        matching: find.byType(SingleChildScrollView),
      ),
      findsWidgets,
    );
    expect(find.text('UID'), findsOneWidget);
    expect(find.text('Mã giới thiệu'), findsOneWidget);
    // Tier pills: hero pill + the master menu's compact identity line both
    // carry them (mock: 'VIP 1', 'Cấp 1').
    expect(find.text('VIP 1'), findsWidgets);
    expect(find.text('KYC Cấp 1'), findsWidgets);
    // VIP runway across the hero's foot.
    expect(find.text('Tiến độ VIP'), findsOneWidget);
    // The masked email never renders the raw address (sensitive-data rule);
    // the mask itself is visible instead.
    expect(find.textContaining('nguyenvana@email.com'), findsNothing);
    expect(find.textContaining('@email.com'), findsOneWidget);
  });

  testWidgets('SC-156 tablet sidebar leads with the security score block', (
    tester,
  ) async {
    // Mirrors the phone Security page's score card semantics against the
    // production mock: score 3 of 4, label 'Cao', green accent.
    await pumpTabletProfile(tester);

    expect(find.byKey(ProfileTabletKeys.securityScore), findsOneWidget);
    expect(find.text('Cao (3/4)'), findsOneWidget);
    expect(find.text('Nâng cấp bảo mật'), findsOneWidget);
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
    'SC-156 wide tablet renders the master-detail split without overflow, '
    'master menu framed as a distinct panel',
    (tester) async {
      // Landscape tablet, above the master-detail threshold (900) — the
      // width-capped pair of framed menu (400) + detail pane renders
      // side-by-side only at/above this width.
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileAccountHero), findsOneWidget);
      // The master menu column sits inside its framed VitCard (the R7
      // sidebar idiom), while the detail pane's overview content stays
      // flush against the page background.
      expect(
        find.ancestor(
          of: find.byType(ProfileMenuPanel).first,
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'SC-156 master-detail: tapping a menu item renders the pane beside the '
    'menu, not a full-page replacement',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();

      // The detail pane now carries the real KYC pane content…
      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);
      // …while the master menu stays visible beside it.
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
      expect(find.byType(ProfileMenuPanel), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'SC-156 master-detail: system back returns from a pane to the overview',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // Back pops within the shell branch: the overview pane returns and
      // the menu never left.
      expect(find.byKey(ProfileTabletKeys.kycPane), findsNothing);
      expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
    },
  );

  testWidgets(
    'SC-156 master-detail narrow fallback: a pane takes the full width and '
    'its header back returns to the overview',
    (tester) async {
      // Portrait tablet below the master-detail threshold: the hub stacks
      // the menu above the overview; a sub-route pane goes full-width with
      // its own back header (the menu column would leave no usable height).
      await pumpTabletProfile(tester);

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);

      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
    },
  );

  testWidgets(
    'SC-156 master-detail keeps the legal accordion in the framed master '
    'menu, not in the overview pane',
    (tester) async {
      // The GOM legal/compliance accordion stays with the rest of the
      // account menu inside the framed master column, while the detail
      // pane's overview content renders flush — the frame-vs-flush split
      // is the R7 sidebar idiom carried over to the master-detail shell.
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      expect(find.byType(ProfileLegalAccordionPanel), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(ProfileLegalAccordionPanel),
          matching: find.byType(VitCard),
        ),
        findsWidgets,
      );
      expect(
        find.ancestor(
          of: find.byType(ProfileProductHubPanel),
          matching: find.byType(VitCard),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'SC-156 overview pane keeps compact rhythm without stacked header gaps',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      final predictionTitle = tester.getRect(find.text('Dự đoán & Thách đấu'));
      final prediction = tester.getRect(find.byType(ProfilePredictionCard));
      final arena = tester.getRect(find.byType(ProfileArenaCard));
      final productTitle = tester.getRect(find.text('LỐI TẮT SẢN PHẨM'));
      final productHub = tester.getRect(find.byType(ProfileProductHubPanel));

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

  testWidgets(
    'SC-159 KYC pane renders the real verification content beside the menu',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: fully verified at level 2
      // of the 3-level ladder, with the AES-256 privacy note.
      expect(find.byKey(ProfileTabletKeys.kycStatusCard), findsOneWidget);
      expect(find.text('KYC Cấp 2 — Đã xác minh'), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.kycLevel(0)), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.kycLevel(2)), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.kycPrivacyCard), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Expanding a level reveals its limits; every level is already done,
      // so no start CTA renders (only the level right above the current
      // one would be startable).
      await tester.tap(find.byKey(ProfileTabletKeys.kycLevel(1)));
      await tester.pumpAndSettle();
      expect(find.text('Giới hạn giao dịch:'), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.kycStart(1)), findsNothing);
    },
  );

  testWidgets('SC-156 tablet pull-to-refresh re-fetches the profile', (
    tester,
  ) async {
    final repository = _CountingProfileRepository(
      const MockProfileRepository(loadDelay: Duration.zero),
    );
    await pumpTabletProfile(
      tester,
      size: const Size(1180, 820),
      repository: repository,
    );

    expect(repository.profileFetchCount, 1);
    expect(repository.securityFetchCount, 1);

    // Fling inside the overview pane's own scrollable — the master menu
    // column has its own scroll and never refreshes.
    final overviewScroll = find
        .ancestor(
          of: find.byKey(ProfileTabletKeys.accountHero),
          matching: find.byType(SingleChildScrollView),
        )
        .first;
    await tester.fling(overviewScroll, const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repository.profileFetchCount, 2);
    // The secondary security snapshot refreshes with the page, not just the
    // profile snapshot.
    expect(repository.securityFetchCount, 2);
    expect(find.byType(ProfileTabletPage), findsOneWidget);
    // The refreshed dashboard still carries the full tablet composition.
    expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
    expect(find.byType(ProfileMenuPanel), findsWidgets);
  });
}
