part of '../../phone/pages/savings/savings_page.dart';

class _SavingsTabs extends StatelessWidget {
  const _SavingsTabs({
    required this.activeTab,
    required this.positionCount,
    required this.onChanged,
  });

  final _SavingsTab activeTab;
  final int positionCount;
  final ValueChanged<_SavingsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(_SavingsTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: _SavingsTab.products.name,
          label: 'Sản phẩm',
          icon: Icons.inventory_2_outlined,
          widgetKey: SavingsPage.productsTabKey,
        ),
        VitTabItem(
          key: _SavingsTab.my.name,
          label: 'Đăng ký ($positionCount)',
          icon: Icons.business_center_outlined,
          widgetKey: SavingsPage.myTabKey,
        ),
      ],
    );
  }
}

class _SavingsFilters extends StatelessWidget {
  const _SavingsFilters({required this.activeFilter, required this.onChanged});

  final _SavingsFilter activeFilter;
  final ValueChanged<_SavingsFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<_SavingsFilter>(
      accentColor: AppModuleAccents.earn,
      selectedValue: activeFilter,
      onTap: onChanged,
      items: [
        for (final filter in _SavingsFilter.values)
          VitPresetChipItem(
            value: filter,
            label: _filterLabel(filter),
            key: SavingsPage.filterKey(filter.name),
            semanticLabel: 'Lọc sản phẩm ${_filterLabel(filter)}',
          ),
      ],
    );
  }
}

class _SavingsProductList extends StatelessWidget {
  const _SavingsProductList({
    required this.products,
    required this.detailRoute,
  });

  final List<SavingsProductDraft> products;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const VitEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Không có sản phẩm phù hợp',
        message: 'Thử đổi bộ lọc để xem thêm lựa chọn tiết kiệm.',
      );
    }

    return Column(
      children: [
        for (final product in products) ...[
          _SavingsProductCard(product: product, detailRoute: detailRoute),
          if (product != products.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _SavingsProductCard extends StatelessWidget {
  const _SavingsProductCard({required this.product, required this.detailRoute});

  final SavingsProductDraft product;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    final accent = _productAccent(product);

    return VitCard(
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
                          label: product.type == SavingsProductType.flexible
                              ? 'Linh hoạt'
                              : 'Cố định',
                          status: VitStatusPillStatus.neutral,
                          icon: product.type == SavingsProductType.flexible
                              ? Icons.lock_open_rounded
                              : Icons.lock_outline_rounded,
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
                            label: 'MỚI',
                            color: AppColors.primary,
                            background: AppColors.primary12,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _productSubtitle(product),
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
                    'APY ước tính',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  if (product.maxApy != null)
                    Text(
                      'Tối đa ${product.maxApy}',
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
                  'Đã ký: ${product.totalSubscribed}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              VitStatusPill(
                label: 'Rủi ro: ${_riskLabel(product.riskLevel)}',
                status: _riskPillStatus(product.riskLevel),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitProgressBar(
            progress: product.progress,
            color: product.progress > 0.85 ? AppColors.sell : accent,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: product.id == 'sav001'
                      ? SavingsPage.productDetailButtonKey
                      : null,
                  onPressed: () => context.go(detailRoute),
                  variant: VitCtaButtonVariant.secondary,
                  height: EarnSpacingTokens.savingsConsumerActionHeight,
                  trailing: const Icon(Icons.chevron_right_rounded),
                  child: const Text('Chi tiết'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  height: EarnSpacingTokens.savingsConsumerActionHeight,
                  onPressed: () => HapticFeedback.selectionClick(),
                  child: const Text('Đăng ký'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
