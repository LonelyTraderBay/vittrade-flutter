part of '../../phone/pages/staking/staking_insurance_page.dart';

class _ClaimsTab extends StatelessWidget {
  const _ClaimsTab({required this.snapshot, required this.onFileClaim});

  final StakingInsuranceSnapshot snapshot;
  final VoidCallback onFileClaim;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingInsurancePage.claimsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Claim History', style: AppTextStyles.baseMedium),
            ),
            VitCtaButton(
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: EarnSpacingTokens.earnHorizontalPaddingX4,
              onPressed: onFileClaim,
              child: const Text('File Claim'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final claim in snapshot.claims) ...[
          _ClaimCard(claim: claim),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claim});

  final StakingInsuranceClaimDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.claimKey(claim.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(claim.position, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${claim.date} · ${claim.reason}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const VitStatusPill(
                label: 'Approved',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _ClaimMetric(
                  label: 'Loss',
                  value: '-\$${claim.loss.toStringAsFixed(2)}',
                  color: AppColors.sell,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ClaimMetric(
                  label: 'Coverage',
                  value: '${claim.coverage}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ClaimMetric(
                  label: 'Payout',
                  value: '+\$${claim.payout.toStringAsFixed(2)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClaimMetric extends StatelessWidget {
  const _ClaimMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnPaddingX2,
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
