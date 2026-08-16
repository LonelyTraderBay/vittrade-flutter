part of '../../phone/pages/savings/savings_risk_assessment_page.dart';

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.currentQuestion,
    required this.totalQuestions,
  });

  final int currentQuestion;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions <= 1
        ? 1.0
        : currentQuestion / (totalQuestions - 1);
    final percent = (progress * 100).round();

    return VitProgressBar(
      progress: progress,
      label: 'Câu hỏi ${currentQuestion + 1}/$totalQuestions',
      trailingLabel: '$percent%',
      trackColor: AppColors.surface3,
      height: AppSpacing.pageRhythmCompactInnerGap,
      gap: AppSpacing.pageRhythmStandardInnerGap,
      borderRadius: AppRadii.xlRadius,
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.index,
    required this.selectedValue,
    required this.onSelected,
    required this.onPrevious,
  });

  final SavingsRiskQuestionDraft question;
  final int index;
  final int? selectedValue;
  final void Function(SavingsRiskQuestionDraft question, int value) onSelected;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsRiskAssessmentPage.questionCardKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuestionNumber(number: index + 1),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.question, style: AppTextStyles.baseMedium),
                    if (question.helpText != null) ...[
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Text(
                        question.helpText!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: AppTextStyles.caption.height,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final option in question.options) ...[
            _RiskOptionTile(
              key: option.value == 0
                  ? SavingsRiskAssessmentPage.firstOptionKey
                  : null,
              semanticKey: SavingsRiskAssessmentPage.optionKey(
                question.id,
                option.value,
              ),
              option: option,
              selected: selectedValue == option.value,
              onTap: () => onSelected(question, option.value),
            ),
            if (option != question.options.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          if (index > 0) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCtaButton(
              key: SavingsRiskAssessmentPage.previousButtonKey,
              variant: VitCtaButtonVariant.ghost,
              height: AppSpacing.buttonCompact,
              leading: const Icon(Icons.chevron_left_rounded),
              onPressed: onPrevious,
              child: const Text('Quay lại câu trước'),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuestionNumber extends StatelessWidget {
  const _QuestionNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.primary12,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            '$number',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.primary,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskOptionTile extends StatelessWidget {
  const _RiskOptionTile({
    super.key,
    required this.semanticKey,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Key semanticKey;
  final SavingsRiskOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: semanticKey,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      onTap: onTap,
      clip: true,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      background: DecoratedBox(
        decoration: ShapeDecoration(
          color: selected ? AppColors.primary12 : AppColors.surface2,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.lgRadius,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OptionMarker(value: option.value, selected: selected),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (option.description != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    option.description!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: AppTextStyles.caption.height,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _OptionMarker extends StatelessWidget {
  const _OptionMarker({required this.value, required this.selected});

  final int value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: selected ? AppColors.primary : AppColors.surface3,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Center(
          child: Text(
            '${value + 1}',
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}
