part of '../../phone/pages/tools/wallet_health_score_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.snapshot,
    required this.primaryRecommendationId,
    required this.onRecommendationTap,
  });

  final WalletHealthScoreSnapshot snapshot;
  final String? primaryRecommendationId;
  final ValueChanged<WalletHealthRecommendation> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren => [
    _RadarCard(metrics: snapshot.metrics),
    VitPageSection(
      label: 'Chi ti\u1EBFt \u0111i\u1EC3m',
      accentColor: _healthPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        for (final metric in snapshot.metrics) _MetricCard(metric: metric),
      ],
    ),
    _TrendCard(history: snapshot.history),
    VitPageSection(
      label: '\u0110\u1EC1 xu\u1EA5t th\u00EAm',
      accentColor: _healthPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        if (snapshot.priorityRecommendations
            .where((rec) => rec.id != primaryRecommendationId)
            .isEmpty)
          const VitEmptyState(
            title: 'No extra recommendations',
            message: 'The highest-priority advisory action is shown above.',
          )
        else
          for (final rec in snapshot.priorityRecommendations.where(
            (rec) => rec.id != primaryRecommendationId,
          ))
            _RecommendationCard(
              recommendation: rec,
              onTap: () => onRecommendationTap(rec),
            ),
      ],
    ),
  ];
}

class _OverallScoreCard extends StatelessWidget {
  const _OverallScoreCard({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = _scoreColor(snapshot.overallScore);
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _healthCompactGaugeSize,
            height: _healthCompactGaugeSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(_healthCompactGaugeSize),
                  painter: _GaugePainter(
                    score: snapshot.overallScore,
                    color: scoreColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${snapshot.overallScore}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: scoreColor,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '/ 100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Health Score',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.overallStatus,
                  style: AppTextStyles.caption.copyWith(
                    color: scoreColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Advisory snapshot only. Your wallet is ${snapshot.overallMessage}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.28,
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

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.metrics});

  final List<WalletHealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: VitDensity.compact.controlHeight * 3.2,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Health Breakdown',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Expanded(
            child: CustomPaint(
              painter: _RadarPainter(metrics),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final WalletHealthMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(metric.status);
    return VitCard(
      key: WalletHealthScorePage.metricKey(metric.category),
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.category,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${metric.score}',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              _StatusBadge(label: metric.status, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: SizedBox(
              height: _healthMetricProgressHeight,
              child: LinearProgressIndicator(
                value: metric.score / metric.maxScore,
                backgroundColor: _healthBackground,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.history});

  final List<WalletHealthHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: VitDensity.compact.controlHeight * 3,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Health Trend (6 months)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Expanded(
            child: CustomPaint(
              painter: _TrendPainter(history),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onTap,
  });

  final WalletHealthRecommendation recommendation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final impactColor = _impactColor(recommendation.impact);
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recommendation.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusBadge(
                label: '${recommendation.impact} impact',
                color: impactColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            recommendation.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.28,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            key: WalletHealthScorePage.recommendationKey(recommendation.id),
            onPressed: onTap,
            height: VitDensity.compact.controlHeight,
            trailing: const Icon(Icons.arrow_forward_rounded),
            child: Text(
              recommendation.actionLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityTab extends StatelessWidget {
  const _SecurityTab({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren {
    final metric = snapshot.metricByCategory('Security');
    return [
      _ScoreSummaryCard(
        icon: Icons.shield_outlined,
        iconColor: _healthPrimary,
        title: 'Security Score',
        subtitle: 'Based on 8 security factors',
        score: metric.score,
        status: 'Good',
      ),
      VitPageSection(
        label: 'Security Checklist',
        accentColor: _healthPrimary,
        innerGap: AppSpacing.pageRhythmStandardInnerGap,
        children: [
          for (final item in snapshot.securityChecklist)
            _ChecklistCard(item: item),
        ],
      ),
      const _ActionRequiredCard(),
    ];
  }
}

class _DiversificationTab extends StatelessWidget {
  const _DiversificationTab({required this.snapshot});

  final WalletHealthScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren {
    final metric = snapshot.metricByCategory('Diversification');
    return [
      _ScoreSummaryCard(
        icon: Icons.track_changes_rounded,
        iconColor: _healthAmber,
        title: 'Diversification',
        subtitle: 'Portfolio balance analysis',
        score: metric.score,
        status: 'Moderate',
      ),
      _AssetDistributionCard(slices: snapshot.diversification),
      const _ConcentrationRiskCard(),
      VitPageSection(
        label: 'Diversification Tips',
        accentColor: _healthPrimary,
        innerGap: AppSpacing.pageRhythmStandardInnerGap,
        children: [
          for (final tip in const [
            'Maintain 15-25% in stablecoins for liquidity',
            'Limit single asset to max 30% of portfolio',
            'Spread across 5-10 quality assets',
            'Rebalance quarterly to maintain targets',
          ])
            _TipCard(tip: tip),
        ],
      ),
      const _InfoCard(
        text:
            'Diversification reduces portfolio volatility. Aim for balance across asset types and risk levels.',
      ),
    ];
  }
}

class _ScoreSummaryCard extends StatelessWidget {
  const _ScoreSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.status,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            borderColor: iconColor.withValues(alpha: .20),
            child: Icon(
              icon,
              color: iconColor,
              size: WalletSpacingTokens.walletHealthSummaryIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(color: iconColor),
              ),
              Text(
                status,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.item});

  final WalletSecurityChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.enabled ? _healthGreen : _healthRed;
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            radius: VitCardRadius.standard,
            borderColor: color.withValues(alpha: .20),
            child: Icon(
              item.enabled
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
              size: WalletSpacingTokens.walletHealthChecklistIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: _healthRed.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _healthRed,
            size: WalletSpacingTokens.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cần xử lý',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Sao lưu cụm từ khôi phục và bật danh sách trắng rút tiền để cải thiện điểm bảo mật.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.28,
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

class _AssetDistributionCard extends StatelessWidget {
  const _AssetDistributionCard({required this.slices});

  final List<WalletDiversificationSlice> slices;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Distribution',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: VitDensity.compact.controlHeight * 2.8,
            child: CustomPaint(
              painter: _PiePainter(slices),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: WalletSpacingTokens.walletHealthLegendSpacing,
            runSpacing: WalletSpacingTokens.walletHealthLegendRunSpacing,
            children: [
              for (final slice in slices)
                SizedBox(
                  width: WalletSpacingTokens.walletHealthLegendWidth,
                  child: Row(
                    children: [
                      // card-tile: allow-start — fixed surface, not horizontal strip tile
                      VitCard(
                        width: WalletSpacingTokens.walletHealthLegendSwatch,
                        height: _healthLegendSwatchHeight,
                        radius: VitCardRadius.standard,
                        borderColor: Color(slice.colorHex),
                        background: ColoredBox(color: Color(slice.colorHex)),
                        clip: true,
                        child: const SizedBox.expand(),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Expanded(
                        child: Text(
                          '${slice.name} ${slice.value}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConcentrationRiskCard extends StatelessWidget {
  const _ConcentrationRiskCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthAmber.withValues(alpha: .15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _healthAmber,
                size: WalletSpacingTokens.walletHealthActionIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concentration Risk',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '42% of your portfolio is in BTC. Consider rebalancing to reduce single-asset risk.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const _AllocationRow(
            label: 'Recommended BTC allocation',
            value: '25-30%',
            color: _healthAmber,
          ),
          const SizedBox(height: AppSpacing.x1),
          const _AllocationRow(
            label: 'Current BTC allocation',
            value: '42%',
            color: _healthRed,
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: _healthAmber,
            size: WalletSpacingTokens.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: _healthPrimary.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _healthPrimary,
            size: WalletSpacingTokens.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label.toUpperCase(), accentColor: color);
  }
}
