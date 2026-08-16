part of '../../phone/pages/staking/staking_regulatory_framework_page.dart';

class _ProtectionTab extends StatelessWidget {
  const _ProtectionTab({required this.snapshot});

  final StakingRegulatoryFrameworkSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRegulatoryFrameworkPage.protectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Investor Protection Schemes',
          accentColor: AppColors.primarySoft,
          children: [
            Column(
              children: [
                for (final scheme in snapshot.protectionSchemes) ...[
                  _ProtectionCard(scheme: scheme),
                  if (scheme != snapshot.protectionSchemes.last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _WarningNote(text: snapshot.protectionWarning),
      ],
    );
  }
}

class _ProtectionCard extends StatelessWidget {
  const _ProtectionCard({required this.scheme});

  final StakingProtectionSchemeDraft scheme;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _RoundIcon(
                icon: Icons.shield_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scheme.jurisdiction, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      scheme.scheme,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                scheme.coverage,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: EarnSpacingTokens.earnCardPaddingX3,
            child: Text(
              scheme.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppTextStyles.caption.height,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Eligibility: ${scheme.eligibility}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppTextStyles.micro.height,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintsTab extends StatelessWidget {
  const _ComplaintsTab({required this.snapshot});

  final StakingRegulatoryFrameworkSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRegulatoryFrameworkPage.complaintsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Complaint Handling Process',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'How to File a Complaint',
                    style: AppTextStyles.baseMedium,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  for (final step in snapshot.complaintSteps) ...[
                    _ComplaintStep(step: step),
                    if (step != snapshot.complaintSteps.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitPageSection(
          label: 'Regulatory Authority Contacts',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX3,
              child: Column(
                children: [
                  for (final contact in snapshot.authorityContacts) ...[
                    _AuthorityContact(contact: contact),
                    if (contact != snapshot.authorityContacts.last)
                      const Divider(
                        color: AppColors.divider,
                        height: AppSpacing.dividerHairline,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComplaintStep extends StatelessWidget {
  const _ComplaintStep({required this.step});

  final StakingComplaintStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.primary,
            shape: CircleBorder(),
          ),
          child: SizedBox(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            child: Center(
              child: Text(
                '${step.step}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
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
              Text(
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: AppTextStyles.caption.height,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.action,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthorityContact extends StatelessWidget {
  const _AuthorityContact({required this.contact});

  final StakingAuthorityContactDraft contact;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contact.email,
            style: AppTextStyles.micro.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contact.phone,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
