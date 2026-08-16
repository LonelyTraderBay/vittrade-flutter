part of '../../phone/pages/savings/savings_dca_page.dart';

class _PlansList extends StatelessWidget {
  const _PlansList({
    required this.plans,
    required this.locallyPaused,
    required this.onToggle,
  });

  final List<SavingsDcaPlanDraft> plans;
  final Set<String> locallyPaused;
  final ValueChanged<SavingsDcaPlanDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsDCAPage.plansListKey,
      children: [
        for (final plan in plans) ...[
          _PlanCard(
            plan: plan,
            paused:
                locallyPaused.contains(plan.id) ||
                plan.status == SavingsDcaPlanStatus.paused,
            onToggle: () => onToggle(plan),
          ),
          if (plan != plans.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.paused,
    required this.onToggle,
  });

  final SavingsDcaPlanDraft plan;
  final bool paused;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final statusColor = paused ? AppColors.warn : AppColors.buy;
    final statusLabel = paused ? 'Tạm dừng' : plan.statusLabel;

    return VitCard(
      key: SavingsDCAPage.planKey(plan.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssetBadge(
                asset: plan.assetLabel,
                color: _assetColor(plan.asset),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(plan.productName, style: _captionBold),
                        VitAccentPill(
                          label: statusLabel,
                          accentColor: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        const Icon(
                          Icons.sync_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            '${plan.amountPerPeriodLabel} / ${plan.frequencyLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.currentApyLabel,
                    style: _captionBold.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _PlanMetric(
                  label: 'Đã gửi',
                  value: plan.totalInvestedLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PlanMetric(
                  label: 'Giá trị',
                  value: plan.currentValueLabel,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PlanMetric(
                  label: 'Lợi nhuận',
                  value: plan.gainLabel,
                  valueColor: plan.gainPositive
                      ? AppColors.buy
                      : AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tiếp theo: ${plan.nextExecution}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              _PlanIconButton(paused: paused, onTap: onToggle),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _microBold.copyWith(
              color: valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanIconButton extends StatelessWidget {
  const _PlanIconButton({required this.paused, required this.onTap});

  final bool paused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = paused ? Icons.play_arrow_rounded : Icons.pause_rounded;

    return VitIconButton(
      icon: icon,
      tooltip: paused ? 'Tiếp tục kế hoạch' : 'Tạm dừng kế hoạch',
      onPressed: onTap,
      variant: paused
          ? VitIconButtonVariant.success
          : VitIconButtonVariant.primary,
      size: VitIconButtonSize.sm,
    );
  }
}
