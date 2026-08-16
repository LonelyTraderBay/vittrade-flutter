part of '../../phone/pages/settings/bot_risk_disclosure_page.dart';

class _HighRiskBanner extends StatelessWidget {
  const _HighRiskBanner({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _botRiskRed.withValues(alpha: .58),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _botRiskRed,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _riskSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.highRiskTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: _botRiskRed,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _riskTinySpace),
                Text(
                  snapshot.highRiskBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                    height: _riskLineTight,
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

class _PastPerformanceCard extends StatelessWidget {
  const _PastPerformanceCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.trending_down_rounded,
            color: AppColors.text3,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _riskSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.pastPerformanceTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _riskTinySpace),
                Text(
                  snapshot.pastPerformanceBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _riskLineTight,
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

class _RiskCategoryCard extends StatelessWidget {
  const _RiskCategoryCard({required this.category});

  final TradeBotRiskCategory category;

  @override
  Widget build(BuildContext context) {
    final color = _colorForKind(category.kind);
    return VitCard(
      key: BotRiskDisclosurePage.categoryKey(category.id),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: _riskIconTile,
                height: _riskIconTile,
                variant: VitCardVariant.ghost,
                density: VitDensity.tool,
                padding: AppSpacing.zeroInsets,
                radius: VitCardRadius.tight,
                borderColor: color.withValues(alpha: .24),
                alignment: Alignment.center,
                child: Icon(
                  _iconForKind(category.kind),
                  color: color,
                  size: AppSpacing.x4,
                ),
              ),
              const SizedBox(width: _riskSpace),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: AppTextStyles.body.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _riskTinySpace),
                    Text(
                      category.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _riskLineTight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _riskSpace),
          Text(
            'REAL EXAMPLES:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _riskTinySpace),
          for (final example in category.examples) ...[
            _BulletText(example, color: AppColors.text2),
            if (example != category.examples.last)
              const SizedBox(height: _riskTinySpace),
          ],
          const SizedBox(height: _riskSpace),
          VitCard(
            width: double.infinity,
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            padding: AppSpacing.cardPaddingCompact,
            variant: VitCardVariant.inner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOW TO MITIGATE:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _riskTinySpace),
                Text(
                  category.mitigation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _riskLineTight,
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

class _AdditionalWarningsCard extends StatelessWidget {
  const _AdditionalWarningsCard({required this.warnings});

  final List<TradeBotRiskWarning> warnings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          for (final warning in warnings) ...[
            _WarningBlock(warning: warning),
            if (warning != warnings.last)
              const Divider(
                color: AppColors.borderSolid,
                height: AppSpacing.x3,
              ),
          ],
        ],
      ),
    );
  }
}

class _WarningBlock extends StatelessWidget {
  const _WarningBlock({required this.warning});

  final TradeBotRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: _botRiskAmber,
              size: AppSpacing.x4,
            ),
            const SizedBox(width: _riskTinySpace),
            Expanded(
              child: Text(
                warning.title,
                style: AppTextStyles.caption.copyWith(
                  color: _botRiskRed,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: _riskTinySpace),
        Text(
          warning.text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: _riskLineTight,
          ),
        ),
      ],
    );
  }
}

class _RegulatoryNoticeCard extends StatelessWidget {
  const _RegulatoryNoticeCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.regulatoryTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _riskTinySpace),
          Text(
            snapshot.regulatoryBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _riskLineTight,
            ),
          ),
          const SizedBox(height: _riskSpace),
          for (final note in snapshot.regulatoryNotes) ...[
            _BulletText(note, color: AppColors.text3),
            if (note != snapshot.regulatoryNotes.last)
              const SizedBox(height: _riskTinySpace),
          ],
        ],
      ),
    );
  }
}
