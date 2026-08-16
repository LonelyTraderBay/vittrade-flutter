part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: AppSpacing.x2,
              height: AppSpacing.x2,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: _dcaPortfolioBodyLineHeight,
          ),
        ),
      ],
    );
  }
}
