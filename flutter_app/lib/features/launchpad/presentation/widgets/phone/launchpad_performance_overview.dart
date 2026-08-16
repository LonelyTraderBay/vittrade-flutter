part of '../../phone/pages/hub/launchpad_performance_page.dart';

class _PerformanceTabs extends StatelessWidget {
  const _PerformanceTabs({required this.activeTab, required this.onChanged});

  final _PerformanceTab activeTab;
  final ValueChanged<_PerformanceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VitSegmentedChoice.withPrimaryAccent<_PerformanceTab>(
          key: LaunchpadPerformancePage.tabsKey,
          selected: activeTab,
          onChanged: onChanged,
          options: [
            for (final tab in _PerformanceTab.values)
              VitSegmentedChoiceOption(
                key: LaunchpadPerformancePage.tabKey(tab.id),
                value: tab,
                label: tab.label,
              ),
          ],
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final LaunchpadPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final summary = snapshot.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: LaunchpadPerformancePage.heroKey,
          variant: VitCardVariant.hero,
          radius: VitCardRadius.large,
          borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
          padding: _launchpadPerformanceHeroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ROI trung bình (ATH)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                '+${summary.averageRoiAth}%',
                style: AppTextStyles.numericDisplay4xl.copyWith(
                  color: AppColors.buy,
                ),
              ),
              Text(
                'Trung vị: +${summary.medianRoi}% · Tỷ lệ dương: ${summary.positiveRate.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      icon: Icons.rocket_launch_outlined,
                      label: 'Tổng dự án',
                      value: '${summary.totalProjects}',
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _HeroMetric(
                      icon: Icons.bar_chart_rounded,
                      label: 'Tổng huy động',
                      value: summary.totalRaised,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _HeroMetric(
                      icon: Icons.groups_2_outlined,
                      label: 'Người tham gia',
                      value: summary.totalParticipants,
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          key: LaunchpadPerformancePage.bestWorstKey,
          children: [
            Expanded(
              child: _BestWorstCard(
                icon: Icons.trending_up_rounded,
                eyebrow: 'Tốt nhất',
                value: '+${summary.bestProjectRoi}%',
                title: summary.bestProjectName,
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _BestWorstCard(
                icon: Icons.trending_down_rounded,
                eyebrow: 'Kém nhất',
                value: '${summary.worstProjectRoi}%',
                title: summary.worstProjectName,
                color: AppColors.sell,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _RoiDistribution(projects: snapshot.projects),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: _launchpadPerformanceCardPadding,
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: _launchpadPerformanceLineHeightBody,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestWorstCard extends StatelessWidget {
  const _BestWorstCard({
    required this.icon,
    required this.eyebrow,
    required this.value,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String eyebrow;
  final String value;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: _launchpadPerformanceCardPadding,
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            eyebrow,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _RoiDistribution extends StatelessWidget {
  const _RoiDistribution({required this.projects});

  final List<LaunchpadHistoricalProjectDraft> projects;

  @override
  Widget build(BuildContext context) {
    final maxRoi = projects.fold<int>(
      1,
      (max, project) => project.roiAth > max ? project.roiAth : max,
    );

    return VitCard(
      key: LaunchpadPerformancePage.distributionKey,
      radius: VitCardRadius.standard,
      padding: _launchpadPerformanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Phân bổ ROI (ATH)',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox(
            height: _launchpadPerformanceChartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: _launchpadPerformanceAxisLabelWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final label in ['380%', '285%', '190%', '95%', '0%'])
                        Text(
                          label,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: _launchpadPerformanceLineHeightTight,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final project in projects) ...[
                        Expanded(
                          child: _RoiBar(
                            project: project,
                            heightFactor: project.roiAth / maxRoi,
                          ),
                        ),
                        if (project != projects.last)
                          const SizedBox(width: AppSpacing.x2),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBar extends StatelessWidget {
  const _RoiBar({required this.project, required this.heightFactor});

  final LaunchpadHistoricalProjectDraft project;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: FractionallySizedBox(
            heightFactor: heightFactor.clamp(.10, 1.0),
            alignment: Alignment.bottomCenter,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: project.roiAth >= 0 ? AppColors.buy : AppColors.sell,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          project.symbol,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _launchpadPerformanceLineHeightTight,
          ),
        ),
      ],
    );
  }
}
