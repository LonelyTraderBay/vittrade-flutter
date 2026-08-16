part of '../../phone/pages/staking/staking_regulatory_framework_page.dart';

class _LicenseDetailSheet extends StatelessWidget {
  const _LicenseDetailSheet({required this.license});

  final StakingLicenseDraft license;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                license.jurisdiction,
                style: AppTextStyles.sectionTitle,
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Regulator',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  VitStatusPill(
                    label: _statusLabel(license.status),
                    status: _licenseVitStatus(license.status),
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(license.regulator, style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _SheetRow(label: 'License Number', value: license.licenseNumber),
              _SheetRow(label: 'Issued Date', value: license.issuedDate),
              if (license.expiryDate != null)
                _SheetRow(label: 'Expiry Date', value: license.expiryDate!),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Text(
          'Authorized Scope',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final scope in license.scope) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  scope,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppTextStyles.caption.height,
                  ),
                ),
              ),
            ],
          ),
          if (scope != license.scope.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          key: StakingRegulatoryFrameworkPage.detailCtaKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
          trailing: const Icon(Icons.open_in_new_rounded),
          child: Text('Verify on ${license.website}'),
        ),
      ],
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnTopPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primarySoft, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppTextStyles.micro.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppTextStyles.micro.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRegulatoryFrameworkPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: VitRiskDisclaimerNote(message: text),
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
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.buttonCompact,
        height: AppSpacing.buttonCompact,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

String _statusLabel(StakingLicenseStatus status) {
  return switch (status) {
    StakingLicenseStatus.active => 'Active',
    StakingLicenseStatus.pending => 'Pending',
    StakingLicenseStatus.expired => 'Expired',
  };
}

VitStatusPillStatus _licenseVitStatus(StakingLicenseStatus status) {
  return switch (status) {
    StakingLicenseStatus.active => VitStatusPillStatus.success,
    StakingLicenseStatus.pending => VitStatusPillStatus.warning,
    StakingLicenseStatus.expired => VitStatusPillStatus.error,
  };
}
