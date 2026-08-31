import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_account_hero.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_discovery_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_product_hub_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_security_summary.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_status_content.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Overview pane of the Profile tablet master-detail shell (SC-156) — the
/// `/profile` route's detail content: the identity hero, the security-score
/// status block, Prediction/Arena summaries and product shortcuts in one
/// scrolling column. The account menu lives in the shell's master column
/// (`ProfileTabletMasterShell`); sub-routes render their panes in place of
/// this one. Same route contract and same [profileSnapshotProvider] data as
/// the phone [ProfilePage] — reached via `createTabletAppRouter`/surface
/// bootstrap. Reference implementation for the master-detail pattern in
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

    return snapshotAsync.when(
      loading: () => ProfileLoadingContent(onRefresh: _refreshProfile),
      error: (error, stackTrace) => ProfilePaneScaffold(
        onRefresh: _refreshProfile,
        rhythm: VitPageRhythm.standard,
        children: const [
          VitErrorState(
            key: ProfileTabletKeys.error,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
          ),
        ],
      ),
      data: _buildScreenState,
    );
  }

  Future<void> _refreshProfile() async {
    ref.invalidate(profileSnapshotProvider);
    ref.invalidate(profileSecuritySnapshotProvider);
    await ref.read(profileSnapshotProvider.future);
    await ref.read(profileSecuritySnapshotProvider.future);
  }

  // Mirrors `_profilePageChildren`'s switch on `snapshot.screenState`
  // (profile_home_menu_actions.dart) ahead of the overview build. Only
  // `offline` isn't a literal "instead of the overview" swap: the phone
  // branch renders the banner *and then* the full ready sections in the same
  // scroll, so here the banner becomes the first overview item.
  Widget _buildScreenState(ProfileSnapshot snapshot) {
    return switch (snapshot.screenState) {
      ProfileScreenState.loading => ProfileLoadingContent(
        onRefresh: _refreshProfile,
      ),
      ProfileScreenState.error => ProfilePaneScaffold(
        rhythm: VitPageRhythm.standard,
        children: [
          VitErrorState(
            key: ProfileTabletKeys.error,
            title: 'Không tải được hồ sơ',
            message: 'Kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refreshProfile,
          ),
        ],
      ),
      ProfileScreenState.empty => const ProfilePaneScaffold(
        rhythm: VitPageRhythm.standard,
        children: [
          VitEmptyState(
            key: ProfileTabletKeys.empty,
            title: 'Chưa có dữ liệu tài khoản',
            message: 'Hồ sơ sẽ hiển thị sau khi đăng nhập và đồng bộ.',
            icon: Icons.account_circle_outlined,
          ),
        ],
      ),
      ProfileScreenState.offline => _buildOverview(
        snapshot,
        showOfflineBanner: true,
      ),
      _ => _buildOverview(snapshot, showOfflineBanner: false),
    };
  }

  Widget _buildOverview(
    ProfileSnapshot snapshot, {
    required bool showOfflineBanner,
  }) {
    return ProfilePaneScaffold(
      onRefresh: _refreshProfile,
      rhythm: VitPageRhythm.standard,
      children: [
        if (showOfflineBanner)
          const VitOfflineBanner(
            key: ProfileTabletKeys.offline,
            message: 'Đang ngoại tuyến',
            detail: 'Hiển thị dữ liệu tài khoản đã lưu gần nhất.',
          ),
        ProfileAccountHero(
          snapshot: snapshot,
          copiedReferral: _copiedReferral,
          onEdit: () =>
              openProfileDetailRoute(context, AppRoutePaths.profileEdit),
          onCopyReferral: () {
            unawaited(
              Clipboard.setData(
                ClipboardData(text: snapshot.user.referralCode),
              ),
            );
            setState(() => _copiedReferral = true);
          },
          onVerifyKyc: () =>
              openProfileDetailRoute(context, AppRoutePaths.profileKyc),
          onVip: () =>
              openProfileDetailRoute(context, AppRoutePaths.profileVip),
        ),
        ..._securityBlock(),
        VitPageSection(
          label: 'Dự đoán & Thách đấu',
          accentColor: AppColors.accent,
          headerVariant: VitSectionHeaderVariant.accentBar,
          headerDensity: VitDensity.compact,
          innerGap: AppSpacing.pageRhythmCompactInnerGap,
          customGap: AppSpacing.x4,
          children: [
            ProfilePredictionCard(
              prediction: snapshot.prediction,
              onTap: () =>
                  context.push(AppRoutePaths.marketsPredictionsPortfolio),
            ),
            ProfileArenaCard(
              arena: snapshot.arena,
              onTap: () => context.push(AppRoutePaths.arenaMy),
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
      ],
    );
  }

  /// Security-score status block on the overview. The pane renders from
  /// `profileSnapshotProvider` — the security snapshot is a secondary,
  /// additive watch: while it loads its skeleton holds the block's slot,
  /// and on error the block is simply omitted (the rest of the overview
  /// stays fully usable) rather than failing the pane.
  List<Widget> _securityBlock() {
    return ref
        .watch(profileSecuritySnapshotProvider)
        .when<List<Widget>>(
          loading: () => const [ProfileSecuritySummarySkeleton()],
          error: (error, stackTrace) => const [],
          data: (security) => [
            ProfileSecuritySummary(
              snapshot: security,
              onUpgrade: () => openProfileDetailRoute(
                context,
                AppRoutePaths.settingsSecurity,
              ),
            ),
          ],
        );
  }
}
