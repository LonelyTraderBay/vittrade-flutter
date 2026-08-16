part of '../../phone/pages/tools/launchpad_risk_analytics_page.dart';

class _OverallRiskCard extends StatelessWidget {
  const _OverallRiskCard({required this.project});

  final LaunchpadRiskProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(project.level);
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.scoreKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diem rui ro tong the',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${project.score.overall}/100',
                      style: AppTextStyles.amountLg,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    _RiskPill(level: project.level),
                  ],
                ),
              ),
              SizedBox.square(
                dimension: LaunchpadSpacingTokens.launchpadBox60,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color.withValues(alpha: .12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.cardRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shield_outlined,
                      color: color,
                      size: LaunchpadSpacingTokens.launchpadIconHuge,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ScoreProgress(value: project.score.overall, color: color),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Dua tren 6 chi so: Team, Audit, Tokenomics, Community, Security, Liquidity',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskBreakdownCard extends StatelessWidget {
  const _RiskBreakdownCard({required this.metrics});

  final List<LaunchpadRiskMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.breakdownKey,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Breakdown',
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height:
                LaunchpadSpacingTokens.launchpadBox150 +
                LaunchpadSpacingTokens.launchpadBox64,
            child: CustomPaint(
              painter: _RadarChartPainter(metrics),
              child: Stack(
                children: [
                  for (var i = 0; i < metrics.length; i++)
                    _RadarLabel(
                      index: i,
                      count: metrics.length,
                      metrics: metrics,
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

class _QuickChecksSection extends StatelessWidget {
  const _QuickChecksSection({required this.project});

  final LaunchpadRiskProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final checks = [
      _QuickCheckDraft(
        label: 'Audit Verified',
        icon: Icons.description_outlined,
        status: project.auditStatus == LaunchpadRiskAuditStatus.verified,
      ),
      _QuickCheckDraft(
        label: 'Team Doxxed',
        icon: Icons.groups_2_outlined,
        status: project.teamDoxxed,
      ),
      _QuickCheckDraft(
        label: 'Contract Verified',
        icon: Icons.code_rounded,
        status: project.contractVerified,
      ),
      _QuickCheckDraft(
        label: 'Liquidity Locked',
        icon: Icons.lock_outline_rounded,
        status: project.liquidityLocked,
      ),
    ];

    return KeyedSubtree(
      key: LaunchpadRiskAnalyticsPage.quickChecksKey,
      child: VitPageSection(
        label: 'Kiem tra nhanh',
        accentColor: AppColors.primary,
        children: [
          GridView.count(
            crossAxisCount: LaunchpadSpacingTokens.launchpadGridColumns,
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: LaunchpadSpacingTokens.launchpadGridAspectWide,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: AppSpacing.zeroInsets,
            children: [
              for (final check in checks) _QuickCheckCard(check: check),
            ],
          ),
        ],
      ),
    );
  }
}

final class _QuickCheckDraft {
  const _QuickCheckDraft({
    required this.label,
    required this.icon,
    required this.status,
  });

  final String label;
  final IconData icon;
  final bool status;
}

class _QuickCheckCard extends StatelessWidget {
  const _QuickCheckCard({required this.check});

  final _QuickCheckDraft check;

  @override
  Widget build(BuildContext context) {
    final color = check.status ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .20)),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  check.icon,
                  color: color,
                  size: LaunchpadSpacingTokens.launchpadIconXl,
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  check.status
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  color: color,
                  size: LaunchpadSpacingTokens.launchpadIconLg,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              check.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalSection extends StatelessWidget {
  const _SignalSection({
    required this.sectionKey,
    required this.label,
    required this.accent,
    required this.icon,
    required this.messages,
  });

  final Key sectionKey;
  final String label;
  final Color accent;
  final IconData icon;
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: sectionKey,
      child: VitPageSection(
        label: label,
        accentColor: accent,
        children: [
          for (final message in messages)
            DecoratedBox(
              decoration: ShapeDecoration(
                color: accent.withValues(alpha: .08),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: accent.withValues(alpha: .20)),
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: accent,
                      size: LaunchpadSpacingTokens.launchpadIconXl,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        message,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
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
