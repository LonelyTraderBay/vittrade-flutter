part of '../../phone/pages/settings/bot_suitability_assessment_page.dart';

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.snapshot,
    required this.currentQuestion,
    required this.answers,
    required this.onAnswer,
  });

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final int currentQuestion;
  final Map<String, String> answers;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    final question = snapshot.questions[currentQuestion];
    final totalQuestions = snapshot.questions.length;
    final progress = answers.length / totalQuestions;
    final selected = answers[question.id];

    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        VitProgressBar(
          label: 'Question ${currentQuestion + 1} of $totalQuestions',
          trailingLabel: '${(progress * 100).toStringAsFixed(0)}% Complete',
          progress: progress,
          color: _assessmentPrimary,
          trackColor: _assessmentPanel2,
          height: AppSpacing.x1,
        ),
        _QuestionHeader(question: question),
        for (final option in question.options) ...[
          _OptionCard(
            questionId: question.id,
            option: option,
            selected: selected == option.id,
            onTap: () => onAnswer(option.id),
          ),
          if (option != question.options.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        _InfoCard(snapshot: snapshot),
      ],
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({required this.question});

  final TradeBotSuitabilityQuestion question;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        VitCard(
          radius: VitCardRadius.tight,
          width: AppSpacing.buttonCompact,
          height: AppSpacing.buttonCompact,
          alignment: Alignment.center,
          variant: VitCardVariant.inner,
          borderColor: _assessmentPrimary.withValues(alpha: .22),
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: _assessmentPrimary,
            size: AppSpacing.inputPrefixIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.category.name.toUpperCase(),
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                question.question,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.questionId,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final String questionId;
  final TradeBotSuitabilityOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotSuitabilityAssessmentPage.optionKey(questionId, option.id),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: selected ? _assessmentPrimary : _assessmentOptionBorder,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? _assessmentPrimary : _assessmentOptionBorder,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Text(
              option.text,
              style: AppTextStyles.caption.copyWith(
                color: selected ? _assessmentPrimary : AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.snapshot});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      key: BotSuitabilityAssessmentPage.infoKey,
      state: VitHighRiskUiState.riskReview,
      density: VitDensity.tool,
      title: snapshot.infoTitle,
      message: snapshot.infoDescription,
    );
  }
}
