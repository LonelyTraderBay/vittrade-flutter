import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_account_footer_actions.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_discovery_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_hero_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_kyc_banner_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_legal_accordion_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_menu_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_product_hub_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_vip_card_panel.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet composition of Profile (SC-156) — same route, same
/// [profileSnapshotProvider] data and the same public Profile widgets as
/// [ProfilePage], but laid out as a persistent two-column dashboard instead
/// of one scrolling phone column: identity, KYC prompt and menu sections in
/// the primary column; VIP progress, Prediction/Arena summary and product
/// shortcuts framed as a sidebar in the secondary column. Does not touch
/// `profile_page.dart` or its `part` family — reached via
/// `createTabletAppRouter`/surface bootstrap. Fifth reference implementation for
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
class ProfileTabletPage extends ConsumerStatefulWidget {
  const ProfileTabletPage({super.key});

  @override
  ConsumerState<ProfileTabletPage> createState() => _ProfileTabletPageState();
}

class _ProfileTabletPageState extends ConsumerState<ProfileTabletPage> {
  bool _copiedReferral = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trang tài khoản: hồ sơ cá nhân, giới thiệu bạn bè và VIP',
      semanticIdentifier: 'SC-156',
      child: Column(
        children: [
          const VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Tài khoản',
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const SingleChildScrollView(
                child: VitSkeletonList(key: ProfileTabletKeys.loading),
              ),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  key: ProfileTabletKeys.error,
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(profileSnapshotProvider),
                ),
              ),
              data: _buildScreenState,
            ),
          ),
        ],
      ),
    );
  }

  // Mirrors `_profilePageChildren`'s switch on `snapshot.screenState`
  // (profile_home_menu_actions.dart) ahead of the dashboard build. Only
  // `offline` isn't a literal "instead of the dashboard" swap: the phone
  // branch renders the banner *and then* the full ready sections in the same
  // scroll, so here the banner becomes the first primary-column item above
  // the dashboard rather than replacing it — same precedent
  // `WalletTabletPage` uses for `WalletUnavailableBanner`.
  Widget _buildScreenState(ProfileSnapshot snapshot) {
    return switch (snapshot.screenState) {
      ProfileScreenState.loading => const SingleChildScrollView(
        child: VitSkeletonList(key: ProfileTabletKeys.loading, rows: 4),
      ),
      ProfileScreenState.error => SingleChildScrollView(
        child: VitErrorState(
          key: ProfileTabletKeys.error,
          title: 'Không tải được hồ sơ',
          message: 'Kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => context.go(AppRoutePaths.profile),
        ),
      ),
      ProfileScreenState.empty => const SingleChildScrollView(
        child: VitEmptyState(
          key: ProfileTabletKeys.empty,
          title: 'Chưa có dữ liệu tài khoản',
          message: 'Hồ sơ sẽ hiển thị sau khi đăng nhập và đồng bộ.',
          icon: Icons.account_circle_outlined,
        ),
      ),
      ProfileScreenState.offline => _buildDashboard(
        snapshot,
        showOfflineBanner: true,
      ),
      _ => _buildDashboard(snapshot, showOfflineBanner: false),
    };
  }

  // Two-column threshold and per-column width caps are owned by
  // [VitTwoColumnTabletDashboard] (`TabletDashboardWidths` defaults) —
  // shared with `HomeTabletPage`/`WalletTabletPage`/`MarketsTabletPage`/
  // `TradeTabletPage`, all of which confirmed the same values empirically.
  // Pass constructor overrides on the call below instead of editing the
  // shared widths if Profile's content ever needs a different number.

  Widget _buildDashboard(
    ProfileSnapshot snapshot, {
    required bool showOfflineBanner,
  }) {
    final primaryChildren = [
      if (showOfflineBanner)
        const VitOfflineBanner(
          key: ProfileTabletKeys.offline,
          message: 'Đang ngoại tuyến',
          detail: 'Hiển thị dữ liệu tài khoản đã lưu gần nhất.',
        ),
      ProfileHeroPanel(
        user: snapshot.user,
        copiedReferral: _copiedReferral,
        onEdit: () => context.go(AppRoutePaths.profileEdit),
        onCopyReferral: () {
          unawaited(
            Clipboard.setData(ClipboardData(text: snapshot.user.referralCode)),
          );
          setState(() => _copiedReferral = true);
        },
      ),
      if (snapshot.user.kycNeedsAction)
        ProfileKycBannerPanel(
          onVerify: () => context.go(AppRoutePaths.profileKyc),
        ),
      if (snapshot.sections.isEmpty)
        const VitEmptyState(
          title: 'Chưa có mục tài khoản',
          message: 'Các cài đặt profile sẽ hiển thị sau khi tải xong.',
          icon: Icons.account_circle_outlined,
        )
      else
        for (final section in snapshot.sections) ...[
          VitPageSection(
            label: section.label,
            accentColor: Color(section.accentHex),
            headerVariant: VitSectionHeaderVariant.accentBar,
            headerDensity: VitDensity.compact,
            innerGap: AppSpacing.pageRhythmCompactInnerGap,
            children: [
              if (section.id == 'legal')
                const ProfileLegalAccordionPanel()
              else
                ProfileMenuPanel(section: section),
            ],
          ),
        ],
      ProfileActivityButton(
        onTap: () => context.go(AppRoutePaths.profileActivity),
      ),
      ProfileLogoutButton(
        onTap: () async {
          final navContext = context;
          await ref.read(authSessionControllerProvider.notifier).logout();
          if (navContext.mounted) navContext.go(AppRoutePaths.authLogin);
        },
      ),
      Text(
        'VitTrade v2.4.1 • Tham gia từ ${snapshot.user.joinDate}',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    ];

    final secondaryChildren = [
      ProfileVipCardPanel(
        vip: snapshot.vip,
        onTap: () => context.go(AppRoutePaths.profileVip),
      ),
      VitPageSection(
        label: 'Dự đoán & Thách đấu',
        accentColor: AppColors.accent,
        headerVariant: VitSectionHeaderVariant.accentBar,
        headerDensity: VitDensity.compact,
        innerGap: AppSpacing.pageRhythmCompactInnerGap,
        customGap: AppSpacing.pageRhythmStandardInnerGap,
        children: [
          ProfilePredictionCard(
            prediction: snapshot.prediction,
            onTap: () => context.go(AppRoutePaths.marketsPredictionsPortfolio),
          ),
          ProfileArenaCard(
            arena: snapshot.arena,
            onTap: () => context.go(AppRoutePaths.arenaMy),
          ),
        ],
      ),
      VitPageSection(
        label: 'LỐI TẮT SẢN PHẨM',
        accentColor: AppColors.warn,
        headerVariant: VitSectionHeaderVariant.accentBar,
        headerDensity: VitDensity.compact,
        innerGap: AppSpacing.pageRhythmCompactInnerGap,
        children: [
          if (snapshot.productShortcuts.isEmpty)
            const VitEmptyState(
              title: 'Chưa có sản phẩm',
              message: 'Các shortcut sản phẩm sẽ hiển thị khi khả dụng.',
              icon: Icons.explore_outlined,
            )
          else
            ProfileProductHubPanel(shortcuts: snapshot.productShortcuts),
        ],
      ),
    ];

    return VitTwoColumnTabletDashboard(
      primaryChildren: primaryChildren,
      secondaryChildren: secondaryChildren,
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}
