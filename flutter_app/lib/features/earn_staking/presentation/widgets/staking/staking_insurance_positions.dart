part of '../../phone/pages/staking/staking_insurance_page.dart';

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot, required this.onAddInsurance});

  final StakingInsuranceSnapshot snapshot;
  final ValueChanged<StakingInsurancePositionDraft> onAddInsurance;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInsurancePage.positionsKey,
      label: 'Vị thế Staking',
      accentColor: AppColors.primarySoft,
      children: [
        for (final position in snapshot.positions)
          _PositionCard(
            position: position,
            plan: snapshot.planById(position.insurancePlanId),
            onAddInsurance: () => onAddInsurance(position),
          ),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.plan,
    required this.onAddInsurance,
  });

  final StakingInsurancePositionDraft position;
  final StakingInsurancePlanDraft? plan;
  final VoidCallback onAddInsurance;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.positionKey(position.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
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
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatAmount(position.amount)} ${position.asset} · ${_formatUsd(position.usdValue)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              if (position.insured)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.buy,
                      size: AppSpacing.iconSm,
                    ),
                    SizedBox(width: AppSpacing.x2),
                    VitAccentPill(label: 'Insured', accentColor: AppColors.buy),
                  ],
                )
              else
                const VitAccentPill(
                  label: 'No Insurance',
                  accentColor: AppColors.text3,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          if (position.insured && plan != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              padding: EarnSpacingTokens.earnPaddingX4,
              child: Column(
                children: [
                  _SheetRow(label: 'Plan:', value: plan!.name),
                  _SheetRow(
                    label: 'Coverage:',
                    value: '${plan!.coverage}%',
                    valueColor: AppColors.buy,
                  ),
                  _SheetRow(
                    label: 'Premium/year:',
                    value: _formatUsd(position.usdValue * plan!.premium / 100),
                    valueColor: AppColors.primarySoft,
                  ),
                ],
              ),
            ),
          ],
          if (!position.insured) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCtaButton(
              key: StakingInsurancePage.addInsuranceKey(position.id),
              height: AppSpacing.buttonCompact,
              onPressed: onAddInsurance,
              child: const Text('Thêm bảo hiểm'),
            ),
          ],
        ],
      ),
    );
  }
}
