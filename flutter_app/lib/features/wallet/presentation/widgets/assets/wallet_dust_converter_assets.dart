part of '../../phone/pages/assets/dust_converter_page.dart';

class _DustAssetRow extends StatelessWidget {
  const _DustAssetRow({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final WalletDustAsset asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return Material(
      color: selected ? color.withValues(alpha: .07) : AppColors.transparent,
      child: InkWell(
        key: DustConverterPage.assetKey(asset.id),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.zeroInsets.copyWith(
            left: AppSpacing.x4,
            right: AppSpacing.x4,
            top: AppSpacing.rowGapRegular,
            bottom: AppSpacing.rowGapRegular,
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: selected ? AppColors.primary : _dustMuted,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: _dustTinyGap),
              _TokenLogo(
                symbol: asset.symbol,
                color: color,
                size: _dustTokenLogo,
              ),
              const SizedBox(width: _dustInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _dustTinyGap),
                    Text(
                      asset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(color: _dustMuted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    asset.availableLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: _dustTinyGap),
                  Text(
                    '\u2248 ${_formatUsd(asset.usdValue, preciseSmall: true)}',
                    style: AppTextStyles.micro.copyWith(
                      color: _dustMuted,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TokenLogo extends StatelessWidget {
  const _TokenLogo({
    required this.symbol,
    required this.color,
    required this.size,
  });

  final String symbol;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: symbol,
      accentColor: color,
      size: size,
      radius: AppRadii.cardLargeRadius,
      border: true,
      maxChars: 3,
      fillAlpha: .18,
      borderAlpha: .42,
      textStyle: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}
