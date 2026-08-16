part of '../../phone/pages/staking/staking_proof_of_reserves_page.dart';

class _VerifyTab extends StatelessWidget {
  const _VerifyTab({required this.snapshot, required this.onVerify});

  final StakingProofOfReservesSnapshot snapshot;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingProofOfReservesPage.verifyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Verify Your Balance',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnPaddingX4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox.square(
                        dimension: VitDensity.compact.controlHeight,
                        child: const Material(
                          color: AppColors.primary12,
                          borderRadius: AppRadii.lgRadius,
                          child: Icon(
                            Icons.visibility_outlined,
                            color: AppColors.primarySoft,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Merkle Tree Verification',
                              style: AppTextStyles.baseMedium,
                            ),
                            const Padding(
                              padding: EarnSpacingTokens.earnTopPaddingX2,
                            ),
                            Text(
                              'Prove your staked balance is included in our Proof of Reserves using cryptographic Merkle tree proofs.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    onPressed: onVerify,
                    leading: const Icon(Icons.verified_user_outlined),
                    child: const Text('Verify My Balance'),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'How Verification Works',
          accentColor: AppColors.primarySoft,
          children: [
            for (final step in snapshot.verifySteps)
              _VerificationStepCard(step: step),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.privacyNote,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerificationStepCard extends StatelessWidget {
  const _VerificationStepCard({required this.step});

  final StakingReserveVerifyStepDraft step;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            child: Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: Center(
                child: Text(
                  step.step.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
