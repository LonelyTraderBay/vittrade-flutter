part of '../phone/pages/performance_monitor.dart';

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final PerformanceOptimizationTip tip;

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(tip.tone);
    final icon = switch (tip.tone) {
      PerformanceScoreTone.good => Icons.trending_down_rounded,
      PerformanceScoreTone.warning => Icons.inventory_2_outlined,
      PerformanceScoreTone.poor => Icons.schedule_rounded,
    };

    return VitCard(
      padding: AdminSpacingTokens.devCompactPadding,
      radius: VitCardRadius.large,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: toneColor, size: AppSpacing.iconSm),
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
                  tip.body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetsCard extends StatelessWidget {
  const _TargetsCard({required this.targets});

  final List<String> targets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      borderColor: AppColors.primary20,
      background: const ColoredBox(color: AppColors.primary08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Targets',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final target in targets)
            Text(
              '- $target',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
        ],
      ),
    );
  }
}

class _InternalNotice extends StatelessWidget {
  const _InternalNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCompactPadding,
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.admin_panel_settings_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AdminSpacingTokens.devVerticalPaddingX2,
      child: Divider(
        height: AdminSpacingTokens.devDividerHeight,
        thickness: AdminSpacingTokens.devDividerThickness,
        color: AppColors.borderSolid,
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x6,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: background,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

Color _toneColor(PerformanceScoreTone tone) {
  return switch (tone) {
    PerformanceScoreTone.good => AppColors.buy,
    PerformanceScoreTone.warning => AppColors.warn,
    PerformanceScoreTone.poor => AppColors.sell,
  };
}
