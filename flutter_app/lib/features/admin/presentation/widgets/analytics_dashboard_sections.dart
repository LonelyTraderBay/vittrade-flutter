part of '../phone/pages/analytics_dashboard_page.dart';

class _Controls extends StatelessWidget {
  const _Controls({
    required this.ranges,
    required this.activeRange,
    required this.onRangeChanged,
  });

  final List<AdminAnalyticsRangeOption> ranges;
  final AdminAnalyticsRange activeRange;
  final ValueChanged<AdminAnalyticsRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSegmentedChoice<AdminAnalyticsRange>(
            selected: activeRange,
            onChanged: onRangeChanged,
            options: [
              for (final option in ranges)
                VitSegmentedChoiceOption(
                  key: AnalyticsDashboardPage.rangeKey(option.range),
                  value: option.range,
                  label: option.label,
                  accentColor: AppModuleAccents.admin,
                  semanticLabel: 'Khoảng thời gian ${option.label}',
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x5),
        VitIconButton(
          key: AnalyticsDashboardPage.refreshKey,
          icon: Icons.refresh_rounded,
          tooltip: 'Refresh analytics',
          onPressed: () =>
              _showComingSoon(context, 'Làm mới phân tích sẽ sớm ra mắt'),
          size: VitIconButtonSize.md,
        ),
        const SizedBox(width: AppSpacing.x3),
        VitIconButton(
          key: AnalyticsDashboardPage.exportKey,
          icon: Icons.download_rounded,
          tooltip: 'Export analytics',
          onPressed: () =>
              _showComingSoon(context, 'Xuất phân tích sẽ sớm ra mắt'),
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String message) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: message,
      ),
    );
  }
}

class _KeyMetrics extends StatelessWidget {
  const _KeyMetrics({required this.snapshot});

  final AdminAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminMetricCard(
            icon: Icons.monitor_heart_rounded,
            title: 'Tổng sự kiện',
            value: '${snapshot.totalEvents}',
            caption: snapshot.eventsPerDayLabel,
            delta: '0.0%',
            timeframe: 'Selected range',
            tint: AppColors.accent15,
            accent: AppColors.accent,
            semanticsLabel:
                'Chỉ số phân tích quản trị Tổng sự kiện: ${snapshot.totalEvents}. '
                '${snapshot.eventsPerDayLabel}. 0,0% khoảng thời gian đã chọn',
            valueStyle: AppTextStyles.sectionTitle.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: AdminMetricCard(
            icon: Icons.groups_2_outlined,
            title: 'Người dùng',
            value: '${snapshot.uniqueUsers}',
            caption: 'Unique users',
            delta: '0.0%',
            timeframe: 'Selected range',
            tint: AppColors.primary15,
            accent: AppColors.primary,
            semanticsLabel:
                'Chỉ số phân tích quản trị Người dùng: ${snapshot.uniqueUsers}. '
                'Người dùng duy nhất. 0,0% khoảng thời gian đã chọn',
            valueStyle: AppTextStyles.sectionTitle.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _EventVolumeCard extends StatelessWidget {
  const _EventVolumeCard({required this.stats});

  final List<AdminDailyStat> stats;

  @override
  Widget build(BuildContext context) {
    final hasEvents = stats.any((stat) => stat.events > 0 || stat.users > 0);
    return VitCard(
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Khối lượng sự kiện',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AdminSpacingTokens.adminAnalyticsSparklineHeight,
            child: Semantics(
              label: hasEvents
                  ? 'Biểu đồ khối lượng sự kiện ${stats.length} ngày'
                  : 'Biểu đồ khối lượng sự kiện không có dữ liệu trong khoảng này',
              child: CustomPaint(
                painter: _EventVolumePainter(stats: stats),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          if (!hasEvents) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            const AdminInlineEmptyState(
              icon: Icons.bar_chart_outlined,
              title: 'No event volume',
              message: 'The selected range has no tracked admin events yet.',
            ),
          ],
        ],
      ),
    );
  }
}

class _TopEventsCard extends StatelessWidget {
  const _TopEventsCard({required this.events});

  final List<AdminEventSummary> events;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.trending_up_rounded,
            title: 'Top sự kiện',
          ),
          if (events.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            for (final event in events)
              Text(
                event.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text1),
              ),
          ] else ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            const AdminInlineEmptyState(
              icon: Icons.trending_up_rounded,
              title: 'No top events',
              message: 'Events will rank here after tracking data arrives.',
            ),
          ],
        ],
      ),
    );
  }
}
