import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/merchant/p2p_kyc_requirements_page_sections.dart';
part '../../../widgets/merchant/p2p_kyc_requirements_page_common.dart';

const double _p2pKycIconBoxExtent = AppSpacing.inputHeight - AppSpacing.x2;
const double _p2pKycRequirementIconBoxExtent = AppSpacing.x6;
const double _p2pKycReadableLineHeight = 1.35;
const double _p2pKycTitleLineHeight = 1.0;
const double _p2pKycSmallIconExtent = P2PSpacingTokens.p2pHomeSmallIcon;
const double _p2pKycChecklistIconExtent = P2PSpacingTokens.p2pHomeVerifiedIcon;
const double _p2pKycDividerExtent = AppSpacing.dividerHairline;
const double _p2pKycCtaHeight = AppSpacing.ctaHeight - AppSpacing.x1;

class P2PKycRequirementsPage extends ConsumerWidget {
  const P2PKycRequirementsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc247_p2p_kyc_requirements_hero');
  static const noticeKey = Key('sc247_p2p_kyc_requirements_notice');
  static Key tierKey(int tierId) =>
      Key('sc247_p2p_kyc_requirements_tier_$tierId');
  static Key upgradeKey(int tierId) =>
      Key('sc247_p2p_kyc_requirements_upgrade_$tierId');
  static const supportKey = Key('sc247_p2p_kyc_requirements_support');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pKycRequirementsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Yêu cầu KYC P2P',
      semanticIdentifier: 'SC-247',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pKycRequirementsProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Yêu cầu KYC',
              subtitle: 'KYC · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pKycRequirementsScrollPadding(
                        scrollEndPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _KycHero(snapshot: snapshot),
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          _KycNotice(snapshot: snapshot),
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          for (final tier in snapshot.tiers) ...[
                            _KycTierCard(
                              tier: tier,
                              onUpgrade:
                                  tier.status == P2PKycTierStatus.available
                                  ? () {
                                      unawaited(
                                        HapticFeedback.selectionClick(),
                                      );
                                      context.go(
                                        snapshot.verifyRouteFor(tier.id),
                                      );
                                    }
                                  : null,
                            ),
                            if (tier != snapshot.tiers.last)
                              const SizedBox(
                                height: AppSpacing.pageRhythmStandardInnerGap,
                              ),
                          ],
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          _KycSupportCard(snapshot: snapshot),
                          const VitPageContent(
                            rhythm: VitPageRhythm.form,
                            padding: VitContentPadding.compact,
                            density: VitDensity.compact,
                            children: [
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Xem lại yêu cầu KYC',
                                message:
                                    'Hạng hiện tại, yêu cầu bị khóa, hành động nâng cấp khả dụng, đường hỗ trợ và ảnh hưởng hạn mức P2P vẫn hiển thị trước khi bắt đầu xác minh.',
                                contractId: 'SC-247',
                                density: VitDensity.compact,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
