import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingProposalsPage extends ConsumerWidget {
  const StakingProposalsPage({super.key, this.shellRenderMode});

  static const listKey = Key('sc389_proposals');
  static const createKey = Key('sc389_create');

  static Key proposalKey(String id) => Key('sc389_proposal_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingProposalsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Danh sách đề xuất cộng đồng staking',
      semanticIdentifier: 'SC-389',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnCommunityGovernance),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnCommunityGovernance),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingProposalsSnapshotProvider),
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
                subtitle: 'Đề xuất cộng đồng — APY tham khảo',
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
                          VitCard(
                            variant: VitCardVariant.standard,
                            radius: VitCardRadius.standard,
                            padding: AppSpacing.zeroInsets,
                            child: _ProposalList(proposals: snapshot.proposals),
                          ),
                          VitCtaButton(
                            key: StakingProposalsPage.createKey,
                            onPressed: () {
                              unawaited(HapticFeedback.selectionClick());
                              unawaited(
                                showVitNoticeSheet(
                                  context: context,
                                  title: 'Sẽ sớm ra mắt',
                                  message: 'Tạo đề xuất sẽ sớm ra mắt',
                                ),
                              );
                            },
                            variant: VitCtaButtonVariant.secondary,
                            child: Text(snapshot.createLabel),
                          ),
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

class _ProposalList extends StatelessWidget {
  const _ProposalList({required this.proposals});

  final List<StakingProposalDraft> proposals;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingProposalsPage.listKey,
      label: 'Active Proposals',
      children: [
        for (final proposal in proposals)
          _ProposalCard(
            proposal: proposal,
            onVote: () => context.go(proposal.votingRoute),
          ),
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.proposal, required this.onVote});

  final StakingProposalDraft proposal;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProposalsPage.proposalKey(proposal.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onVote,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(proposal.title, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              VitAccentPill(
                label: proposal.category,
                accentColor: AppColors.text3,
                size: VitStatusPillSize.sm,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    '${proposal.endsIn} left',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yes ${proposal.yesPercent.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'No ${proposal.noPercent.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _VoteRatioBar(yesPercent: proposal.yesPercent),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${VitFormat.count(proposal.totalVotes)} votes - ${proposal.quorum}% quorum',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              VitCtaButton(
                onPressed: onVote,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: EarnSpacingTokens.earnHorizontalPaddingX4,
                child: const Text('Vote Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoteRatioBar extends StatelessWidget {
  const _VoteRatioBar({required this.yesPercent});

  final double yesPercent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.smRadius,
      child: SizedBox(
        height: AppSpacing.pageRhythmCompactInnerGap,
        child: ColoredBox(
          color: AppColors.surface2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: yesPercent.clamp(0, 100) / 100,
              child: const SizedBox.expand(
                child: ColoredBox(color: AppColors.buy),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
