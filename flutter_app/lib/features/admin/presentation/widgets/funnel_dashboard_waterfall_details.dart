part of '../phone/pages/funnel_dashboard_page.dart';

class _WaterfallCard extends StatelessWidget {
  const _WaterfallCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.filter_alt_outlined,
            title: 'Funnel Waterfall',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (var i = 0; i < funnel.steps.length; i++) ...[
            _WaterfallStep(index: i + 1, step: funnel.steps[i]),
            if (i != funnel.steps.length - 1)
              const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}

class _WaterfallStep extends StatelessWidget {
  const _WaterfallStep({required this.index, required this.step});

  final int index;
  final AdminFunnelStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _StepNumber(index: index),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                step.label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${step.reached}',
                  style: AppTextStyles.numericCode.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  step.completionRateLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.inputRadius,
          child: SizedBox(
            height: AdminSpacingTokens.adminBox32,
            child: ColoredBox(
              color: AppColors.surface2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: AdminSpacingTokens.adminHorizontalCardPadding,
                  child: Text(
                    'hoàn thành',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AdminSpacingTokens.adminLineHeightShort,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AdminSpacingTokens.adminIconXs,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '${step.completionRateLabel} hoàn thành',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _DropoutChartCard extends StatelessWidget {
  const _DropoutChartCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    final hasDropout = funnel.steps.any((step) => step.reached > 0);
    return VitCard(
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.trending_down_rounded,
            title: 'Tỷ lệ rời bỏ theo bước',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AdminSpacingTokens.adminFunnelWaterfallHeight,
            child: Semantics(
              label: hasDropout
                  ? 'Biểu đồ rời bỏ ${funnel.name}'
                  : 'Biểu đồ rời bỏ ${funnel.name} không có phiên',
              child: CustomPaint(
                painter: _DropoutChartPainter(steps: funnel.steps),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          if (!hasDropout) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            const AdminInlineEmptyState(
              icon: Icons.trending_down_rounded,
              title: 'No dropout data',
              message: 'Dropout rates appear after sessions enter this funnel.',
            ),
          ],
        ],
      ),
    );
  }
}

class _StepDetailsCard extends StatelessWidget {
  const _StepDetailsCard({required this.funnel});

  final AdminConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Chi tiết từng bước',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (var i = 0; i < funnel.steps.length; i++) ...[
            _StepDetailRow(index: i + 1, step: funnel.steps[i]),
            if (i != funnel.steps.length - 1)
              const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}

class _StepDetailRow extends StatelessWidget {
  const _StepDetailRow({required this.index, required this.step});

  final int index;
  final AdminFunnelStep step;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.adminCompactPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StepNumber(index: index),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    step.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AdminSpacingTokens.adminIconMd,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Tiếp cận',
                    value: '${step.reached}',
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Hoàn thành',
                    value: '${step.completed}',
                    valueColor: AppColors.buy,
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Tỷ lệ',
                    value: step.completionRateLabel,
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    label: 'Thời gian',
                    value: step.avgTimeLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({
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
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.numericCode.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
