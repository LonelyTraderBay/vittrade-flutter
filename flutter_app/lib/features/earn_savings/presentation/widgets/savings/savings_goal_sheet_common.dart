part of '../../phone/pages/savings/savings_goal_page.dart';

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child, required this.heightFactor});

  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: VitSheetSurface(
        color: AppColors.surface,
        borderRadius: AppRadii.sheetTopLargeRadius,
        padding: AppSpacing.zeroInsets,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EarnSpacingTokens.earnSheetContentPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHeading extends StatelessWidget {
  const _SheetHeading({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warn, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'house' => Icons.savings_outlined,
    'car' => Icons.paid_outlined,
    'vacation' => Icons.star_border_rounded,
    'education' => Icons.workspace_premium_outlined,
    'emergency' => Icons.error_outline_rounded,
    'sparkles' => Icons.auto_awesome_outlined,
    'trophy' => Icons.emoji_events_outlined,
    _ => Icons.track_changes_rounded,
  };
}

Color _goalColor(SavingsGoalDraft goal) {
  return switch (goal.iconKey) {
    'emergency' => AppColors.sell,
    'vacation' => AppColors.warn,
    'education' => AppColors.accent,
    'house' => AppColors.primary,
    'car' => AppColors.buy,
    _ =>
      goal.status == SavingsGoalStatus.completed
          ? AppColors.primary
          : AppColors.accent,
  };
}

Color _templateColor(String iconKey) {
  return switch (iconKey) {
    'emergency' => AppColors.sell,
    'vacation' => AppColors.warn,
    'education' => AppColors.accent,
    'house' => AppColors.primary,
    'car' => AppColors.buy,
    _ => AppColors.accent,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.accent,
    EarnRiskLevel.high => AppColors.warn,
  };
}

int _daysRemaining(String targetDate) {
  final now = DateTime(2026, 3, 9);
  final target = DateTime.parse(targetDate);
  return math.max(0, target.difference(now).inDays);
}

String _formatDate(String value) {
  final date = DateTime.parse(value);
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
