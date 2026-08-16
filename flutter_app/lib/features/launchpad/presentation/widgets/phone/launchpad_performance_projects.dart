part of '../../phone/pages/hub/launchpad_performance_page.dart';

class _ProjectsTab extends StatelessWidget {
  const _ProjectsTab({required this.projects});

  final List<LaunchpadHistoricalProjectDraft> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final project in projects) ...[
          if (project != projects.first)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _HistoricalProjectCard(project: project),
        ],
      ],
    );
  }
}

class _HistoricalProjectCard extends StatelessWidget {
  const _HistoricalProjectCard({required this.project});

  final LaunchpadHistoricalProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final currentColor = project.roiCurrent >= 0
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      key: LaunchpadPerformancePage.projectKey(project.id),
      radius: VitCardRadius.standard,
      padding: _launchpadPerformanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: _launchpadPerformanceProjectIconBox,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: project.accent.resolve().withValues(alpha: .12),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: project.accent.resolve().withValues(alpha: .30),
                      ),
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      project.symbol.substring(0, 2),
                      style: AppTextStyles.caption.copyWith(
                        color: project.accent.resolve(),
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: _launchpadPerformanceLineHeightLabel,
                      ),
                    ),
                    Text(
                      '\$${project.symbol} · ${project.launchDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _TinyPill(
                label: project.type,
                status: VitStatusPillStatus.purple,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _PriceBox(
                  label: 'Giá launch',
                  value: project.launchPrice,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PriceBox(
                  label: 'ATH',
                  value: project.athPrice,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _PriceBox(
                  label: 'Hiện tại',
                  value: project.currentPrice,
                  color: currentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _RoiBox(label: 'ROI ATH', value: project.roiAth),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _RoiBox(
                  label: 'ROI hiện tại',
                  value: project.roiCurrent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            '${_formatInt(project.participants)} người · ${project.totalRaised}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  const _PriceBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: _launchpadPerformanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            '\$${_formatPrice(value)}',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBox extends StatelessWidget {
  const _RoiBox({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .18)),
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      child: Padding(
        padding: _launchpadPerformanceCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            Text(
              '${value >= 0 ? '+' : ''}$value%',
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
