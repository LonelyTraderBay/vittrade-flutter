import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_community_governance_page_sections.dart';
part '../../../widgets/staking/staking_community_governance_page_common.dart';

class StakingCommunityGovernancePage extends ConsumerWidget {
  const StakingCommunityGovernancePage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc388_info');
  static const overviewKey = Key('sc388_overview');
  static const activeProposalKey = Key('sc388_active_proposal');
  static const decisionsKey = Key('sc388_decisions');
  static const stepsKey = Key('sc388_steps');
  static const votingPowerKey = Key('sc388_voting_power');
  static const viewProposalsKey = Key('sc388_view_proposals');
  static const joinForumKey = Key('sc388_join_forum');
  static const footerKey = Key('sc388_footer');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingCommunityGovernanceSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản trị cộng đồng stake',
      semanticIdentifier: 'SC-388',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingCommunityGovernanceSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Quản trị cộng đồng stake',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          VitInfoCallout(
                            key: StakingCommunityGovernancePage.infoKey,
                            title: snapshot.infoTitle,
                            message: snapshot.infoBody,
                            icon: Icons.how_to_vote_outlined,
                            accentColor: AppColors.accent,
                            padding: EarnSpacingTokens.earnCardPaddingX3,
                          ),
                          _OverviewCard(
                            title: snapshot.statsTitle,
                            stats: snapshot.stats,
                          ),
                          _ActiveProposal(
                            proposal: snapshot.activeProposal,
                            onTap: () => context.go(snapshot.proposalsRoute),
                          ),
                          _RecentDecisions(decisions: snapshot.recentDecisions),
                          _GovernanceSteps(steps: snapshot.governanceSteps),
                          _VotingPower(power: snapshot.votingPower),
                          _ActionButtons(
                            onProposals: () =>
                                context.go(snapshot.proposalsRoute),
                            onForum: () => context.go(snapshot.forumRoute),
                          ),
                          _FooterNote(note: snapshot.footerNote),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
