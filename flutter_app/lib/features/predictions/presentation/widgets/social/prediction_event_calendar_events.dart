part of '../../phone/pages/social/prediction_event_calendar_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              label: 'Total',
              value: '${snapshot.events.length}',
            ),
          ),
          Expanded(
            child: _StatCell(
              label: 'Watching',
              value: '${snapshot.watchingCount}',
              color: _predictionPrimary,
            ),
          ),
          Expanded(
            child: _StatCell(
              label: 'This Month',
              value: '${snapshot.thisMonthCount}',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.month});

  final PredictionCalendarMonthDraft month;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: month.label,
      accentColor: _predictionPrimary,
      children: [
        for (final event in month.events) _CalendarEventCard(event: event),
      ],
    );
  }
}

class _CalendarEventCard extends StatelessWidget {
  const _CalendarEventCard({required this.event, this.urgent = false});

  final PredictionCalendarEventDraft event;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(event.status);
    final statusBg = _statusBackground(event.status);
    return VitCard(
      key: PredictionEventCalendarPage.eventKey(event.id),
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      borderColor: urgent ? AppColors.warningBorder : AppColors.border,
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.isWatching) ...[
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warn,
                  size: PredictionsSpacingTokens.predictionCalendarWatchIcon,
                ),
                const SizedBox(width: AppSpacing.x1),
              ] else if (urgent) ...[
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: PredictionsSpacingTokens.predictionCalendarUrgentIcon,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Expanded(
                child: Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Material(
                color: statusBg,
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: AppSpacing.x1,
                  ),
                  child: Text(
                    _statusLabel(event.status),
                    style: AppTextStyles.numericMicro.copyWith(
                      color: statusColor,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _EventMetric(
                  label: 'Resolution',
                  value: _shortDate(event.resolutionDate),
                ),
              ),
              Expanded(
                child: _EventMetric(
                  label: 'Probability',
                  value: '${event.probability}%',
                  valueColor: _predictionPrimary,
                ),
              ),
              Expanded(
                child: _EventMetric(
                  label: 'Volume',
                  value: _formatVolume(event.volume),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.text3,
                size: PredictionsSpacingTokens.predictionCalendarTimeIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                _daysUntil(event.resolutionDate),
                style: AppTextStyles.numericMicro.copyWith(
                  color: urgent ? AppColors.warn : AppColors.text3,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Material(
                color: AppColors.searchBg,
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: AppSpacing.x1,
                  ),
                  child: Text(
                    event.category,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: PredictionsSpacingTokens.predictionCalendarChevron,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Su kien sap dien ra',
      accentColor: _predictionPrimary,
      children: [
        for (final event in snapshot.upcomingEvents)
          _CalendarEventCard(event: event, urgent: _isUrgent(event)),
      ],
    );
  }
}
