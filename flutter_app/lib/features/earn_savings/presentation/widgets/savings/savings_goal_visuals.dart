part of '../../phone/pages/savings/savings_goal_page.dart';

class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({required this.milestone, required this.color});

  final SavingsGoalMilestoneDraft milestone;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final unlocked = milestone.unlocked;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: unlocked ? color : AppColors.surface3,
        shape: CircleBorder(
          side: BorderSide(
            color: unlocked ? color : AppColors.borderSolid,
            width: EarnSpacingTokens.savingsGoalMilestoneBorderWidth,
          ),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x4,
        height: AppSpacing.x4,
        child: unlocked
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.x3,
              )
            : Center(
                child: Text(
                  '${milestone.percentage}',
                  style: AppTextStyles.microTiny.copyWith(
                    color: AppColors.text3,
                    height: EarnSpacingTokens.savingsGoalMilestoneLineHeight,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.color,
    required this.size,
    required this.strokeWidth,
    this.centerLabel,
  });

  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _ProgressRingPainter(
              progress: progress,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerLabel != null)
            Text(
              centerLabel!,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final track = Paint()
      ..color = AppColors.surface3
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final active = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _GoalIcon extends StatelessWidget {
  const _GoalIcon({required this.iconKey, required this.color});

  final String iconKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(_iconFor(iconKey), color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: EarnSpacingTokens.savingsGoalSheetTitleLineHeight,
          ),
        ),
      ),
    );
  }
}
