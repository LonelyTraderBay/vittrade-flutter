import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/referral_spacing_tokens.dart';

part 'referral_home_page_hero_sections.dart';
part 'referral_home_page_reward_sections.dart';
part 'referral_home_page_section_cards.dart';
part 'referral_home_page_common.dart';

const _ctaExtent = 44.0;
const _dividerExtent = 38.0;
const _rankSlot = 28.0;
const _stepBadgeExtent = 28.0;
const _progressExtent = 5.0;
const _avatarExtent = 34.0;
const _milestoneCardWidth = 150.0;
const _refLineTight = 1.2;

class ReferralHomePage extends ConsumerStatefulWidget {
  const ReferralHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc290_referral_home_content');
  static const campaignKey = Key('sc290_referral_campaign');
  static const heroKey = Key('sc290_referral_hero');
  static const copyLinkKey = Key('sc290_copy_link');
  static const shareKey = Key('sc290_share_sheet');
  static const pendingKycKey = Key('sc290_pending_kyc');
  static const calculatorKey = Key('sc290_calculator');
  static const detailHistoryKey = Key('sc290_detail_history');
  static const detailRewardsKey = Key('sc290_detail_rewards');
  static const detailRulesKey = Key('sc290_detail_rules');
  static const inviteKey = Key('sc290_invite_cta');

  static Key milestoneKey(String id) => Key('sc290_milestone_$id');
  static Key campaignHistoryKey(String id) => Key('sc290_campaign_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralHomePage> createState() => _ReferralHomePageState();
}

class _ReferralHomePageState extends ConsumerState<ReferralHomePage> {
  bool _copiedLink = false;
  double _calculatorFriends = 4;

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(referralHomeSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giới thiệu bạn bè',
      semanticIdentifier: 'SC-290',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Giới thiệu bạn bè',
            subtitle: 'Chương trình · Referral',
            showBack: true,
            onBack: () =>
                context.go(homeAsync.value?.backRoute ?? AppRoutePaths.home),
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
                    key: ReferralHomePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: homeAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được trang giới thiệu',
                            message: 'Thử lại sau hoặc quay lại trang chủ.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(referralHomeSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          _CampaignBanner(campaign: snapshot.campaign),
                          const _SafetyNotice(),
                          _PendingKycBanner(
                            count:
                                snapshot.stats.totalFriends -
                                snapshot.stats.kycCompleted,
                            bonus: snapshot.currentTier.kycBonus,
                            onTap: () =>
                                context.go(AppRoutePaths.referralHistory),
                          ),
                          _ReferralHero(
                            snapshot: snapshot,
                            copied: _copiedLink,
                            onCopyCode: () => _copy(snapshot.referralCode),
                            onCopyLink: () => _copy(snapshot.referralLink),
                            onShare: () => _showShareSheet(context, snapshot),
                          ),
                          _SocialProofRail(items: snapshot.socialProof),
                          _MilestoneSection(
                            stats: snapshot.stats,
                            milestones: snapshot.milestones,
                          ),
                          _TierProgress(
                            stats: snapshot.stats,
                            currentTier: snapshot.currentTier,
                            nextTier: snapshot.nextTier,
                          ),
                          _EarningCalculator(
                            friends: _calculatorFriends,
                            currentTier: snapshot.currentTier,
                            onChanged: (value) =>
                                setState(() => _calculatorFriends = value),
                          ),
                          if (snapshot.pendingCommissions.isNotEmpty)
                            _PendingCommissionSection(
                              items: snapshot.pendingCommissions,
                            ),
                          _RewardHighlights(
                            currentTier: snapshot.currentTier,
                            campaign: snapshot.campaign,
                          ),
                          _LeaderboardSection(items: snapshot.leaderboard),
                          _TransparencyNote(
                            commissionPercent:
                                snapshot.currentTier.commissionPercent,
                          ),
                          _DetailLinks(
                            links: snapshot.detailLinks,
                            onOpen: (route) => context.go(route),
                          ),
                          _HowItWorksSection(steps: snapshot.howItWorks),
                          _MonthStats(stats: snapshot.stats),
                          _CampaignHistorySection(
                            items: snapshot.campaignHistory,
                          ),
                          VitCtaButton(
                            key: ReferralHomePage.inviteKey,
                            onPressed: () => _showShareSheet(context, snapshot),
                            leading: const Icon(Icons.group_add_rounded),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            child: const Text('Mời bạn bè ngay'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copy(String value) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(Clipboard.setData(ClipboardData(text: value)));
    setState(() => _copiedLink = true);
  }

  void _showShareSheet(BuildContext context, ReferralHomeSnapshot snapshot) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: AppSpacing.cardPaddingCompact,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Chia sẻ lời mời',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    'Mã ${snapshot.referralCode} · Bạn nhận ${_formatUsd(snapshot.currentTier.kycBonus)} + ${snapshot.currentTier.commissionPercent}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  _SharePreview(link: snapshot.referralLink),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    onPressed: () {
                      _copy(snapshot.referralLink);
                      Navigator.of(context).pop();
                    },
                    leading: const Icon(Icons.copy_rounded),
                    child: const Text('Sao chép lời mời'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
