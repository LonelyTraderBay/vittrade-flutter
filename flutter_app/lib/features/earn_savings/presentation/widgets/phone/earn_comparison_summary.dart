part of '../../phone/pages/savings/savings_comparison_page.dart';

class _SelectedProducts extends StatelessWidget {
  const _SelectedProducts({
    required this.selectedProducts,
    required this.selectedCount,
    required this.maxCompare,
    required this.canAdd,
    required this.onRemove,
    required this.onAdd,
  });

  final List<SavingsProductDraft> selectedProducts;
  final int selectedCount;
  final int maxCompare;
  final bool canAdd;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsComparisonPage.selectedProductsKey,
      children: [
        for (final product in selectedProducts) ...[
          _ProductChip(product: product, onRemove: () => onRemove(product.id)),
          if (product != selectedProducts.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        if (canAdd) ...[
          if (selectedProducts.isNotEmpty)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _AddProductButton(
            selectedCount: selectedCount,
            maxCompare: maxCompare,
            onTap: onAdd,
          ),
        ],
      ],
    );
  }
}

class _ProductChip extends StatelessWidget {
  const _ProductChip({required this.product, required this.onRemove});

  final SavingsProductDraft product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(product.asset);

    return VitCard(
      key: SavingsComparisonPage.productChipKey(product.id),
      variant: VitCardVariant.inner,
      borderColor: accent.withValues(alpha: 0.35),
      padding: EarnSpacingTokens.earnCardPaddingX4X3,
      child: Row(
        children: [
          _EarnAssetBadge(asset: product.asset, color: accent),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          VitIconButton(
            key: SavingsComparisonPage.removeProductKey(product.id),
            icon: Icons.close_rounded,
            tooltip: 'Xóa ${product.name}',
            onPressed: onRemove,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

class _AddProductButton extends StatelessWidget {
  const _AddProductButton({
    required this.selectedCount,
    required this.maxCompare,
    required this.onTap,
  });

  final int selectedCount;
  final int maxCompare;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SavingsComparisonPage.addProductButtonKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      height: AppSpacing.buttonCompact,
      leading: const Icon(Icons.add_rounded),
      child: Text('Thêm sản phẩm ($selectedCount/$maxCompare)'),
    );
  }
}

class _ProductPickerSheet extends StatelessWidget {
  const _ProductPickerSheet({
    required this.availableProducts,
    required this.selectedCount,
    required this.maxCompare,
    required this.onAdd,
  });

  final List<SavingsProductDraft> availableProducts;
  final int selectedCount;
  final int maxCompare;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Chọn sản phẩm so sánh',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'Đã chọn $selectedCount/$maxCompare sản phẩm',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        if (availableProducts.isEmpty)
          VitCard(
            variant: VitCardVariant.inner,
            padding: EarnSpacingTokens.earnCardPaddingX5,
            child: Text(
              'Đã chọn hết sản phẩm',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          )
        else
          for (final product in availableProducts) ...[
            _PickerProductTile(
              product: product,
              onTap: () => onAdd(product.id),
            ),
            if (product != availableProducts.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
      ],
    );
  }
}

class _PickerProductTile extends StatelessWidget {
  const _PickerProductTile({required this.product, required this.onTap});

  final SavingsProductDraft product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsComparisonPage.pickerOptionKey(product.id),
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onTap,
      child: Row(
        children: [
          _EarnAssetBadge(
            asset: product.asset,
            color: _assetColor(product.asset),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${product.type == SavingsProductType.flexible ? 'Linh hoạt' : 'Cố định ${product.lockDays} ngày'} - ${product.apy} APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.add_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _EmptyComparisonState extends StatelessWidget {
  const _EmptyComparisonState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsComparisonPage.emptyStateKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX5,
      child: Column(
        children: [
          const Icon(
            Icons.compare_arrows_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Text(
            'Chọn ít nhất 2 sản phẩm',
            style: AppTextStyles.baseMedium,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thêm sản phẩm để bắt đầu so sánh chi tiết các chỉ số',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            fullWidth: false,
            leading: const Icon(Icons.add_rounded),
            onPressed: onAdd,
            child: const Text('Thêm sản phẩm'),
          ),
        ],
      ),
    );
  }
}

class _ComparisonDisclaimer extends StatelessWidget {
  const _ComparisonDisclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return EarnInfoBanner(
      key: SavingsComparisonPage.disclaimerKey,
      text: text,
      lineHeight: EarnSpacingTokens.savingsConsumerBodyLineHeight,
    );
  }
}

class _EarnAssetBadge extends StatelessWidget {
  const _EarnAssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x5,
        height: AppSpacing.x5,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: EarnSpacingTokens.savingsConsumerPillLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _cellStyle({
  Color color = AppColors.text1,
  FontWeight fontWeight = AppTextStyles.medium,
}) {
  return AppTextStyles.caption.copyWith(
    color: color,
    fontWeight: fontWeight,
    fontFeatures: AppTextStyles.tabularFigures,
  );
}

double _apyNumber(String value) {
  return double.tryParse(value.replaceAll('%', '')) ?? 0;
}

String _formatCount(int? value, {required String fallback}) {
  if (value == null) return fallback;
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primary,
    _ => AppColors.primary,
  };
}

String _riskLabel(EarnRiskLevel risk) {
  return switch (risk) {
    EarnRiskLevel.low => 'Thấp',
    EarnRiskLevel.medium => 'Trung bình',
    EarnRiskLevel.high => 'Cao',
  };
}

Color _riskColor(EarnRiskLevel risk) {
  return switch (risk) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}
