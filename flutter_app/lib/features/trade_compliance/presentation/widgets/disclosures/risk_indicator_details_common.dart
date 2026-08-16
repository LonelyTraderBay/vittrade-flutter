part of '../../phone/pages/disclosures/risk_indicator_explainer_page.dart';

class _SriExplanationCard extends StatelessWidget {
  const _SriExplanationCard({required this.holdingPeriodYears});

  final int holdingPeriodYears;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _riskBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'The Summary Risk Indicator (SRI) is a guide to the level of risk '
            'of this product compared to other products. It shows how likely '
            'it is that the product will lose money because of movements in '
            'the markets or because we are not able to pay you.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'The risk indicator assumes you keep the product for '
                  '$holdingPeriodYears years. The actual risk can vary '
                  'significantly if you cash in at an early stage.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
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

class _RiskLevelCard extends StatelessWidget {
  const _RiskLevelCard({required this.level, required this.isProductLevel});

  final TradeRiskIndicatorLevel level;
  final bool isProductLevel;

  @override
  Widget build(BuildContext context) {
    final color = _colorForTier(level.tier);
    return VitCard(
      key: RiskIndicatorExplainerPage.levelKey(level.level),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _riskBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            alignment: Alignment.center,
            clip: true,
            borderColor: color.withValues(alpha: .18),
            background: ColoredBox(color: color.withValues(alpha: .11)),
            child: Text(
              '${level.level}',
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        level.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (isProductLevel) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const VitAccentPill(
                        label: 'THIS PRODUCT',
                        accentColor: _riskPrimary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  level.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Examples: ${level.examples.join(', ')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

class _AdditionalRisksCard extends StatelessWidget {
  const _AdditionalRisksCard({required this.risks});

  final List<TradeRiskIndicatorAdditionalRisk> risks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _riskBorder.withValues(alpha: .76),
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.tool,
        fullBleed: true,
        children: [for (final risk in risks) _AdditionalRiskRow(risk: risk)],
      ),
    );
  }
}

class _AdditionalRiskRow extends StatelessWidget {
  const _AdditionalRiskRow({required this.risk});

  final TradeRiskIndicatorAdditionalRisk risk;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: RiskIndicatorExplainerPage.additionalRiskKey(risk.title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.text1,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                risk.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                risk.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Color _colorForTier(TradeRiskIndicatorTier tier) {
  return switch (tier) {
    TradeRiskIndicatorTier.low => _riskGreen,
    TradeRiskIndicatorTier.medium => _riskPrimary,
    TradeRiskIndicatorTier.elevated => _riskAmber,
    TradeRiskIndicatorTier.high => _riskRed,
  };
}
