part of '../../phone/pages/staking/staking_earn_page.dart';

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<EarnProductDraft> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const VitEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Không có sản phẩm phù hợp',
        message: 'Thử đổi bộ lọc để xem thêm lựa chọn sinh lời.',
      );
    }

    return Column(
      children: [
        for (final product in products) ...[
          _ProductCard(product: product),
          if (product != products.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final EarnProductDraft product;

  @override
  Widget build(BuildContext context) {
    final accent = _productAccent(product);

    return VitCard(
      key: StakingEarnPage.productKey(product.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssetBadge(asset: product.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        VitStatusPill(
                          label: _productTypeLabel(product.type),
                          status: VitStatusPillStatus.neutral,
                          icon: _productTypeIcon(product.type),
                          size: VitStatusPillSize.sm,
                        ),
                        if (product.isHot)
                          const _StatusBadge(
                            label: 'HOT',
                            color: AppColors.sell,
                            background: AppColors.sell10,
                          ),
                        if (product.isNew)
                          const _StatusBadge(
                            label: 'MOI',
                            color: AppColors.primary,
                            background: AppColors.primary12,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${product.lockLabel} · ${product.participants}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.apy,
                    style: AppTextStyles.amountXs.copyWith(
                      color: AppModuleAccents.earn,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY uoc tinh',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  if (product.boostApy != null)
                    Text(
                      'Toi da ${product.boostApy!.replaceFirst('Max ', '')}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Da staking: ${product.totalStaked}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              VitStatusPill(
                label: 'Rui ro: ${_riskLabel(product.riskLevel)}',
                status: _riskPillStatus(product.riskLevel),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitProgressBar(progress: product.progress, color: accent),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            height: AppSpacing.inputHeight - AppSpacing.x1,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              unawaited(
                showVitNoticeSheet(
                  context: context,
                  title: 'Sẽ sớm ra mắt',
                  message: 'Xem chi tiết sản phẩm sẽ sớm ra mắt',
                ),
              );
            },
            child: const Text('Xem chi tiet'),
          ),
        ],
      ),
    );
  }
}

VitStatusPillStatus _riskPillStatus(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => VitStatusPillStatus.success,
    EarnRiskLevel.medium => VitStatusPillStatus.warning,
    EarnRiskLevel.high => VitStatusPillStatus.error,
  };
}
