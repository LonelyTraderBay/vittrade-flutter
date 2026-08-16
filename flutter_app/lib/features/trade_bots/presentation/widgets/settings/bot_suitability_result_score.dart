part of '../../phone/pages/settings/bot_suitability_assessment_page.dart';

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.score,
    required this.answers,
    required this.onComplete,
  });

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final int score;
  final Map<String, String> answers;
  final ValueChanged<TradeBotSuitabilityOutcomeCopy> onComplete;

  @override
  Widget build(BuildContext context) {
    final maxScore = snapshot.maxScore;
    final percent = maxScore == 0 ? 0.0 : score / maxScore;
    final result = _resultForPercent(percent);
    final color = _colorForResult(result.outcome);

    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        Center(
          child: CircleAvatar(
            radius: AppSpacing.buttonCompact / 2,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(
              _iconForResult(result.outcome),
              color: color,
              size: AppSpacing.inputPrefixIcon,
            ),
          ),
        ),
        Text(
          result.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: color),
        ),
        Text(
          result.message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
        _ScoreCard(
          score: score,
          maxScore: maxScore,
          percent: percent,
          color: color,
        ),
        const VitSectionHeader(
          title: 'Chi tiết theo hạng mục',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.plain,
        ),
        _CategoryBreakdown(snapshot: snapshot, answers: answers),
        const VitSectionHeader(
          title: 'Khuyến nghị',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.plain,
        ),
        _RecommendationsCard(result: result, color: color),
        _RegulatoryCard(snapshot: snapshot),
        VitCtaButton(
          key: BotSuitabilityAssessmentPage.resultCtaKey,
          onPressed: () => onComplete(result),
          density: VitDensity.tool,
          variant: result.outcome == TradeBotSuitabilityOutcome.fail
              ? VitCtaButtonVariant.danger
              : VitCtaButtonVariant.success,
          child: Text(
            result.ctaLabel,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }

  TradeBotSuitabilityOutcomeCopy _resultForPercent(double percent) {
    if (percent >= .75) return snapshot.pass;
    if (percent >= .50) return snapshot.warning;
    return snapshot.fail;
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.score,
    required this.maxScore,
    required this.percent,
    required this.color,
  });

  final int score;
  final int maxScore;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _ResultCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm của bạn',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '$score / $maxScore',
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
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
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            '${(percent * 100).toStringAsFixed(0)}% thành thạo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
