part of '../../phone/pages/savings/savings_goal_page.dart';

class _GoalSummaryCard extends StatelessWidget {
  const _GoalSummaryCard({required this.goals});

  final List<SavingsGoalDraft> goals;

  @override
  Widget build(BuildContext context) {
    final activeGoals = goals
        .where((goal) => goal.status == SavingsGoalStatus.active)
        .toList();
    final completedGoals = goals
        .where((goal) => goal.status == SavingsGoalStatus.completed)
        .length;
    final totalCurrent = activeGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );
    final totalTarget = activeGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );
    final milestones = goals.fold<int>(
      0,
      (sum, goal) => sum + goal.milestones.length,
    );
    final unlocked = goals.fold<int>(
      0,
      (sum, goal) =>
          sum + goal.milestones.where((milestone) => milestone.unlocked).length,
    );
    final progress = totalTarget == 0 ? 0.0 : totalCurrent / totalTarget;

    return VitCard(
      key: SavingsGoalPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX5,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tiến độ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      EarnFormatters.usd(totalCurrent),
                      style: AppTextStyles.pageTitle.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'mục tiêu ${EarnFormatters.usd(totalTarget)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              _ProgressRing(
                progress: progress,
                color: AppColors.primary,
                size: EarnSpacingTokens.savingsGoalHeroProgressRing,
                strokeWidth: EarnSpacingTokens.savingsGoalHeroProgressStroke,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  value: '${activeGoals.length}',
                  label: 'Đang thực hiện',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  value: '$completedGoals',
                  label: 'Hoàn thành',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  value: '$unlocked/$milestones',
                  label: 'Milestone',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final SavingsGoalTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);
    return VitCard(
      key: SavingsGoalPage.tipKey(tip.title),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          _GoalIcon(iconKey: tip.iconKey, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
