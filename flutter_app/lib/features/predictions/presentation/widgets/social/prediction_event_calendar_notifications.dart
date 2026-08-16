part of '../../phone/pages/social/prediction_event_calendar_page.dart';

class _NotificationSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const settings = [
      (
        label: 'Resolution Reminder',
        desc: 'Thong bao truoc khi su kien chot ket qua',
      ),
      (label: 'Price Alert', desc: 'Canh bao khi xac suat thay doi lon'),
      (
        label: 'New Events',
        desc: 'Thong bao su kien moi theo danh muc quan tam',
      ),
    ];
    return VitPageSection(
      label: 'Cai dat thong bao',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              for (var i = 0; i < settings.length; i += 1)
                _NotificationSettingRow(
                  label: settings[i].label,
                  description: settings[i].desc,
                  showDivider: i < settings.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WatchingSection extends StatelessWidget {
  const _WatchingSection({required this.snapshot});

  final PredictionEventCalendarSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dang theo doi',
      accentColor: _predictionPrimary,
      children: [
        for (final event in snapshot.watchingEvents)
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warn,
                      size: PredictionsSpacingTokens
                          .predictionCalendarWatchingIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x2,
                    vertical: AppSpacing.x1,
                  ),
                  child: Text(
                    event.category,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
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
                        label: 'Notify Before',
                        value: event.notifyBefore ?? 'Not set',
                        valueColor: _predictionPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                SizedBox(
                  height: VitDensity.compact.controlHeight,
                  width: double.infinity,
                  child: Material(
                    color: AppColors.bg,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.border),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.text1,
                          size: PredictionsSpacingTokens
                              .predictionCalendarEditIcon,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          'Chinh sua thong bao',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NotificationInfo extends StatelessWidget {
  const _NotificationInfo();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary15,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: PredictionsSpacingTokens.predictionCalendarInfoIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Thong bao giup ban khong bo lo su kien quan trong. Ban se nhan canh bao qua app va email.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingRow extends StatelessWidget {
  const _NotificationSettingRow({
    required this.label,
    required this.description,
    required this.showDivider,
  });

  final String label;
  final String description;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitTogglePill(
                enabled: true,
                activeColor: _predictionPrimary,
                width: VitDensity.compact.controlHeight,
                height: VitDensity.compact.controlHeight - AppSpacing.x3,
                knobSize: VitDensity.compact.controlHeight - AppSpacing.x4,
                knobMargin: const EdgeInsetsDirectional.all(
                  AppSpacing.dividerHairline * 2,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: AppSpacing.dividerHairline,
              child: ColoredBox(color: AppColors.border),
            ),
          ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.amountSm.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EventMetric extends StatelessWidget {
  const _EventMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

bool _isUrgent(PredictionCalendarEventDraft event) {
  final days = event.resolutionDate
      .difference(DateTime.utc(2026, 5, 20))
      .inDays;
  return days >= 0 && days <= 7;
}

Color _statusColor(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => AppColors.buy,
    PredictionCalendarEventStatus.upcoming => AppColors.warn,
    PredictionCalendarEventStatus.resolving => _predictionPrimary,
    PredictionCalendarEventStatus.resolved => AppColors.text3,
  };
}

Color _statusBackground(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => AppColors.buy10,
    PredictionCalendarEventStatus.upcoming => AppColors.warn10,
    PredictionCalendarEventStatus.resolving => AppColors.primary08,
    PredictionCalendarEventStatus.resolved => AppColors.text3.withValues(
      alpha: .08,
    ),
  };
}

String _statusLabel(PredictionCalendarEventStatus status) {
  return switch (status) {
    PredictionCalendarEventStatus.active => 'ACTIVE',
    PredictionCalendarEventStatus.upcoming => 'UPCOMING',
    PredictionCalendarEventStatus.resolving => 'RESOLVING',
    PredictionCalendarEventStatus.resolved => 'RESOLVED',
  };
}

String _shortDate(DateTime date) {
  const months = [
    'thg 1',
    'thg 2',
    'thg 3',
    'thg 4',
    'thg 5',
    'thg 6',
    'thg 7',
    'thg 8',
    'thg 9',
    'thg 10',
    'thg 11',
    'thg 12',
  ];
  return '${date.day} ${months[date.month - 1]}';
}

String _daysUntil(DateTime date) {
  final days = date.difference(DateTime.utc(2026, 5, 20)).inDays;
  if (days < 0) return 'Da qua';
  if (days == 0) return 'Hom nay';
  if (days == 1) return '1 ngay';
  if (days < 30) return '$days ngay';
  return '${days ~/ 30} thang';
}

String _formatVolume(double value) =>
    '\$${(value / 1000000).toStringAsFixed(1)}M';
