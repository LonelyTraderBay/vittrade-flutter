part of '../../phone/pages/governance/regulatory_inspection_ready_page.dart';

class _ComplianceScoreCard extends StatelessWidget {
  const _ComplianceScoreCard({required this.snapshot});

  final TradeRegulatoryInspectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              const VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                borderColor: _inspectionGreen,
                alignment: Alignment.center,
                child: Icon(
                  Icons.military_tech_outlined,
                  color: _inspectionGreen,
                  size: AppSpacing.inputPrefixIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.scoreLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${snapshot.complianceScore}%',
                          style: AppTextStyles.amountLg.copyWith(
                            color: _inspectionGreen,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '/ 100%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: snapshot.complianceScore / 100,
              minHeight: AppSpacing.x1,
              backgroundColor: _inspectionPanel2,
              valueColor: const AlwaysStoppedAnimation(_inspectionGreen),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: AppSpacing.zeroInsets,
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.text1,
                  size: AppSpacing.inputPrefixIcon,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                    children: [
                      TextSpan(text: '${snapshot.readyTitle} '),
                      TextSpan(text: snapshot.readyDescription),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats});

  final List<TradeRegulatoryInspectionStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _QuickStatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.stat});

  final TradeRegulatoryInspectionStat stat;

  @override
  Widget build(BuildContext context) {
    final style = _styleForStat(stat.icon);
    return VitCard(
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      radius: VitCardRadius.tight,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            style.icon,
            color: style.color,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            stat.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FrameworkCard extends StatelessWidget {
  const _FrameworkCard({required this.framework});

  final TradeRegulatoryFramework framework;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _inspectionBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  framework.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              Text(
                '${framework.compliance}%',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _inspectionGreen,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: _inspectionGreen,
                size: AppSpacing.inputPrefixIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final requirement in framework.requirements) ...[
            _RequirementRow(requirement),
            if (requirement != framework.requirements.last)
              const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _inspectionGreen,
          size: AppSpacing.x3,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.check_rounded,
                color: AppColors.text2,
                size: AppSpacing.x3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
