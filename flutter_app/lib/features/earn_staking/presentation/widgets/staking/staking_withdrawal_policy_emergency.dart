part of '../../phone/pages/staking/staking_withdrawal_policy_page.dart';

class _EmergencyTab extends StatelessWidget {
  const _EmergencyTab({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingWithdrawalPolicyPage.emergencyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.emergencyTitle,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: _stakingWithdrawalCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: _stakingWithdrawalEmergencyIconBox,
                        height: _stakingWithdrawalEmergencyIconBox,
                        child: Material(
                          color: AppColors.sell10,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.cardRadius,
                            side: BorderSide(
                              color: AppColors.sell20,
                              width: _stakingWithdrawalBorderWidth,
                            ),
                          ),
                          child: Icon(
                            Icons.emergency_rounded,
                            color: AppColors.sell,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khi nào cần rút khẩn cấp?',
                              style: AppTextStyles.baseMedium.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const Padding(
                              padding: EarnSpacingTokens.earnTopPaddingX2,
                            ),
                            Text(
                              snapshot.emergencyBody,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: _stakingWithdrawalInfoLineHeight,
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
                  for (final reason in snapshot.emergencyReasons) ...[
                    _BulletLine(text: reason, color: AppColors.sell),
                    if (reason != snapshot.emergencyReasons.last)
                      const Padding(
                        padding: EarnSpacingTokens.earnTopPaddingX2,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitPageSection(
          label: 'Quy trình Rút khẩn cấp',
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: _stakingWithdrawalCardPadding,
              child: Column(
                children: [
                  for (final step in snapshot.emergencySteps) ...[
                    _EmergencyStepRow(step: step),
                    if (step != snapshot.emergencySteps.last)
                      const Padding(
                        padding: EarnSpacingTokens.earnTopPaddingX3,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitPageSection(
          label: 'Phí Rút khẩn cấp',
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: _stakingWithdrawalCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phí rút khẩn cấp cao hơn phí rút sớm thông thường vì cần xử lý ưu tiên và bỏ qua unbonding period.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: _stakingWithdrawalInfoLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Wrap(
                    spacing: AppSpacing.x3,
                    runSpacing: AppSpacing.x3,
                    children: [
                      for (final fee in snapshot.emergencyFees)
                        _EmergencyFeeTile(fee: fee),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _WarningBox(text: snapshot.emergencyWarning),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _SupportCard(contacts: snapshot.supportContacts),
      ],
    );
  }
}

class _EmergencyStepRow extends StatelessWidget {
  const _EmergencyStepRow({required this.step});

  final StakingEmergencyStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _stakingWithdrawalEmergencyStepBox,
          height: _stakingWithdrawalEmergencyStepBox,
          child: Material(
            color: AppColors.primary12,
            shape: const CircleBorder(
              side: BorderSide(
                color: AppColors.primary20,
                width: _stakingWithdrawalBorderWidth,
              ),
            ),
            child: Center(
              child: Text(
                '${step.step}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
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
                step.text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                  height: _stakingWithdrawalEmergencyStepLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.text3,
                    size: _stakingWithdrawalTimerIcon,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    step.time,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmergencyFeeTile extends StatelessWidget {
  const _EmergencyFeeTile({required this.fee});

  final StakingEmergencyFeeDraft fee;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _stakingWithdrawalFeeTileWidth,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: _stakingWithdrawalFeeTileMinHeight,
        ),
        child: Material(
          color: AppColors.surface2,
          borderRadius: AppRadii.lgRadius,
          child: Padding(
            padding: EarnSpacingTokens.earnPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fee.product,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  fee.fee,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: _stakingWithdrawalFeeLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.contacts});

  final List<StakingSupportContactDraft> contacts;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _stakingWithdrawalCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liên hệ Support:',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final contact in contacts) ...[
            _SupportRow(contact: contact),
            if (contact != contacts.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _SupportRow extends StatelessWidget {
  const _SupportRow({required this.contact});

  final StakingSupportContactDraft contact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${contact.label}:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            contact.value,
            textAlign: TextAlign.end,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}
