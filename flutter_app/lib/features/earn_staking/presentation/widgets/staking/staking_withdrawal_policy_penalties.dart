part of '../../phone/pages/staking/staking_withdrawal_policy_page.dart';

class _PenaltiesTab extends StatelessWidget {
  const _PenaltiesTab({required this.snapshot, required this.onOpenCalculator});

  final StakingWithdrawalPolicySnapshot snapshot;
  final VoidCallback onOpenCalculator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.penaltyTitle,
          density: VitDensity.compact,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: _stakingWithdrawalCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.penaltyBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: _stakingWithdrawalPenaltyBodyLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Material(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.lgRadius,
                    child: Padding(
                      padding: _stakingWithdrawalCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.cancel_outlined,
                                color: AppColors.sell,
                                size: _stakingWithdrawalFormulaIcon,
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              Expanded(
                                child: Text(
                                  'Công thức Phí rút sớm:',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EarnSpacingTokens.earnTopPaddingX3,
                          ),
                          for (final rule in snapshot.penaltyRules) ...[
                            _BulletLine(
                              text: rule.label,
                              color: _toneColor(rule.tone),
                            ),
                            if (rule != snapshot.penaltyRules.last)
                              const Padding(
                                padding: EarnSpacingTokens.earnTopPaddingX2,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitPageSection(
          label: 'Ví dụ Tính toán',
          children: [
            for (final example in snapshot.penaltyExamples)
              _PenaltyExampleCard(example: example),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCtaButton(
          key: StakingWithdrawalPolicyPage.calculatorCtaKey,
          onPressed: onOpenCalculator,
          leading: const Icon(Icons.calculate_rounded),
          child: Text(snapshot.calculatorCta),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _NoteCard(
          text:
              'Số lượng gốc không bị ảnh hưởng. Chỉ phần thưởng staking bị phạt; bạn luôn nhận lại 100% số tiền gốc đã stake.',
        ),
      ],
    );
  }
}

class _PenaltyExampleCard extends StatelessWidget {
  const _PenaltyExampleCard({required this.example});

  final StakingWithdrawalPenaltyExampleDraft example;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Material(
            color: AppColors.surface2,
            borderRadius: AppRadii.lgRadius,
            child: Padding(
              padding: EarnSpacingTokens.earnPaddingX3,
              child: Column(
                children: [
                  for (final row in example.rows) ...[
                    if (row.label.startsWith('Phí'))
                      const Divider(color: AppColors.divider),
                    _CalculationRow(row: row),
                    if (row != example.rows.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
