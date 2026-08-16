part of '../../phone/pages/savings/savings_goal_page.dart';

class _GoalDetailSheet extends StatelessWidget {
  const _GoalDetailSheet({required this.goal});

  final SavingsGoalDraft goal;

  @override
  Widget build(BuildContext context) {
    final accent = _goalColor(goal);
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final remaining = math.max<double>(
      0,
      goal.targetAmount - goal.currentAmount,
    );

    return Column(
      key: SavingsGoalPage.detailSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(goal.name, style: AppTextStyles.sectionTitle)),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            _ProgressRing(
              progress: progress,
              color: accent,
              size: EarnSpacingTokens.savingsGoalDetailProgressRing,
              strokeWidth: EarnSpacingTokens.savingsGoalDetailProgressStroke,
              centerLabel: '${(progress * 100).round()}%',
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    EarnFormatters.usd(goal.currentAmount),
                    style: AppTextStyles.pageTitle.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'Mục tiêu: ${EarnFormatters.usd(goal.targetAmount)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  if (remaining > 0)
                    Text(
                      'Còn thiếu: ${EarnFormatters.usd(remaining)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            children: [
              _SheetMetric(
                label: 'Ngày bắt đầu',
                value: _formatDate(goal.startDate),
              ),
              _SheetMetric(
                label: 'Ngày mục tiêu',
                value: _formatDate(goal.targetDate),
              ),
              _SheetMetric(label: 'Sản phẩm', value: goal.linkedProduct),
              _SheetMetric(
                label: 'APY',
                value: '${goal.linkedProductApy.toStringAsFixed(1)}%',
                color: AppColors.buy,
              ),
              if (goal.autoContribute)
                _SheetMetric(
                  label: 'Auto-contribute',
                  value:
                      '${EarnFormatters.usd(goal.monthlyContribution)}/tháng',
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _SheetHeading(
          icon: Icons.emoji_events_outlined,
          label: 'Milestone Rewards',
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final milestone in goal.milestones) ...[
          _MilestoneRow(milestone: milestone, color: accent),
          if (milestone != goal.milestones.last)
            const Divider(color: AppColors.divider, height: AppSpacing.x1),
        ],
        if (goal.contributions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const _SheetHeading(
            icon: Icons.arrow_upward_rounded,
            label: 'Đóng góp gần đây',
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final contribution in goal.contributions)
            _ContributionRow(contribution: contribution),
        ],
      ],
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.milestone, required this.color});

  final SavingsGoalMilestoneDraft milestone;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX3,
      child: Row(
        children: [
          _MilestoneDot(milestone: milestone, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  milestone.reward,
                  style: AppTextStyles.micro.copyWith(
                    color: milestone.unlocked ? color : AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          _TinyPill(
            label: milestone.unlocked
                ? (milestone.claimedAt == null ? 'Nhận ngay' : 'Đã nhận')
                : '${milestone.percentage}%',
            color: milestone.unlocked ? color : AppColors.text3,
          ),
        ],
      ),
    );
  }
}

class _ContributionRow extends StatelessWidget {
  const _ContributionRow({required this.contribution});

  final SavingsGoalContributionDraft contribution;

  @override
  Widget build(BuildContext context) {
    final automatic = contribution.source == 'Tự động';
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+${EarnFormatters.usd(contribution.amount)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  _formatDate(contribution.date),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _TinyPill(
            label: contribution.source,
            color: automatic ? AppColors.primary : AppColors.buy,
          ),
        ],
      ),
    );
  }
}
