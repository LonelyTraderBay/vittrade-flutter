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
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/common/profile_icon_registry.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/profile_legal_catalog.dart';

part 'profile_home_hero.dart';
part 'profile_home_vip_prediction.dart';
part 'profile_home_arena_stats.dart';
part 'profile_home_menu_actions.dart';
part 'profile_home_legal_accordion.dart';

const _profileBackground = AppColors.bg;
const _profilePanel2 = AppColors.surface2;
const _profileBorder = AppColors.cardBorder;
const _profileGreen = AppColors.buy;
const _profileAmber = AppColors.warn;
const _profilePurple = AppColors.accent;
const _profileRed = AppColors.sell;
const _profileMuted = AppColors.text3;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc156_profile_content');
  static const loadingKey = Key('sc156_profile_loading');
  static const errorKey = Key('sc156_profile_error');
  static const offlineKey = Key('sc156_profile_offline');
  static const emptyKey = Key('sc156_profile_empty');
  static const copyReferralKey = Key('sc156_profile_copy_referral');
  static const editProfileKey = Key('sc156_profile_edit');
  static const logoutKey = Key('sc156_profile_logout');
  static const predictionCardKey = Key('sc156_profile_prediction_card');
  static const arenaCardKey = Key('sc156_profile_arena_card');
  static const productHubKey = Key('sc156_profile_product_hub');
  static const kycBannerKey = Key('sc156_profile_kyc_banner');
  static const legalScaffoldKey = Key('sc156_profile_legal_scaffold');
  static const legalSearchKey = Key('sc156_profile_legal_search');
  static Key productShortcutKey(String id) => Key('sc156_profile_product_$id');
  static Key menuKey(String id) => Key('sc156_profile_menu_$id');
  static Key legalGroupKey(String id) => Key('sc156_profile_legal_group_$id');
  static Key legalItemKey(String id) => Key('sc156_profile_legal_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _copiedReferral = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    return VitAutoHidePageScaffold(
      semanticLabel: 'Trang tài khoản: hồ sơ cá nhân, giới thiệu bạn bè và VIP',
      semanticIdentifier: 'SC-156',
      background: _profileBackground,
      header: const VitTopChrome(
        type: VitTopChromeType.rootModule,
        title: 'T\u00E0i kho\u1EA3n',
      ),
      body: SingleChildScrollView(
        key: ProfilePage.contentKey,
        padding: ProfileSpacingTokens.profileScrollPadding(bottomInset),
        physics: const ClampingScrollPhysics(),
        child: VitPageContent(
          rhythm: VitPageRhythm.compact,
          padding: VitContentPadding.none,
          density: VitDensity.compact,
          fullBleed: true,
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList(key: ProfilePage.loadingKey)],
            error: (error, stackTrace) => [
              VitErrorState(
                key: ProfilePage.errorKey,
                title: 'Không tải được dữ liệu',
                message: 'Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(profileSnapshotProvider),
              ),
            ],
            data: (snapshot) => _profilePageChildren(
              context: context,
              snapshot: snapshot,
              copiedReferral: _copiedReferral,
              onEdit: () => context.go(AppRoutePaths.profileEdit),
              onCopyReferral: () {
                unawaited(
                  Clipboard.setData(
                    ClipboardData(text: snapshot.user.referralCode),
                  ),
                );
                setState(() => _copiedReferral = true);
              },
              onOpenVip: () => context.go(AppRoutePaths.profileVip),
              onOpenPredictions: () =>
                  context.go(AppRoutePaths.marketsPredictionsPortfolio),
              onOpenArena: () => context.go(AppRoutePaths.arenaMy),
              onOpenActivity: () => context.go(AppRoutePaths.profileActivity),
              onLogout: () async {
                await ref.read(authSessionControllerProvider.notifier).logout();
                if (context.mounted) context.go(AppRoutePaths.authLogin);
              },
            ),
          ),
        ),
      ),
    );
  }
}
