part of '../../phone/pages/tools/launchpad_risk_analytics_page.dart';

class _ReportTab extends StatelessWidget {
  const _ReportTab({required this.snapshot});

  final LaunchpadRiskAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadRiskAnalyticsPage.reportKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'So sanh du an',
            accentColor: AppColors.primary,
            children: [
              for (final project in snapshot.comparisonProjects)
                _ComparisonProjectCard(project: project),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _RiskDistributionCard(projects: snapshot.comparisonProjects),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitPageSection(
            label: 'Tai lieu tham khao',
            accentColor: AppColors.primary,
            children: [
              for (final resource in snapshot.resources)
                _ResourceRow(resource: resource),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.primary08,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.primary20),
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            child: Padding(
              padding: LaunchpadSpacingTokens.launchpadPaddingX3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: LaunchpadSpacingTokens.launchpadIconXl,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Risk analysis is for reference only. Always do your own research before investing. Past performance does not guarantee future results.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: LaunchpadSpacingTokens.launchpadLineHeightShort,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonProjectCard extends StatelessWidget {
  const _ComparisonProjectCard({required this.project});

  final LaunchpadRiskProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(project.level);
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.projectKey(project.id),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      project.symbol,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${project.score.overall}',
                    style: AppTextStyles.base.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  _RiskPill(level: project.level, compact: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ScoreProgress(value: project.score.overall, color: color),
        ],
      ),
    );
  }
}

class _RiskDistributionCard extends StatelessWidget {
  const _RiskDistributionCard({required this.projects});

  final List<LaunchpadRiskProjectDraft> projects;

  @override
  Widget build(BuildContext context) {
    final levels = LaunchpadRiskLevel.values;
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.distributionKey,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Distribution (Market)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: SizedBox(
              height: LaunchpadSpacingTokens.launchpadBox18,
              child: Row(
                children: [
                  for (final level in levels)
                    Expanded(
                      flex: projects.where((p) => p.level == level).length,
                      child: ColoredBox(color: _riskColor(level)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          GridView.count(
            crossAxisCount: LaunchpadSpacingTokens.launchpadGridColumns,
            mainAxisSpacing: AppSpacing.x2,
            crossAxisSpacing: AppSpacing.x2,
            childAspectRatio: LaunchpadSpacingTokens.launchpadGridAspectReport,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: AppSpacing.zeroInsets,
            children: [
              for (final level in levels)
                Row(
                  children: [
                    SizedBox.square(
                      dimension: LaunchpadSpacingTokens.launchpadBox12,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: _riskColor(level),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      _riskLabel(level),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final LaunchpadRiskResourceDraft resource;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.bg,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX3,
        child: Row(
          children: [
            Expanded(
              child: Text(
                resource.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.text3,
              size: LaunchpadSpacingTokens.launchpadIconXl,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreProgress extends StatelessWidget {
  const _ScoreProgress({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 1.0;
        final fillWidth = width * value.clamp(0, 100) / 100;
        return SizedBox(
          height: LaunchpadSpacingTokens.launchpadDotMd,
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.bg,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: fillWidth,
                height: LaunchpadSpacingTokens.launchpadDotMd,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level, this.compact = false});

  final LaunchpadRiskLevel level;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(level);
    final labelStyle = compact
        ? AppTextStyles.chartLabelXs
        : AppTextStyles.badge;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: compact
            ? LaunchpadSpacingTokens.launchpadLiveBadgePadding
            : LaunchpadSpacingTokens.launchpadTimelineMarkerPadding,
        child: Text(
          compact
              ? _riskLabel(level).toUpperCase()
              : '${_riskLabel(level).toUpperCase()} RISK',
          style: labelStyle.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: LaunchpadSpacingTokens.launchpadLineHeightMicro,
          ),
        ),
      ),
    );
  }
}

Color _riskColor(LaunchpadRiskLevel level) {
  return switch (level) {
    LaunchpadRiskLevel.low => AppColors.buy,
    LaunchpadRiskLevel.medium => AppColors.warn,
    LaunchpadRiskLevel.high => AppColors.sell,
    LaunchpadRiskLevel.critical => AppColors.sell,
  };
}

Color _scoreColor(int score) {
  if (score >= 80) return AppColors.buy;
  if (score >= 60) return AppColors.warn;
  return AppColors.sell;
}

String _riskLabel(LaunchpadRiskLevel level) {
  return switch (level) {
    LaunchpadRiskLevel.low => 'Low',
    LaunchpadRiskLevel.medium => 'Medium',
    LaunchpadRiskLevel.high => 'High',
    LaunchpadRiskLevel.critical => 'Critical',
  };
}
