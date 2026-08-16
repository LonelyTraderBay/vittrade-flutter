part of '../phone/pages/admin_home_page.dart';

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<AdminMetricTile> metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < metrics.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.x4),
          Expanded(child: _MetricCard(metric: metrics[i])),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final AdminMetricTile metric;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(metric.accent);
    return Semantics(
      label:
          'Chỉ số trang chủ quản trị ${metric.label}: ${metric.value}. ${metric.deltaLabel} ${metric.timeframeLabel}',
      child: VitCard(
        padding: AdminSpacingTokens.adminCompactPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _metricIcon(metric.icon),
                  color: accent,
                  size: AdminSpacingTokens.adminIconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    metric.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              metric.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.amountSm.copyWith(
                color: metric.label == 'Health'
                    ? AppColors.buy
                    : AppColors.text1,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x1,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                VitStatusPill(
                  label: metric.deltaLabel,
                  status: metric.deltaLabel.startsWith('-')
                      ? VitStatusPillStatus.error
                      : VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
                Text(
                  metric.timeframeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RealTimeMetricsSection extends StatelessWidget {
  const _RealTimeMetricsSection({
    required this.snapshot,
    required this.isLive,
    required this.onToggleLive,
  });

  final AdminHomeSnapshot snapshot;
  final bool isLive;
  final VoidCallback onToggleLive;

  @override
  Widget build(BuildContext context) {
    final metrics = snapshot.adminMetrics;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Real-Time Metrics',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.text1,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        Row(
          children: [
            const _LiveDot(),
            const SizedBox(width: AppSpacing.x2),
            Text(
              isLive ? 'LIVE' : 'PAUSED',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const Spacer(),
            _PauseButton(isLive: isLive, onPressed: onToggleLive),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _MetricGrid(metrics: snapshot.liveStats),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          padding: AdminSpacingTokens.adminCardPadding,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.offline_bolt_rounded,
                    color: AppColors.text1,
                    size: AdminSpacingTokens.adminIconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Live Event Stream',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    metrics.liveEventWindowLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                'Không có sự kiện mới',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.text3,
              size: AdminSpacingTokens.adminIconXs,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Cập nhật lúc ${metrics.lastUpdatedTime}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSpacing.x3,
      height: AppSpacing.x3,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.buy,
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({required this.isLive, required this.onPressed});

  final bool isLive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isLive
          ? 'Tạm dừng cập nhật trực tiếp quản trị'
          : 'Tiếp tục cập nhật trực tiếp quản trị',
      child: Material(
        key: AdminHomePage.pauseKey,
        color: AppColors.surface3,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadii.inputRadius,
          child: Padding(
            padding: AdminSpacingTokens.adminSegmentButtonPadding,
            child: Text(
              isLive ? 'Tạm dừng' : 'Tiếp tục',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
