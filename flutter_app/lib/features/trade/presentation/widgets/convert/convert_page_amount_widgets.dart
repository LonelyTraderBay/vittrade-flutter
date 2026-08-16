part of '../../phone/pages/convert/convert_page.dart';

class _ConvertHeroCard extends StatelessWidget {
  const _ConvertHeroCard({
    required this.fromAsset,
    required this.toAsset,
    required this.amountController,
    required this.quoteAmount,
    required this.quoteLabel,
    required this.countdown,
    required this.favoritePairs,
    required this.activeFrom,
    required this.activeTo,
    required this.onFromChanged,
    required this.onFromAssetTap,
    required this.onToAssetTap,
    required this.onPercent,
    required this.onSwap,
    required this.onFavoriteSelected,
  });

  final TradeConvertAsset fromAsset;
  final TradeConvertAsset toAsset;
  final TextEditingController amountController;
  final double quoteAmount;
  final String quoteLabel;
  final String countdown;
  final List<TradeConvertFavoritePair> favoritePairs;
  final String activeFrom;
  final String activeTo;
  final VoidCallback onFromChanged;
  final VoidCallback onFromAssetTap;
  final VoidCallback onToAssetTap;
  final ValueChanged<int> onPercent;
  final VoidCallback onSwap;
  final ValueChanged<TradeConvertFavoritePair> onFavoriteSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.standard,
      clip: true,
      padding: AppSpacing.cardPadding,
      background: const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sync_rounded,
                color: _tradePrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  quoteLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent.withValues(alpha: .82),
                    fontWeight: AppTextStyles.medium,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              VitAccentPill(label: countdown, accentColor: _tradePrimary),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _AmountSection(
            label: 'Từ',
            asset: fromAsset,
            amountController: amountController,
            input: true,
            onChanged: onFromChanged,
            onAssetTap: onFromAssetTap,
            onPercent: onPercent,
          ),
          Transform.translate(
            offset: const Offset(0, -AppSpacing.x2),
            child: Center(
              child: VitIconButton(
                key: ConvertPage.swapKey,
                onPressed: onSwap,
                icon: Icons.swap_vert_rounded,
                tooltip: 'Đảo chiều cặp',
                variant: VitIconButtonVariant.primary,
                size: VitIconButtonSize.md,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -AppSpacing.x4),
            child: _AmountSection(
              label: 'Sang',
              asset: toAsset,
              quoteAmount: quoteAmount,
              onAssetTap: onToAssetTap,
            ),
          ),
          if (favoritePairs.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            SizedBox(
              height: TradeSpacingTokens.convertFavoriteChipHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favoritePairs.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.x2),
                itemBuilder: (context, index) {
                  final pair = favoritePairs[index];
                  final active =
                      pair.fromSymbol == activeFrom &&
                      pair.toSymbol == activeTo;
                  return VitChoicePill(
                    key: ConvertPage.favoriteKey(pair.label),
                    label: pair.label,
                    selected: active,
                    onTap: () => onFavoriteSelected(pair),
                    accentColor: _tradePrimary,
                    height: TradeSpacingTokens.convertChipHeight,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountSection extends StatelessWidget {
  const _AmountSection({
    required this.label,
    required this.asset,
    required this.onAssetTap,
    this.amountController,
    this.quoteAmount,
    this.input = false,
    this.onChanged,
    this.onPercent,
  });

  final String label;
  final TradeConvertAsset asset;
  final VoidCallback onAssetTap;
  final TextEditingController? amountController;
  final double? quoteAmount;
  final bool input;
  final VoidCallback? onChanged;
  final ValueChanged<int>? onPercent;

  @override
  Widget build(BuildContext context) {
    final balanceLabel =
        'Số dư: ${formatConvertBalance(asset.balance, asset.symbol)} ${asset.symbol}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent.withValues(alpha: .72),
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                balanceLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent.withValues(alpha: .62),
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            _AssetButton(
              key: input ? ConvertPage.fromAssetKey : ConvertPage.toAssetKey,
              asset: asset,
              onTap: onAssetTap,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: input
                  ? VitInput(
                      fieldKey: ConvertPage.amountFieldKey,
                      controller: amountController!,
                      hintText: '0.00',
                      textAlign: TextAlign.right,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,8}'),
                        ),
                      ],
                      onChanged: (_) => onChanged?.call(),
                      textStyle: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontFeatures: AppTextStyles.tabularFigures,
                        fontWeight: AppTextStyles.bold,
                      ),
                    )
                  : Text(
                      formatConvertQuoteAmount(quoteAmount ?? 0, asset.symbol),
                      textAlign: TextAlign.right,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .55),
                        fontFeatures: AppTextStyles.tabularFigures,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
            ),
          ],
        ),
        if (input) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitPresetChipRow.percentBalance(
            onTap: onPercent!,
            keyFor: ConvertPage.pctKey,
            accentColor: _tradePrimary,
            height: TradeSpacingTokens.convertChipHeight,
            padding: AppSpacing.zeroInsets,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Text(
                'Min: \$10',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent.withValues(alpha: .5),
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                'Max: \$500,000',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent.withValues(alpha: .5),
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _AssetButton extends StatelessWidget {
  const _AssetButton({super.key, required this.asset, required this.onTap});

  final TradeConvertAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      height: TradeSpacingTokens.convertControlHeight,
      density: VitDensity.tool,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowGapRegular,
        right: AppSpacing.rowGapRegular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitAssetAvatar(
            label: asset.symbol,
            accentColor: color,
            size: AppSpacing.buttonCompact - AppSpacing.x2,
            radius: AppRadii.smRadius,
            border: true,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            asset.symbol,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.onAccent.withValues(alpha: .72),
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}
