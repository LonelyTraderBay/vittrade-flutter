part of '../../phone/pages/savings/savings_goal_page.dart';

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.onTap});

  final SavingsGoalDraft goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final accent = _goalColor(goal);
    final unlocked = goal.milestones
        .where((milestone) => milestone.unlocked)
        .length;
    final next = goal.milestones.where((milestone) => !milestone.unlocked);
    final daysRemaining = _daysRemaining(goal.targetDate);
    final completed = goal.status == SavingsGoalStatus.completed;

    return VitCard(
      key: SavingsGoalPage.goalKey(goal.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _GoalIcon(iconKey: goal.iconKey, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            goal.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (completed) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const _TinyPill(
                            label: 'Hoàn thành',
                            color: AppColors.buy,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${goal.linkedProduct} - APY ${goal.linkedProductApy.toStringAsFixed(1)}%',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              _ProgressRing(
                progress: progress,
                color: accent,
                size: EarnSpacingTokens.savingsGoalCardProgressRing,
                strokeWidth: EarnSpacingTokens.savingsGoalCardProgressStroke,
                centerLabel: '${(progress * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  EarnFormatters.usd(goal.currentAmount),
                  style: AppTextStyles.baseMedium.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                '/ ${EarnFormatters.usd(goal.targetAmount)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitProgressBar(progress: progress, color: accent),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _MilestoneRail(goal: goal, color: accent, unlocked: unlocked),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          if (completed)
            Row(
              children: [
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Tất cả milestone đã hoàn thành',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            )
          else
            Wrap(
              spacing: AppSpacing.x4,
              runSpacing: AppSpacing.x2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _MetaItem(
                  icon: Icons.calendar_today_outlined,
                  label: '$daysRemaining ngày',
                  color: AppColors.text3,
                ),
                if (goal.autoContribute)
                  _MetaItem(
                    icon: Icons.flash_on_rounded,
                    label:
                        '${EarnFormatters.usd(goal.monthlyContribution)}/tháng',
                    color: accent,
                  ),
                _MetaItem(
                  icon: Icons.emoji_events_outlined,
                  label: 'Tiếp: ${next.isEmpty ? 100 : next.first.percentage}%',
                  color: AppColors.warn,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MilestoneRail extends StatelessWidget {
  const _MilestoneRail({
    required this.goal,
    required this.color,
    required this.unlocked,
  });

  final SavingsGoalDraft goal;
  final Color color;
  final int unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final milestone in goal.milestones) ...[
          _MilestoneDot(milestone: milestone, color: color),
          if (milestone != goal.milestones.last)
            Expanded(
              child: Padding(
                padding: EarnSpacingTokens.earnInlineMarginX1,
                child: SizedBox(
                  height: EarnSpacingTokens.savingsGoalTimelineDividerHeight,
                  child: ColoredBox(
                    color: milestone.unlocked ? color : AppColors.borderSolid,
                  ),
                ),
              ),
            ),
        ],
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$unlocked/${goal.milestones.length}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
