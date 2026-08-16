part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: AppTextStyles.heavy,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontWeight: AppTextStyles.heavy,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrelationCell extends StatelessWidget {
  const _CorrelationCell({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= .7
        ? AppColors.sell
        : value >= .4
        ? AppColors.warn
        : AppColors.buy;
    return Padding(
      padding: DcaSpacingTokens.dcaHorizontalPaddingX1,
      child: SizedBox(
        height: AppSpacing.x7,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color.withValues(alpha: value == 1 ? .08 : .14),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.mdRadius,
            ),
          ),
          child: Center(
            child: Text(
              value.toStringAsFixed(2),
              style: AppTextStyles.micro.copyWith(
                color: value == 1 ? AppColors.text3 : color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn15,
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.warning_amber_rounded,
            color: AppColors.warn,
            iconSize: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _dcaPortfolioBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
