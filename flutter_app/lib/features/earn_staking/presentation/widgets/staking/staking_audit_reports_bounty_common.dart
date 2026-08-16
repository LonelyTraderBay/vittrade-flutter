part of '../../phone/pages/staking/staking_audit_reports_page.dart';

class _BugBountySection extends StatelessWidget {
  const _BugBountySection({required this.bugBounty, required this.onOpen});

  final StakingBugBountyDraft bugBounty;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Bug Bounty Program',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingAuditReportsPage.bugBountyKey,
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _RoundIcon(
                    icon: Icons.shield_outlined,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bugBounty.title, style: AppTextStyles.baseMedium),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          bugBounty.subtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                bugBounty.body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingAuditBodyLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              VitCard(
                variant: VitCardVariant.inner,
                padding: EarnSpacingTokens.earnCardPaddingX3,
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      EarnSpacingTokens.stakingAuditPayoutGridColumns,
                  childAspectRatio:
                      EarnSpacingTokens.stakingAuditPayoutGridAspect,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x2,
                  children: [
                    for (final payout in bugBounty.payouts)
                      _PayoutItem(payout: payout),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _ActionButton(
                key: StakingAuditReportsPage.bugBountyCtaKey,
                label: 'View on Immunefi',
                icon: Icons.open_in_new_rounded,
                primary: true,
                onTap: onOpen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PayoutItem extends StatelessWidget {
  const _PayoutItem({required this.payout});

  final StakingBugBountyPayoutDraft payout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          payout.severity,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          payout.amount,
          style: AppTextStyles.baseMedium.copyWith(
            color: _toneColor(payout.tone),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: primary
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      fullWidth: true,
      leading: Icon(icon),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: VitRiskDisclaimerNote(
        message: text,
        height: EarnSpacingTokens.stakingAuditFooterLineHeight,
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.25)),
          borderRadius: AppRadii.xlRadius,
        ),
      ),
      child: SizedBox(
        width: EarnSpacingTokens.stakingAuditRoundIconBox,
        height: EarnSpacingTokens.stakingAuditRoundIconBox,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

String _typeId(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => 'smart-contract',
    StakingAuditReportType.financial => 'financial',
    StakingAuditReportType.security => 'security',
  };
}

String _reportTypeLabel(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => 'Smart Contract',
    StakingAuditReportType.financial => 'Financial',
    StakingAuditReportType.security => 'Security',
  };
}

Color _reportTypeColor(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => AppColors.accent,
    StakingAuditReportType.financial => AppColors.buy,
    StakingAuditReportType.security => AppColors.warn,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}
