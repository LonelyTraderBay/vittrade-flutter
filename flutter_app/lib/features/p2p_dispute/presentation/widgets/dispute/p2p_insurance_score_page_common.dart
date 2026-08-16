part of '../../phone/pages/dispute/p2p_insurance_score_page.dart';

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({required this.action});

  final P2PInsuranceScoreQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(action.toneKey);
    final enabled = action.route != null;
    return VitCard(
      key: P2PInsuranceScorePage.quickActionKey(action.label),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      onTap: enabled
          ? () {
              unawaited(HapticFeedback.selectionClick());
              context.go(action.route!);
            }
          : null,
      child: Opacity(
        opacity: enabled ? 1 : .55,
        child: Row(
          children: [
            SizedBox.square(
              dimension: AppSpacing.x2,
              child: Material(color: color, shape: const CircleBorder()),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                action.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              action.gain,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (enabled) ...[
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TierPathCard extends StatelessWidget {
  const _TierPathCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.diamond_outlined,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Lộ trình nâng cấp',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var i = 0; i < snapshot.tierRequirements.length; i++) ...[
            _TierCard(
              tier: snapshot.tierRequirements[i],
              score: snapshot.overallScore,
            ),
            if (i != snapshot.tierRequirements.length - 1)
              const Center(
                child: SizedBox(
                  height: AppSpacing.pageRhythmStandardInnerGap,
                  child: VerticalDivider(
                    width: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier, required this.score});

  final P2PInsuranceScoreTierDraft tier;
  final int score;

  @override
  Widget build(BuildContext context) {
    final color = tier.isCurrent
        ? AppModuleAccents.p2p
        : (tier.isUnlocked ? AppColors.buy : AppColors.text3);
    final progress = tier.requiredScore == 0
        ? 1.0
        : (score / tier.requiredScore).clamp(0.0, 1.0);

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: tier.isCurrent ? AppColors.primary40 : AppColors.divider,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                tier.isUnlocked
                    ? Icons.check_circle_outline_rounded
                    : Icons.lock_outline_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  tier.isCurrent ? '${tier.name} - HIỆN TẠI' : tier.name,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                tier.coveragePct,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          if (!tier.isUnlocked) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                Text(
                  'Tiến độ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '$score/${tier.requiredScore}',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: SizedBox(
                height: AppSpacing.x1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.surface3),
                    FractionallySizedBox(
                      widthFactor: progress,
                      alignment: Alignment.centerLeft,
                      child: const ColoredBox(color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final requirement in tier.requirements)
                _RequirementChip(label: requirement, passed: tier.isUnlocked),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label, required this.passed});

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: passed ? AppColors.buy : AppColors.text3,
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppTextStyles.numericMicro.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'buy' => AppColors.buy,
    'primary' => AppModuleAccents.p2p,
    'accent' => AppColors.accent,
    'warn' => AppColors.warn,
    'sell' => AppColors.sell,
    _ => AppColors.text2,
  };
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'user_check' => Icons.verified_user_outlined,
    'bar_chart' => Icons.bar_chart_rounded,
    'shield' => Icons.shield_outlined,
    'award' => Icons.workspace_premium_outlined,
    'lock' => Icons.lock_outline_rounded,
    _ => Icons.shield_outlined,
  };
}
