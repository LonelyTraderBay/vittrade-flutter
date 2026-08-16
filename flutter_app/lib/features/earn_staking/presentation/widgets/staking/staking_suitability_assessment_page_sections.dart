part of '../../phone/pages/staking/staking_suitability_assessment_page.dart';

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (current + 1) / total;
    return VitProgressBar(
      key: StakingSuitabilityAssessmentPage.progressKey,
      progress: progress,
      label: 'Question ${current + 1} of $total',
      trailingLabel: '${(progress * 100).round()}%',
      trackColor: AppColors.surface3,
      height: AppSpacing.pageRhythmCompactInnerGap,
      gap: AppSpacing.pageRhythmCompactInnerGap,
      borderRadius: AppRadii.xlRadius,
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selected,
    required this.quizAnswers,
    required this.onSelect,
    required this.onQuizSelect,
  });

  final StakingSuitabilityQuestionDraft question;
  final int? selected;
  final Map<int, int> quizAnswers;
  final void Function(String questionId, int value) onSelect;
  final void Function(int questionIndex, int optionIndex) onQuizSelect;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSuitabilityAssessmentPage.questionCardKey,
      radius: VitCardRadius.large,
      padding: _stakingSuitabilityCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.question,
            style: AppTextStyles.sectionTitleXs.copyWith(
              height: _stakingSuitabilityQuestionLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          if (question.type == StakingSuitabilityQuestionType.single)
            for (var i = 0; i < question.options.length; i++) ...[
              _OptionTile(
                key: StakingSuitabilityAssessmentPage.optionKey(question.id, i),
                label: question.options[i].label,
                selected: selected == i,
                onTap: () => onSelect(question.id, i),
              ),
              if (i != question.options.length - 1)
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            ]
          else if (question.type == StakingSuitabilityQuestionType.slider)
            _SliderQuestion(
              question: question,
              value: selected ?? question.min ?? 1,
              onChanged: (value) => onSelect(question.id, value),
            )
          else
            for (var q = 0; q < question.quizQuestions.length; q++) ...[
              _QuizQuestion(
                index: q,
                quiz: question.quizQuestions[q],
                selected: quizAnswers[q],
                onSelect: (option) => onQuizSelect(q, option),
              ),
              if (q != question.quizQuestions.length - 1)
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: selected ? AppColors.primary : null,
      padding: _stakingSuitabilityOptionPadding,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.primary : AppColors.primary30,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.text1,
                height: _stakingSuitabilityOptionLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderQuestion extends StatelessWidget {
  const _SliderQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final StakingSuitabilityQuestionDraft question;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Conservative',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Aggressive',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ),
          ],
        ),
        Slider(
          min: (question.min ?? 1).toDouble(),
          max: (question.max ?? 10).toDouble(),
          divisions: ((question.max ?? 10) - (question.min ?? 1)),
          value: value.toDouble(),
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface3,
          onChanged: (next) => onChanged(next.round()),
        ),
        Text(
          '$value',
          style: AppTextStyles.heroNumber.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}

class _QuizQuestion extends StatelessWidget {
  const _QuizQuestion({
    required this.index,
    required this.quiz,
    required this.selected,
    required this.onSelect,
  });

  final int index;
  final StakingSuitabilityQuizDraft quiz;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingSuitabilityCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${index + 1}. ${quiz.question}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var i = 0; i < quiz.options.length; i++) ...[
            _QuizOption(
              key: StakingSuitabilityAssessmentPage.quizOptionKey(index, i),
              label: quiz.options[i],
              selected: selected == i,
              onTap: () => onSelect(i),
            ),
            if (i != quiz.options.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: selected ? AppColors.primary : null,
      padding: _stakingSuitabilityOptionPadding,
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: selected ? AppColors.primary : AppColors.text2,
          fontWeight: selected ? AppTextStyles.bold : AppTextStyles.normal,
        ),
      ),
    );
  }
}
