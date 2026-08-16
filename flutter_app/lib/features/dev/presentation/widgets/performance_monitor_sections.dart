part of '../phone/pages/performance_monitor.dart';

class _PerformanceScoreCard extends StatelessWidget {
  const _PerformanceScoreCard({required this.snapshot});

  final PerformanceMonitorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _IconBadge(
                icon: Icons.monitor_heart_outlined,
                color: AppColors.primary,
                background: AppColors.primary12,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Score',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      snapshot.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitStatsGrid(
            padding: EdgeInsets.zero,
            gap: AppSpacing.x3,
            cellBackground: true,
            cells: [
              for (final metric in snapshot.summaryMetrics)
                VitStatCell(
                  label: metric.label,
                  value: metric.value,
                  valueColor: _toneColor(metric.tone),
                  valueStyle: AppTextStyles.amountXs,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalsCard extends StatelessWidget {
  const _VitalsCard({required this.metrics});

  final List<PerformanceVitalMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          for (final metric in metrics) ...[
            _VitalRow(metric: metric),
            if (metric != metrics.last) const _Divider(),
          ],
        ],
      ),
    );
  }
}

class _VitalRow extends StatelessWidget {
  const _VitalRow({required this.metric});

  final PerformanceVitalMetric metric;

  @override
  Widget build(BuildContext context) {
    final toneColor = _toneColor(metric.tone);

    return Padding(
      padding: AdminSpacingTokens.devVerticalPaddingX2,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                metric.value,
                style: AppTextStyles.caption.copyWith(
                  color: toneColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitProgressBar(
            progress: metric.progress,
            color: toneColor,
            trackColor: AppColors.surface2,
            height: AppSpacing.x3,
          ),
        ],
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.memory});

  final PerformanceMemoryUsage memory;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.usedLabel,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      memory.limitLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                memory.percentLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitProgressBar(
            progress: memory.progress,
            color: AppColors.buy,
            trackColor: AppColors.surface2,
            height: AppSpacing.x3,
          ),
        ],
      ),
    );
  }
}

class _LazyChunksCard extends StatelessWidget {
  const _LazyChunksCard({required this.chunks});

  final List<String> chunks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flash_on_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${chunks.length} chunks loaded on-demand',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final chunk in chunks) ...[
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
              ),
              child: Padding(
                padding: AdminSpacingTokens.devTokenCardPadding,
                child: Text(
                  chunk,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
            if (chunk != chunks.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ResourcesCard extends StatelessWidget {
  const _ResourcesCard({required this.resources});

  final List<PerformanceResourceTiming> resources;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          for (final resource in resources) ...[
            _ResourceRow(resource: resource),
            if (resource != resources.last) const _Divider(),
          ],
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final PerformanceResourceTiming resource;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdminSpacingTokens.devVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${resource.type} - ${resource.size}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.chartLabelXs.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            resource.duration,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
