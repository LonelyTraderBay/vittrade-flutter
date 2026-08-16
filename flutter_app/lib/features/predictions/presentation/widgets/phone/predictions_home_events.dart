part of '../../phone/pages/hub/predictions_home_page.dart';

class _PredictionEventCard extends StatelessWidget {
  const _PredictionEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    final isMulti = event.outcomes.length > 2;
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionSmallBadge(
                label: event.category,
                color: _marketPrimary,
                background: _marketPrimary.withValues(alpha: .12),
              ),
              const Spacer(),
              Text(
                predictionsTimeRemaining(event.endDate),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          if (isMulti)
            PredictionMultiOutcomeRow(event: event)
          else
            _BinaryOutcomeBar(outcomes: outcomes),
        ],
      ),
    );
  }
}

class _BinaryOutcomeBar extends StatelessWidget {
  const _BinaryOutcomeBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    final yesColor = yes.tone.resolve();
    final noColor = no.tone.resolve();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${yes.label} ${yes.chance}%',
              style: AppTextStyles.badge.copyWith(
                color: yesColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            Text(
              '${no.label} ${no.chance}%',
              style: AppTextStyles.badge.copyWith(
                color: noColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Row(
              children: [
                Expanded(
                  flex: yes.chance,
                  child: ColoredBox(color: yesColor),
                ),
                Expanded(
                  flex: no.chance,
                  child: ColoredBox(color: noColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PredictionsEmptyState extends StatelessWidget {
  const _PredictionsEmptyState({
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onBreaking,
  });

  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onBreaking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PredictionsSpacingTokens.predictionEmptyStatePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppColors.text3.withValues(alpha: .40),
            size: PredictionsSpacingTokens.predictionHomeEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Không có sự kiện phù hợp',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thử điều chỉnh bộ lọc hoặc xem sự kiện biến động',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCtaButton(
              onPressed: onClearFilters,
              child: const Text('Xóa bộ lọc'),
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          TextButton(
            onPressed: onBreaking,
            child: Text(
              'Xem Breaking',
              style: AppTextStyles.caption.copyWith(color: _marketPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
