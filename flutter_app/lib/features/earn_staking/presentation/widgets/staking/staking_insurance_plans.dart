part of '../../phone/pages/staking/staking_insurance_page.dart';

class _PlansTab extends StatelessWidget {
  const _PlansTab({required this.snapshot, required this.onOpenPlan});

  final StakingInsuranceSnapshot snapshot;
  final ValueChanged<StakingInsurancePlanDraft> onOpenPlan;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chọn Plan Bảo hiểm',
      accentColor: AppColors.primarySoft,
      children: [
        for (final plan in snapshot.plans)
          _PlanCard(plan: plan, onTap: () => onOpenPlan(plan)),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onTap});

  final StakingInsurancePlanDraft plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.planKey(plan.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: AppTextStyles.baseMedium),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        VitAccentPill(
                          label: '${plan.coverage}% Coverage',
                          accentColor: AppColors.buy,
                        ),
                        VitAccentPill(
                          label: '${plan.cooldownDays}d Claim',
                          accentColor: AppColors.primarySoft,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${plan.premium.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.primarySoft,
                    ),
                  ),
                  Text(
                    'Premium',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _PlanMetric(
                  label: 'Max Claim',
                  value: _formatUsd(plan.maxClaim),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _PlanMetric(
                  label: 'Processing',
                  value: '${plan.cooldownDays} ngày',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
