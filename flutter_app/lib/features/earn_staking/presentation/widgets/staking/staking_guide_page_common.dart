part of '../../phone/pages/staking/staking_guide_page.dart';

class _StepDetail extends StatelessWidget {
  const _StepDetail({required this.step});

  final StakingGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RoundIcon(
              icon: _guideIcon(step.iconKey),
              color: AppModuleAccents.earn,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(child: Text(step.title, style: AppTextStyles.baseMedium)),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Text(
          step.description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: EarnSpacingTokens.earnGuideParagraphLineHeight,
          ),
        ),
      ],
    );
  }
}

class _TipPanel extends StatelessWidget {
  const _TipPanel({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tips quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final tip in tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EarnSpacingTokens.earnWithdrawalBulletPadding,
                  child: SizedBox(
                    width: EarnSpacingTokens.earnGuideBulletSize,
                    height: EarnSpacingTokens.earnGuideBulletSize,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: AppColors.text3,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: EarnSpacingTokens.earnGuideTipLineHeight,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != tips.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  const _DifficultyPill({required this.difficulty});

  final StakingGuideDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = _difficultyColor(difficulty);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          difficulty.name,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: EarnSpacingTokens.earnGuidePillLineHeight,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.color,
    this.size = AppSpacing.x7,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.28)),
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(icon, color: color, size: AppSpacing.iconMd),
        ),
      ),
    );
  }
}

String _difficultyTabLabel(StakingGuideDifficulty difficulty) {
  return switch (difficulty) {
    StakingGuideDifficulty.beginner => 'Beginner',
    StakingGuideDifficulty.intermediate => 'Intermediate',
    StakingGuideDifficulty.advanced => 'Advanced',
  };
}

Color _difficultyColor(StakingGuideDifficulty difficulty) {
  return switch (difficulty) {
    StakingGuideDifficulty.beginner => AppColors.buy,
    StakingGuideDifficulty.intermediate => AppModuleAccents.earn,
    StakingGuideDifficulty.advanced => AppColors.warn,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'danger' => AppColors.sell,
    _ => AppModuleAccents.earn,
  };
}

IconData _guideIcon(String iconKey) {
  return switch (iconKey) {
    'book' => Icons.menu_book_outlined,
    'calculator' => Icons.calculate_outlined,
    'shield' => Icons.shield_outlined,
    'chart' => Icons.bar_chart_rounded,
    'lock' => Icons.lock_outline_rounded,
    'bell' => Icons.notifications_active_outlined,
    'calendar' => Icons.event_available_outlined,
    'trend' => Icons.trending_up_rounded,
    'warning' => Icons.warning_amber_rounded,
    _ => Icons.lightbulb_outline_rounded,
  };
}
