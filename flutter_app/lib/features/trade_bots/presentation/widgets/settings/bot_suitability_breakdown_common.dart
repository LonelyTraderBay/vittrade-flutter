part of '../../phone/pages/settings/bot_suitability_assessment_page.dart';

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.snapshot, required this.answers});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final Map<String, String> answers;

  @override
  Widget build(BuildContext context) {
    final categories = TradeBotSuitabilityCategory.values;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      childAspectRatio: TradeSpacingTokens.tradeBotGridAspectRatio,
      children: [
        for (final category in categories)
          _CategoryScoreCard(
            label: _categoryLabel(category),
            score: _categoryScore(category),
            maxScore: _categoryMaxScore(category),
          ),
      ],
    );
  }

  int _categoryScore(TradeBotSuitabilityCategory category) {
    var score = 0;
    for (final question in snapshot.questions.where(
      (q) => q.category == category,
    )) {
      final answer = answers[question.id];
      if (answer == null) continue;
      score += question.options.firstWhere((o) => o.id == answer).score;
    }
    return score;
  }

  int _categoryMaxScore(TradeBotSuitabilityCategory category) {
    return snapshot.questions.where((q) => q.category == category).length * 3;
  }
}

class _CategoryScoreCard extends StatelessWidget {
  const _CategoryScoreCard({
    required this.label,
    required this.score,
    required this.maxScore,
  });

  final String label;
  final int score;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    final percent = maxScore == 0 ? 0.0 : score / maxScore;
    final color = percent >= .75
        ? _assessmentGreen
        : percent >= .50
        ? _assessmentAmber
        : _assessmentRed;

    return _ResultCard(
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            '$score/$maxScore',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: percent,
              minHeight: AppSpacing.x1,
              backgroundColor: _assessmentPanel2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({required this.result, required this.color});

  final TradeBotSuitabilityOutcomeCopy result;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _ResultCard(
      child: Column(
        children: [
          for (final recommendation in result.recommendations) ...[
            _RecommendationRow(
              text: recommendation,
              color: color,
              icon: _iconForResult(result.outcome),
            ),
            if (recommendation != result.recommendations.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow({
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: AppSpacing.x3),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _RegulatoryCard extends StatelessWidget {
  const _RegulatoryCard({required this.snapshot});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.tool,
        children: [
          Text(
            snapshot.regulatoryTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            snapshot.regulatoryDescription,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.child,
    this.padding = AppSpacing.cardPaddingCompact,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

Color _colorForResult(TradeBotSuitabilityOutcome outcome) {
  return switch (outcome) {
    TradeBotSuitabilityOutcome.pass => _assessmentGreen,
    TradeBotSuitabilityOutcome.warning => _assessmentAmber,
    TradeBotSuitabilityOutcome.fail => _assessmentRed,
  };
}

IconData _iconForResult(TradeBotSuitabilityOutcome outcome) {
  return switch (outcome) {
    TradeBotSuitabilityOutcome.pass => Icons.check_circle_outline_rounded,
    TradeBotSuitabilityOutcome.warning => Icons.warning_amber_rounded,
    TradeBotSuitabilityOutcome.fail => Icons.cancel_outlined,
  };
}

String _categoryLabel(TradeBotSuitabilityCategory category) {
  final name = category.name;
  return '${name.substring(0, 1).toUpperCase()}${name.substring(1)}';
}
