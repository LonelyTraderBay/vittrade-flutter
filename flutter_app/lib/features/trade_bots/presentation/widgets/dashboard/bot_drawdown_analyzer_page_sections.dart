part of '../../phone/pages/dashboard/bot_drawdown_analyzer_page.dart';

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.summary});

  final TradeBotDrawdownSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.trending_down_rounded,
                iconColor: _drawdownRed,
                label: 'Sụt giảm vốn tối đa',
                value: '${summary.maxDrawdownPct.toStringAsFixed(1)}%',
                valueColor: _drawdownRed,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _MetricCard(
                icon: Icons.bar_chart_rounded,
                iconColor: _drawdownAmber,
                label: 'Sụt giảm vốn trung bình',
                value: '${summary.avgDrawdownPct.toStringAsFixed(1)}%',
                valueColor: _drawdownAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.schedule_rounded,
                iconColor: _drawdownPrimary,
                label: 'Ngày sụt giảm vốn',
                value: summary.drawdownDays.toString(),
                caption: 'trong ${summary.totalDays} ngày',
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _MetricCard(
                icon: Icons.report_problem_outlined,
                iconColor: _drawdownGreen,
                label: 'Tần suất sụt giảm',
                value: summary.frequency.toString(),
                caption: 'lần',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.caption,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactPanelPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.formFieldLabelGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              caption!,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _UnderwaterCard extends StatelessWidget {
  const _UnderwaterCard({required this.points});

  final List<TradeBotUnderwaterPoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: _drawdownUnderwaterExtent,
            child: CustomPaint(
              painter: _UnderwaterPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Dưới mức 0 là đang trong giai đoạn sụt giảm vốn (âm)',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({required this.buckets});

  final List<TradeBotDrawdownDurationBucket> buckets;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: SizedBox(
        height: _drawdownDurationExtent,
        child: CustomPaint(
          painter: _DurationPainter(buckets),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  const _EventsList({required this.events});

  final List<TradeBotDrawdownEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final event in events) ...[
          _EventCard(event: event),
          if (event != events.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final TradeBotDrawdownEvent event;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Sự kiện #${event.id}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (event.severe)
                      const VitAccentPill(
                        label: 'Nghiêm trọng',
                        accentColor: _drawdownRed,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${event.depthPct.toStringAsFixed(1)}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _drawdownRed,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _EventStat(label: 'Start', value: event.startLabel),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _EventStat(label: 'Duration', value: event.duration),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _EventStat(
                  label: 'Recovery',
                  value: event.recovery,
                  valueColor: event.recovery == 'Ongoing'
                      ? _drawdownAmber
                      : _drawdownGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventStat extends StatelessWidget {
  const _EventStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactPanelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.formFieldLabelGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
