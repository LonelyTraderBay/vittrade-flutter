part of '../../phone/pages/staking/staking_institutional_page.dart';

class _AuthorizedSigners extends StatelessWidget {
  const _AuthorizedSigners({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInstitutionalPage.signersKey,
      label: 'Authorized Signers',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            children: [
              for (var i = 0; i < snapshot.signers.length; i++) ...[
                if (i > 0) const Divider(color: AppColors.borderSolid),
                _SignerRow(signer: snapshot.signers[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final StakingInstitutionalSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    final approved = signer.status == StakingInstitutionalSignerStatus.approved;
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX1,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(signer.name, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${signer.role} - ${signer.address}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Icon(
            approved
                ? Icons.check_circle_outline_rounded
                : Icons.schedule_rounded,
            color: approved ? AppColors.buy : AppColors.warn,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _EnterpriseFeatures extends StatelessWidget {
  const _EnterpriseFeatures({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInstitutionalPage.featuresKey,
      label: 'Enterprise Features',
      accentColor: AppColors.primarySoft,
      children: [
        GridView.builder(
          itemCount: snapshot.features.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: EarnSpacingTokens.stakingProductGridColumns,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio:
                EarnSpacingTokens.stakingProductInstitutionalFeatureAspect,
          ),
          itemBuilder: (context, index) =>
              _FeatureCard(feature: snapshot.features[index]),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final StakingInstitutionalFeatureDraft feature;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _infoIcon(feature.icon),
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const Spacer(),
          Text(
            feature.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            feature.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.complianceKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.complianceTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.complianceBody,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
