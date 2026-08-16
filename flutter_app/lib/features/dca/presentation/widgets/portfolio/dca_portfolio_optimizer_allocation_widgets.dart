part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _FrontierChip extends StatelessWidget {
  const _FrontierChip({required this.point, required this.active});

  final DcaFrontierPoint point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _dcaPortfolioFrontierChipWidth,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: active ? AppColors.accent10 : AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
            side: BorderSide(
              color: active ? AppColors.accent30 : AppColors.cardBorder,
            ),
          ),
        ),
        child: Padding(
          padding: DcaSpacingTokens.dcaPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                point.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: active ? AppColors.accent : AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '+${point.returnPercent.toStringAsFixed(0)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      ' · ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${point.riskPercent.toStringAsFixed(0)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleAllocationBar extends StatelessWidget {
  const _SimpleAllocationBar({required this.allocation});

  final DcaPortfolioAllocation allocation;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(allocation.accent);
    return Row(
      children: [
        SizedBox(
          width: _dcaPortfolioHeroIconExtent,
          height: _dcaPortfolioHeroIconExtent,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: accent.withValues(alpha: .10),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.mdRadius,
              ),
            ),
            child: Center(
              child: Text(
                allocation.symbol,
                style: AppTextStyles.micro.copyWith(
                  color: accent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: allocation.optimalPercent / 100,
              color: accent,
              backgroundColor: AppColors.surface2,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: AppSpacing.x6,
          child: Text(
            '${allocation.optimalPercent.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion});

  final DcaPortfolioSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final positive =
        suggestion.type == DcaPortfolioSuggestionType.add ||
        suggestion.type == DcaPortfolioSuggestionType.increase;
    final color = positive ? AppColors.buy : AppColors.sell;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: DcaSpacingTokens.dcaPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentIconBox(
            icon: positive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
            iconSize: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      suggestion.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Flexible(
                      child: Text(
                        '${suggestion.currentPercent.toStringAsFixed(0)}% → ${suggestion.suggestedPercent.toStringAsFixed(0)}%',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
                Text(
                  suggestion.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _dcaPortfolioBodyLineHeight,
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
