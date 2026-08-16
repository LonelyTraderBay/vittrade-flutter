part of '../phone/pages/rewards_hub_page.dart';

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.completionLabel,
    required this.filters,
    required this.activeFilter,
    required this.tasks,
    required this.onFilter,
  });

  final String completionLabel;
  final List<String> filters;
  final String activeFilter;
  final List<RewardTaskDraft> tasks;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: VitSectionHeader(
                title: 'Nhiệm vụ',
                icon: Icons.task_alt_outlined,
                iconColor: AppColors.primary,
                accentColor: AppColors.primary,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              completionLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final filter in filters) ...[
                VitFilterChip(
                  key: filter == activeFilter
                      ? RewardsHubPage.activeFilterKey(filter)
                      : RewardsHubPage.filterKey(filter),
                  label: filter,
                  active: filter == activeFilter,
                  onTap: () => onFilter(filter),
                  color: AppModuleAccents.rewards,
                ),
                if (filter != filters.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        if (tasks.isEmpty)
          const VitEmptyState(
            icon: Icons.redeem_outlined,
            title: 'Không có nhiệm vụ nào',
            message: 'Chọn danh mục khác hoặc quay lại sau.',
          )
        else
          Column(
            children: [
              for (final task in tasks) ...[
                VitTaskCard(
                  key: RewardsHubPage.taskKey(task.id),
                  title: task.title,
                  subtitle: task.subtitle,
                  progress: task.progress,
                  rewardLabel: task.rewardLabel,
                  status: _vitTaskCardStatus(task.status),
                  accentColor: _accentColor(task.kind),
                  icon: _accentIcon(task.kind),
                ),
                if (task != tasks.last)
                  const SizedBox(height: AppSpacing.taskCardListGap),
              ],
            ],
          ),
      ],
    );
  }
}

class _BonusSection extends StatelessWidget {
  const _BonusSection({required this.rows});

  final List<RewardBonusDraft> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: VitSectionHeader(
                title: 'Khu vực Bonus',
                icon: Icons.auto_awesome_outlined,
                iconColor: AppColors.warn,
                accentColor: AppColors.warn,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              '1 lượt quay',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        VitCard(
          padding: AppSpacing.zeroInsets,
          clip: true,
          child: Column(
            children: [
              for (final row in rows) ...[
                _BonusRow(row: row),
                if (row != rows.last)
                  const Divider(
                    height: ArenaSpacingTokens.arenaPointsDividerHeight,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.summary,
    required this.leaderboard,
    required this.onLeaderboardTap,
  });

  final RewardSummaryDraft summary;
  final List<RewardLeaderboardDraft> leaderboard;
  final VoidCallback onLeaderboardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: VitSectionHeader(
                title: 'Tiến trình & Phần thưởng',
                icon: Icons.workspace_premium_outlined,
                iconColor: AppModuleAccents.rewards,
                accentColor: AppModuleAccents.rewards,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              summary.tierLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.rewards,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        VitCard(
          padding: ArenaSpacingTokens.arenaPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const VitAccentIconBox(
                    icon: Icons.workspace_premium_outlined,
                    color: AppModuleAccents.rewards,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.tierLabel,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Cần thêm points để lên hạng Vàng',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_formatRewardPoints(summary.currentPoints)} pts',
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.rewards,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const VitProgressBar(
                progress: .56,
                color: AppModuleAccents.rewards,
                trackColor: AppColors.surface3,
                height: AppSpacing.x3,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                'Bảng xếp hạng',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: VitStatusPill(
                  key: RewardsHubPage.leaderboardKey,
                  label: 'Tất cả',
                  icon: Icons.chevron_right_rounded,
                  status: VitStatusPillStatus.purple,
                  size: VitStatusPillSize.sm,
                  onTap: onLeaderboardTap,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              for (final entry in leaderboard) ...[
                _LeaderboardRow(entry: entry),
                if (entry != leaderboard.last)
                  const Divider(
                    height: ArenaSpacingTokens.arenaPointsDividerHeight,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardsDisclaimer extends StatelessWidget {
  const _RewardsDisclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.rewards,
            size: ArenaSpacingTokens.arenaPointsCheckInIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: ArenaSpacingTokens.arenaPointsBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
