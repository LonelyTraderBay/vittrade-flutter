part of '../phone/pages/unified_search_page.dart';

class _PredictionResultCard extends StatelessWidget {
  const _PredictionResultCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('prediction', event.id),
      onTap: () => context.go(event.route),
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      borderColor: AppModuleAccents.predictions.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DiscoveryModuleBadge(
            label: 'Thị trường dự đoán',
            icon: Icons.track_changes_rounded,
            color: AppModuleAccents.predictions,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            event.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Text(
                '${event.topOutcome} ${event.chance}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                'KL ${event.volumeLabel}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Spacer(),
              const DiscoveryInlineCta(
                label: 'Xem thị trường',
                color: AppModuleAccents.predictions,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaModeResultCard extends StatelessWidget {
  const _ArenaModeResultCard({required this.mode});

  final DiscoveryArenaModeDraft mode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('arenaMode', mode.id),
      onTap: () => context.go(mode.route),
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      borderColor: AppModuleAccents.arena.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DiscoveryModuleBadge(
                label: 'Open Arena',
                icon: Icons.bolt_rounded,
                color: AppModuleAccents.arena,
              ),
              if (mode.fairPlay) ...[
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Chơi công bằng',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            mode.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            mode.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${mode.activeChallenges} thách đấu · ${mode.cloneCount} bản sao',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const DiscoveryInlineCta(
                label: 'Xem chế độ',
                color: AppModuleAccents.arena,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
