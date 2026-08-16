part of '../../phone/pages/merchant/p2p_kyc_requirements_page.dart';

class _KycHero extends StatelessWidget {
  const _KycHero({required this.snapshot});

  final P2PKycRequirementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycRequirementsPage.heroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pKycRequirementsCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: _p2pKycIconBoxExtent,
            height: _p2pKycIconBoxExtent,
            child: Material(
              color: AppColors.primary15,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
                side: BorderSide(color: AppColors.primary20),
              ),
              child: Center(
                child: Icon(
                  Icons.shield_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconMd,
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
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pKycReadableLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KycNotice extends StatelessWidget {
  const _KycNotice({required this.snapshot});

  final P2PKycRequirementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycRequirementsPage.noticeKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.warningBorder,
      padding: P2PSpacingTokens.p2pKycRequirementsNoticePadding,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.noticeTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.noticeBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pKycReadableLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KycTierCard extends StatelessWidget {
  const _KycTierCard({required this.tier, required this.onUpgrade});

  final P2PKycTierDraft tier;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(tier);
    return VitCard(
      key: P2PKycRequirementsPage.tierKey(tier.id),
      radius: VitCardRadius.large,
      borderColor: tier.status == P2PKycTierStatus.current
          ? color
          : AppColors.cardBorder,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: _tierHeaderBackground(tier),
            child: Padding(
              padding: P2PSpacingTokens.p2pKycRequirementsCardPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: _p2pKycIconBoxExtent,
                    height: _p2pKycIconBoxExtent,
                    child: Material(
                      color: color,
                      borderRadius: AppRadii.lgRadius,
                      child: Icon(
                        _tierIcon(tier.iconKey),
                        color: AppColors.onAccent,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.x2,
                          runSpacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Tier ${tier.id}',
                              style: AppTextStyles.pageTitle.copyWith(
                                color: color,
                                height: _p2pKycTitleLineHeight,
                              ),
                            ),
                            VitStatusPill(
                              label: tier.badge,
                              status: _tierPillStatus(tier),
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              color: AppColors.text3,
                              size: _p2pKycSmallIconExtent,
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Flexible(
                              child: Text(
                                'Xác minh trong ${tier.verificationTime}',
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
                  const SizedBox(width: AppSpacing.x2),
                  _TierStatusBadge(tier: tier),
                ],
              ),
            ),
          ),
          _TierSection(
            title: 'Yêu cầu xác minh:',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final requirement in tier.requirements) ...[
                  _RequirementRow(requirement: requirement),
                  if (requirement != tier.requirements.last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                ],
              ],
            ),
          ),
          const Divider(
            height: _p2pKycDividerExtent,
            color: AppColors.borderSolid,
          ),
          _TierSection(
            title: 'Giới hạn giao dịch:',
            child: _LimitsGrid(limits: tier.limits, color: color),
          ),
          const Divider(
            height: _p2pKycDividerExtent,
            color: AppColors.borderSolid,
          ),
          _TierSection(
            title: 'Quyền lợi:',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final benefit in tier.benefits) ...[
                  _BenefitRow(text: benefit, color: color),
                  if (benefit != tier.benefits.last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                ],
              ],
            ),
          ),
          if (onUpgrade != null)
            Padding(
              padding: P2PSpacingTokens.p2pKycRequirementsTierActionPadding,
              child: VitCtaButton(
                key: P2PKycRequirementsPage.upgradeKey(tier.id),
                variant: tier.status == P2PKycTierStatus.available
                    ? VitCtaButtonVariant.primary
                    : VitCtaButtonVariant.secondary,
                height: _p2pKycCtaHeight,
                onPressed: onUpgrade,
                trailing: const Icon(Icons.arrow_forward_rounded),
                child: Text('Nâng cấp lên Tier ${tier.id}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _TierStatusBadge extends StatelessWidget {
  const _TierStatusBadge({required this.tier});

  final P2PKycTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return switch (tier.status) {
      P2PKycTierStatus.current => const VitStatusPill(
        label: 'Đang dùng',
        status: VitStatusPillStatus.success,
        icon: Icons.check_circle_outline_rounded,
        size: VitStatusPillSize.sm,
      ),
      P2PKycTierStatus.pending => const VitStatusPill(
        label: 'Đang xét duyệt',
        status: VitStatusPillStatus.warning,
        icon: Icons.schedule_rounded,
        size: VitStatusPillSize.sm,
      ),
      P2PKycTierStatus.locked => const VitStatusPill(
        label: 'Chưa mở',
        status: VitStatusPillStatus.neutral,
        icon: Icons.lock_outline_rounded,
        size: VitStatusPillSize.sm,
      ),
      P2PKycTierStatus.available => const SizedBox.shrink(),
    };
  }
}

class _TierSection extends StatelessWidget {
  const _TierSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pKycRequirementsTierSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          child,
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.requirement});

  final P2PKycRequirementDraft requirement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _p2pKycRequirementIconBoxExtent,
          height: _p2pKycRequirementIconBoxExtent,
          child: Material(
            color: AppColors.surface2,
            borderRadius: AppRadii.smRadius,
            child: Icon(
              _requirementIcon(requirement.iconKey),
              color: AppColors.text2,
              size: _p2pKycChecklistIconExtent,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            requirement.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}
