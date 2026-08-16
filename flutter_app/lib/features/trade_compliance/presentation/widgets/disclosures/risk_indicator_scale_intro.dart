part of '../../phone/pages/disclosures/risk_indicator_explainer_page.dart';

class _ProductSriCard extends StatelessWidget {
  const _ProductSriCard({required this.snapshot});

  final TradeRiskIndicatorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.tool,
      borderColor: _riskBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.productName,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Summary Risk Indicator',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (final level in snapshot.levels) ...[
                Expanded(
                  child: _ScaleTile(
                    level: level.level,
                    color: level.level <= snapshot.productSri
                        ? _colorForTier(level.tier)
                        : _riskPanel2,
                    active: level.level <= snapshot.productSri,
                  ),
                ),
                if (level != snapshot.levels.last)
                  const SizedBox(width: AppSpacing.x1),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lower Risk',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                'Higher Risk',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const _SriWarning(),
        ],
      ),
    );
  }
}

class _ScaleTile extends StatelessWidget {
  const _ScaleTile({
    required this.level,
    required this.color,
    required this.active,
  });

  final int level;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      alignment: Alignment.center,
      clip: true,
      borderColor: color.withValues(alpha: active ? .18 : .08),
      background: ColoredBox(color: color),
      child: Text(
        '$level',
        style: AppTextStyles.baseMedium.copyWith(
          color: active ? AppColors.onAccent : AppColors.text3,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _SriWarning extends StatelessWidget {
  const _SriWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _riskAmber.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _riskAmber,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'SRI 6 - High Risk: ',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'This product has high volatility. You could lose a '
                        'significant portion of your investment.',
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: _riskAmber,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
