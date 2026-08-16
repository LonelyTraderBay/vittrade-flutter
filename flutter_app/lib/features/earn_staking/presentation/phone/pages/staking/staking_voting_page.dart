import 'dart:async';

import 'package:flutter/material.dart';
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

class StakingVotingPage extends ConsumerStatefulWidget {
  const StakingVotingPage({super.key, this.proposalId, this.shellRenderMode});

  static const proposalKey = Key('sc390_proposal');
  static const resultsKey = Key('sc390_results');
  static const castVoteKey = Key('sc390_cast_vote');
  static const noteKey = Key('sc390_voting_power_note');
  static const submitKey = Key('sc390_submit_vote');

  static Key optionKey(String id) => Key('sc390_vote_option_$id');

  final String? proposalId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingVotingPage> createState() => _StakingVotingPageState();
}

class _StakingVotingPageState extends ConsumerState<StakingVotingPage> {
  String? _selectedVote;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      stakingVotingSnapshotProvider(widget.proposalId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bỏ phiếu đề xuất staking',
      semanticIdentifier: 'SC-390',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnProposals),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnProposals),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                stakingVotingSnapshotProvider(widget.proposalId),
              ),
            ),
          ),
          data: (snapshot) {
            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Bỏ phiếu đề xuất stake',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          VitPageContent(
                            rhythm: VitPageRhythm.standard,
                            padding: VitContentPadding.defaultPadding,
                            gap: VitContentGap.defaultGap,
                            children: [
                              _ProposalSummary(snapshot: snapshot),
                              _ResultsSection(results: snapshot.results),
                              _VoteSection(
                                title: snapshot.voteTitle,
                                options: snapshot.options,
                                selectedVote: _selectedVote,
                                onSelect: (id) =>
                                    setState(() => _selectedVote = id),
                              ),
                              _VotingPowerNote(snapshot: snapshot),
                            ],
                          ),
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardSectionGap,
                          ),
                          VitStickyFooter(
                            child: VitCtaButton(
                              key: StakingVotingPage.submitKey,
                              onPressed: _selectedVote == null
                                  ? null
                                  : () => unawaited(_submitVote(snapshot)),
                              child: Text(snapshot.submitLabel),
                            ),
                          ),
                          SizedBox(height: bottomInset),
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

  Future<void> _submitVote(StakingVotingSnapshot snapshot) async {
    final selectedId = _selectedVote;
    if (selectedId == null) return;
    final optionLabel = snapshot.options
        .firstWhere((option) => option.id == selectedId)
        .label;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã ghi nhận phiếu bầu',
      message:
          'Bạn đã bỏ phiếu "$optionLabel" cho đề xuất "${snapshot.proposalTitle}".',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
      onPrimary: () {
        if (!mounted) return;
        context.go(snapshot.backRoute);
      },
    );
  }
}

class _ProposalSummary extends StatelessWidget {
  const _ProposalSummary({required this.snapshot});

  final StakingVotingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingVotingPage.proposalKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentPill(
            label: snapshot.category,
            accentColor: AppColors.text3,
            size: VitStatusPillSize.sm,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(snapshot.proposalTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Padding(
            padding: EarnSpacingTokens.earnContentHorizontalPadding.copyWith(
              left: AppSpacing.zero,
              top: AppSpacing.zero,
              right: AppSpacing.x6,
              bottom: AppSpacing.zero,
            ),
            child: Text(
              snapshot.proposalBody,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: EarnSpacingTokens.stakingCommunityBodyLineHeight,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.large,
            padding: EarnSpacingTokens.earnCardPaddingX3X4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  snapshot.proposedByLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.proposedBy,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({required this.results});

  final List<StakingVotingResultDraft> results;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingVotingPage.resultsKey,
      label: 'Current Results',
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnContentHorizontalPadding.copyWith(
            top: AppSpacing.x5,
            bottom: AppSpacing.x5,
          ),
          child: Column(
            children: [
              for (var index = 0; index < results.length; index++) ...[
                _ResultRow(result: results[index]),
                if (index != results.length - 1)
                  const SizedBox(height: AppSpacing.rowGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result});

  final StakingVotingResultDraft result;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(result.tone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${result.label} (${result.percent}%)',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              '${VitFormat.count(result.votes)} votes',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: result.id == 'yes'
                    ? 1
                    : result.percent.clamp(0, 100) / 100,
                child: SizedBox.expand(child: ColoredBox(color: color)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VoteSection extends StatelessWidget {
  const _VoteSection({
    required this.title,
    required this.options,
    required this.selectedVote,
    required this.onSelect,
  });

  final String title;
  final List<StakingVotingOptionDraft> options;
  final String? selectedVote;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingVotingPage.castVoteKey,
      label: title,
      children: [
        Row(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              Expanded(
                child: _VoteOptionCard(
                  option: options[index],
                  selected: selectedVote == options[index].id,
                  onTap: () => onSelect(options[index].id),
                ),
              ),
              if (index != options.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _VoteOptionCard extends StatelessWidget {
  const _VoteOptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final StakingVotingOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(option.tone);
    return VitCard(
      key: StakingVotingPage.optionKey(option.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnContentHorizontalPadding.copyWith(
        top: AppSpacing.x5,
        bottom: AppSpacing.x5,
      ),
      borderColor: selected ? color : AppColors.cardBorder,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            option.id == 'yes'
                ? Icons.thumb_up_alt_outlined
                : Icons.thumb_down_alt_outlined,
            color: selected ? color : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            option.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? color : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _VotingPowerNote extends StatelessWidget {
  const _VotingPowerNote({required this.snapshot});

  final StakingVotingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingVotingPage.noteKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x1),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${snapshot.votingPowerPrefix} '),
                  TextSpan(
                    text: snapshot.votingPower,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: ' ${snapshot.votingPowerSuffix}'),
                ],
              ),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: EarnSpacingTokens.stakingCommunityDescriptionLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _toneColor(String tone) {
  switch (tone) {
    case 'success':
      return AppColors.buy;
    case 'danger':
      return AppColors.sell;
    default:
      return AppColors.primary;
  }
}
