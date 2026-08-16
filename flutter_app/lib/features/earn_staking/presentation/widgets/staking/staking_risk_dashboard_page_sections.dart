part of '../../phone/pages/staking/staking_risk_dashboard_page.dart';

class _OverallRiskCard extends StatelessWidget {
  const _OverallRiskCard({required this.snapshot});

  final StakingRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.overallScore);
    final label = _riskLabel(snapshot.overallScore);
    return VitCard(
      key: StakingRiskDashboardPage.scoreKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Overall Risk Score',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Center(
            child: SizedBox(
              width: AppSpacing.x7 + AppSpacing.x7,
              height: AppSpacing.x7 + AppSpacing.x7,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: CircleBorder(
                    side: BorderSide(
                      color: color,
                      width: EarnSpacingTokens
                          .stakingRiskDashboardScoreBorderWidth,
                    ),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.overallScore.toString(),
                        style: AppTextStyles.numericDisplay4xl.copyWith(
                          color: color,
                        ),
                      ),
                      Text(
                        '/ 100',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Center(
            child: VitStatusPill(
              label: label,
              status: _riskVitStatus(snapshot.overallScore),
              icon: Icons.shield_outlined,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Your staking portfolio has ${label.toLowerCase()}. No immediate action required, but monitor market volatility.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MiniRiskMetric(
                  label: 'Total Staked',
                  value: EarnFormatters.usd(snapshot.totalStakedUsd),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniRiskMetric(
                  label: 'At Risk',
                  value: EarnFormatters.usd(snapshot.atRiskUsd),
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniRiskMetric(
                  label: 'Protected',
                  value: '${snapshot.protectedPercent}%',
                  color: AppColors.buy,
                  borderColor: AppColors.buy20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskMetricCard extends StatelessWidget {
  const _RiskMetricCard({required this.metric});

  final StakingRiskMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(metric.score);
    return VitCard(
      key: StakingRiskDashboardPage.metricKey(metric.category),
      radius: VitCardRadius.large,
      onTap: metric.actionRoute == null
          ? null
          : () => context.go(metric.actionRoute!),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: Icon(_riskIcon(metric.status), color: color),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            metric.category,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        _ScorePill(score: metric.score, color: color),
                        if (metric.actionRoute != null) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.text3,
                            size: AppSpacing.iconMd,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      metric.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height:
                            EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: metric.score / 100,
              backgroundColor: AppColors.surface3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExposureCard extends StatelessWidget {
  const _ExposureCard({required this.exposures});

  final List<StakingRiskExposureDraft> exposures;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.x7 + AppSpacing.x7,
            child: Center(
              child: CustomPaint(
                size: const Size.square(AppSpacing.x7 + AppSpacing.x6),
                painter: _ExposurePiePainter(exposures),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final item in exposures) ...[
            _ExposureRow(item: item),
            if (item != exposures.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ExposureRow extends StatelessWidget {
  const _ExposureRow({required this.item});

  final StakingRiskExposureDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _exposureColor(item.risk);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color,
                shape: const CircleBorder(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              item.asset,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                EarnFormatters.usd(item.valueUsd),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                '${item.percentage}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskEventCard extends StatelessWidget {
  const _RiskEventCard({required this.event});

  final StakingRiskEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: 0.22),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_eventIcon(event.type), color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(event.title, style: AppTextStyles.caption),
                    ),
                    Text(
                      event.dateLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
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

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid({required this.actions});

  final List<StakingRiskActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: EarnSpacingTokens.stakingRiskDashboardActionGridColumns,
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio:
            EarnSpacingTokens.stakingRiskDashboardActionGridAspect,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        final color = _toneColor(action.tone);
        return VitCard(
          key: StakingRiskDashboardPage.actionKey(action.title),
          onTap: () => context.go(action.route),
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _actionIcon(action.tone),
                color: color,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                action.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        );
      },
    );
  }
}
