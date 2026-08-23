import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
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
    KeyValueStore? store,
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
          if (store != null) keyValueStoreProvider.overrideWithValue(store),
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
    'SC-156 master-detail: pane headers hide the back action while the menu '
    'stays beside them, and show it in the narrow fallback',
    (tester) async {
      // Wide: the shell keeps the framed master menu beside the pane, so a
      // pane back arrow would duplicate it — even though the pane's own
      // column (720dp on a 1280dp tablet) sits below twoColumnMinWidth. The
      // decision belongs to the SHELL's width (screen minus the nav rail),
      // not the pane's (emulator verification 2026-08-23).
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
      expect(find.byType(VitHeaderActionButton), findsNothing);

      // Narrow fallback: the menu is stacked away, so the pane header must
      // carry its own back action to return to the overview.
      await pumpTabletProfile(tester);
      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsNothing);
      expect(find.byType(VitHeaderActionButton), findsOneWidget);
    },
  );

  testWidgets(
    'SC-156 master-detail: a cross-module menu row is pushed so back can '
    'return to the open pane',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('kyc')));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);

      // Cross-module rows leave the shell for a full page — they must be
      // pushed (not replace) so the shell and its open pane stay on the
      // stack and the system back returns to the pane.
      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.menu('referral-home')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.menu('referral-home')));
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.kycPane), findsOneWidget);
    },
  );

  testWidgets(
    'SC-156 master-detail: the Prediction summary card is pushed so back can '
    'return to the overview',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      // Cross-module discovery cards leave the shell for a full page — they
      // must be pushed (not go) so the shell stays on the stack and the
      // system back returns to Tài khoản.
      await tester.ensureVisible(find.byKey(ProfileTabletKeys.predictionCard));
      await tester.tap(find.byKey(ProfileTabletKeys.predictionCard));
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
    },
  );

  testWidgets(
    'SC-158 security pane: the activity row switches panes in place and back '
    'lands on the overview',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('security-center')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.securityItem('activity')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.securityItem('activity')));
      await tester.pumpAndSettle();

      // In-shell switch: the activity pane renders inside the shell (menu
      // stays framed) and replaces the security pane…
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.activityPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.securityPane), findsNothing);

      // …so a single back lands on the overview, not a dead-end stack.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.activityPane), findsNothing);
      expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
    },
  );

  testWidgets(
    'SC-156 product shortcuts are pushed so back can return to the shell',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.productShortcut('wallet')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.productShortcut('wallet')));
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.accountHero), findsOneWidget);
    },
  );

  testWidgets(
    'SC-157 edit pane edits fields, saves, and returns to the overview',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.editProfile));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: avatar editor, name and
      // phone editable, email locked read-only with its note.
      expect(find.byKey(ProfileTabletKeys.editPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.editCamera), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.editNameField), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.editPhoneField), findsOneWidget);
      expect(find.text('Email không thể thay đổi'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Saving returns to the overview pane inside the shell.
      await tester.enterText(
        find.byKey(ProfileTabletKeys.editNameField),
        'Nguyễn Văn B',
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(ProfileTabletKeys.editSave));
      await tester.tap(find.byKey(ProfileTabletKeys.editSave));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.editPane), findsNothing);
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

  testWidgets(
    'SC-158 security pane renders the checklist and expands the device list',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('security-center')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: score 3/4 with the
      // checklist rows and the anti-phishing card.
      expect(find.byKey(ProfileTabletKeys.securityPaneScore), findsOneWidget);
      expect(find.text('Cao (3/4)'), findsOneWidget);
      expect(
        find.byKey(ProfileTabletKeys.securityItem('two-factor')),
        findsOneWidget,
      );
      expect(
        find.byKey(ProfileTabletKeys.securityAntiPhishingField),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      // Tapping the devices row expands the logged-in device list in place.
      await tester.tap(find.byKey(ProfileTabletKeys.securityItem('devices')));
      await tester.pumpAndSettle();
      expect(find.text('THIẾT BỊ ĐĂNG NHẬP'), findsOneWidget);
    },
  );

  testWidgets(
    'SC-164 VIP pane renders the tier hero, tabs and comparison table',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('vip')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: current tier VIP 1 of the
      // Standard→VIP 4 ladder, segment tabs and the comparison table.
      expect(find.byKey(ProfileTabletKeys.vipPane), findsOneWidget);
      expect(find.text('VIP 1'), findsWidgets);
      expect(find.byKey(ProfileTabletKeys.vipTier(4)), findsOneWidget);
      expect(find.text('So sánh các cấp VIP'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Switching to the benefits tab shows per-tier cards and, since the
      // next tier exists, the upgrade CTA.
      await tester.tap(find.byKey(ProfileTabletKeys.vipTab('benefits')));
      await tester.pumpAndSettle();
      expect(find.text('Nâng cấp lên VIP 2'), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.vipTradeCta), findsOneWidget);
    },
  );

  testWidgets(
    'SC-164 VIP pane keeps exactly one rhythm section gap between the hero '
    'and the tabs (no stacked separator)',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.tap(find.byKey(ProfileTabletKeys.menu('vip')));
      await tester.pumpAndSettle();

      // ProfilePaneScaffold's VitPageContent(rhythm: form) owns the vertical
      // rhythm between top-level blocks, so hero→tabs must measure exactly
      // one pageRhythmFormSectionGap. A manual SizedBox separator between
      // the pane's children stacks onto the rhythm gaps (16+8+16=40dp) and
      // breaks the pane's rhythm — the bug caught by the 2026-08-23
      // emulator acceptance screenshot.
      final pane = find.byKey(ProfileTabletKeys.vipPane);
      final hero = find.descendant(
        of: pane,
        matching: find.byType(VitModuleHeroCard),
      );
      final tabs = find.descendant(of: pane, matching: find.byType(VitTabBar));
      expect(hero, findsOneWidget);
      expect(tabs, findsOneWidget);

      final heroBottom = tester.getBottomLeft(hero).dy;
      final tabsTop = tester.getTopLeft(tabs).dy;
      expect(
        tabsTop - heroBottom,
        closeTo(AppSpacing.pageRhythmFormSectionGap, 0.1),
      );
    },
  );

  testWidgets(
    'SC-160 settings pane renders the real settings content beside the menu '
    'and persists toggles',
    (tester) async {
      final store = InMemoryKeyValueStore();
      await pumpTabletProfile(
        tester,
        size: const Size(1180, 820),
        store: store,
      );

      await tester.tap(find.byKey(ProfileTabletKeys.menu('settings')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: 4 currencies, 2 languages,
      // 3 trade-security rows (1 read-only), 6 notification toggles and the
      // app-info card.
      expect(find.byKey(ProfileTabletKeys.settingsPane), findsOneWidget);
      expect(
        find.byKey(ProfileTabletKeys.settingsCurrency('VND')),
        findsOneWidget,
      );
      expect(
        find.byKey(ProfileTabletKeys.settingsLanguage('en')),
        findsOneWidget,
      );
      expect(
        find.byKey(ProfileTabletKeys.settingsToggle('biometric')),
        findsOneWidget,
      );
      expect(
        find.byKey(ProfileTabletKeys.settingsToggle('news')),
        findsOneWidget,
      );
      expect(find.byKey(ProfileTabletKeys.settingsAppInfo), findsOneWidget);
      expect(find.text('THÔNG TIN ỨNG DỤNG'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Switching currency persists through the KeyValueStore (GĐ4-F1),
      // mirroring the phone page's behavior.
      await tester.tap(find.byKey(ProfileTabletKeys.settingsCurrency('VND')));
      await tester.pumpAndSettle();
      expect(store.getString(KeyValueStoreKeys.settingsCurrency), 'VND');

      // Toggling a notification row flips its state and persists.
      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.settingsToggle('news')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.settingsToggle('news')));
      await tester.pumpAndSettle();
      expect(
        store.getBool('${KeyValueStoreKeys.settingsTogglePrefix}news'),
        true,
      );
    },
  );

  testWidgets(
    'SC-161 activity pane renders the log entries beside the menu and '
    'filters them',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.menu('activity')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.menu('activity')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: 7 entries with 1 suspicious
      // login from Singapore, the warning banner leads the pane.
      expect(find.byKey(ProfileTabletKeys.activityPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.activityWarning), findsOneWidget);
      expect(find.text('Phát hiện 1 hoạt động đáng ngờ'), findsOneWidget);
      expect(
        find.byKey(ProfileTabletKeys.activityLog('act001')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      // The login filter keeps only login/logout entries (mock has 3) and
      // drops the security ones (password change, 2FA, KYC).
      await tester.tap(find.byKey(ProfileTabletKeys.activityFilter('login')));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.activityLog('act003')), findsNothing);
      expect(find.byKey(ProfileTabletKeys.activityLog('act005')), findsNothing);
      expect(
        find.byKey(ProfileTabletKeys.activityLog('act001')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'SC-165 devices pane renders the session list and confirms a device '
    'logout',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.ensureVisible(find.byKey(ProfileTabletKeys.menu('devices')));
      await tester.tap(find.byKey(ProfileTabletKeys.menu('devices')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: 4 devices (1 current + 3
      // others), trust summary metrics leading the pane.
      expect(find.byKey(ProfileTabletKeys.devicesPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.devicesSummary), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.devicesLogoutAll), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Logging a device out is high-risk: the confirm dialog must appear
      // and cancelling keeps the device listed.
      final otherCard = find.byKey(ProfileTabletKeys.deviceLogout('dev002'));
      await tester.ensureVisible(otherCard);
      await tester.tap(otherCard);
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.devicesLogoutCancel), findsOneWidget);
      await tester.tap(find.byKey(ProfileTabletKeys.devicesLogoutCancel));
      await tester.pumpAndSettle();
      expect(
        find.byKey(ProfileTabletKeys.deviceCard('dev002')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'SC-163 API pane renders the key list, reveals a secret, and pushes the '
    'create pane from the header action',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.ensureVisible(find.byKey(ProfileTabletKeys.menu('api')));
      await tester.tap(find.byKey(ProfileTabletKeys.menu('api')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: 3 keys (2 active), masked
      // until revealed, with the create action on the pane header.
      expect(find.byKey(ProfileTabletKeys.apiPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.apiCreate), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.apiKeyCard('key1')), findsOneWidget);
      expect(find.textContaining('••••'), findsWidgets);
      expect(tester.takeException(), isNull);

      // Revealing a secret unmasks it in place.
      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.apiKeyReveal('key1')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.apiKeyReveal('key1')));
      await tester.pumpAndSettle();
      expect(find.textContaining('sk_live_VI_DU_KHONG_THAT'), findsOneWidget);

      // The header "+" action opens the create pane inside the shell.
      await tester.tap(find.byKey(ProfileTabletKeys.apiCreate));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.apiCreatePane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
    },
  );

  testWidgets(
    'SC-162 create-key pane walks form → confirm → result and returns to '
    'the API pane',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.ensureVisible(find.byKey(ProfileTabletKeys.menu('api')));
      await tester.tap(find.byKey(ProfileTabletKeys.menu('api')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ProfileTabletKeys.apiCreate));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.apiCreatePane), findsOneWidget);

      // The continue CTA stays disabled until the name reaches 3 chars.
      expect(
        tester
            .widget<VitCtaButton>(
              find.byKey(ProfileTabletKeys.apiCreateContinue),
            )
            .onPressed,
        isNull,
      );
      await tester.enterText(
        find.byKey(ProfileTabletKeys.apiCreateNameField),
        'Bot nghiệm thu',
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<VitCtaButton>(
              find.byKey(ProfileTabletKeys.apiCreateContinue),
            )
            .onPressed,
        isNotNull,
      );

      // Form → confirm carries the name; confirm → result reveals the
      // one-time keys. (The CTA sits below the fold on a 820dp-tall pane.)
      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.apiCreateContinue),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.apiCreateContinue));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận tạo API Key'), findsWidgets);
      expect(find.textContaining('Bot nghiệm thu'), findsOneWidget);
      await tester.tap(find.byKey(ProfileTabletKeys.apiCreateConfirm));
      await tester.pumpAndSettle();
      expect(find.textContaining('sk_live_demo_only_once'), findsOneWidget);

      // The done CTA returns to the API pane inside the shell.
      await tester.tap(find.byKey(ProfileTabletKeys.apiCreateDone));
      await tester.pumpAndSettle();
      expect(find.byKey(ProfileTabletKeys.apiPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.apiCreatePane), findsNothing);
      expect(find.byKey(ProfileTabletKeys.masterMenu), findsOneWidget);
    },
  );

  testWidgets(
    'SC-166 sub-accounts pane renders the totals and expands a card',
    (tester) async {
      await pumpTabletProfile(tester, size: const Size(1180, 820));

      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.menu('sub-accounts')),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.menu('sub-accounts')));
      await tester.pumpAndSettle();

      // Same production mock as the phone page: hero totals with the
      // balance-hide toggle, create button, and the account cards list.
      expect(find.byKey(ProfileTabletKeys.subAccountsPane), findsOneWidget);
      expect(find.byKey(ProfileTabletKeys.subAccountsSummary), findsOneWidget);
      expect(
        find.byKey(ProfileTabletKeys.subAccountsBalanceToggle),
        findsOneWidget,
      );
      expect(
        find.byKey(ProfileTabletKeys.subAccountsCreateButton),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      // Expanding an account card reveals its 30d metrics and permissions.
      final card = find.byKey(ProfileTabletKeys.subAccountsExpand('sub001'));
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.text('Volume 30d'), findsOneWidget);
      expect(find.text('Quyền hạn:'), findsOneWidget);

      // Hiding balances masks every money figure in the pane.
      await tester.ensureVisible(
        find.byKey(ProfileTabletKeys.subAccountsBalanceToggle),
      );
      await tester.tap(find.byKey(ProfileTabletKeys.subAccountsBalanceToggle));
      await tester.pumpAndSettle();
      expect(find.text('••••••'), findsOneWidget);
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
