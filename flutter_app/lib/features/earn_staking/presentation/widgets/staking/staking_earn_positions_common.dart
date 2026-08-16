part of '../../phone/pages/staking/staking_earn_page.dart';

class _PositionsList extends StatelessWidget {
  const _PositionsList({
    required this.snapshot,
    required this.onExploreProducts,
  });

  final StakingEarnSnapshot snapshot;
  final VoidCallback onExploreProducts;

  @override
  Widget build(BuildContext context) {
    if (snapshot.positions.isEmpty) {
      return VitEmptyState(
        title: 'Chua co vi the stake',
        message:
            'Kham pha san pham de bat dau kiem them tu tai san nhan roi cua ban.',
        icon: Icons.business_center_outlined,
        actionLabel: 'Kham pha san pham',
        actionKey: StakingEarnPage.productsTabKey,
        onAction: onExploreProducts,
      );
    }

    return Column(
      children: [
        for (final position in snapshot.positions) ...[
          _PositionCard(position: position),
          if (position != snapshot.positions.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4X3,
          borderColor: AppModuleAccents.earn.withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppModuleAccents.earn,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Thu nhap uoc tinh',
                    style: AppTextStyles.body.copyWith(
                      color: AppModuleAccents.earn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  for (final item in snapshot.estimatedIncome) ...[
                    Expanded(child: _IncomeEstimate(item: item)),
                    if (item != snapshot.estimatedIncome.last)
                      const SizedBox(width: AppSpacing.x2),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final EarnPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final accent = _productTypeColor(position.type);

    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4X3,
      borderColor: accent.withValues(alpha: 0.28),
      child: Column(
        children: [
          Row(
            children: [
              _AssetBadge(asset: position.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: EarnSpacingTokens
                            .stakingEarnPositionTitleLineHeight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          _productTypeIcon(position.type),
                          color: accent,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Flexible(
                          child: Text(
                            _productTypeLabel(position.type),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: EarnSpacingTokens
                                  .stakingEarnPositionCaptionLineHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    position.apy,
                    style: AppTextStyles.amountSm.copyWith(
                      color: AppModuleAccents.earn,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY uoc tinh',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: EarnSpacingTokens
                          .stakingEarnPositionCaptionLineHeight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _PositionStatRow(
            items: [
              _PositionMetric(label: 'Dang staking', value: position.amount),
              _PositionMetric(
                label: 'Da nhan',
                value: position.earned,
                valueColor: AppColors.buy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _PositionStatRow(
            items: [
              _PositionMetric(label: 'Bat dau', value: position.startDate),
              _PositionMetric(
                label: position.endDate == null ? 'Trang thai' : 'Ket thuc',
                value: position.endDate ?? 'Dang hoat dong',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionStatRow extends StatelessWidget {
  const _PositionStatRow({required this.items});

  final List<_PositionMetric> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: item),
          if (item != items.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3X2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height:
                    EarnSpacingTokens.stakingEarnPositionMetricLabelLineHeight,
              ),
            ),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                height:
                    EarnSpacingTokens.stakingEarnPositionMetricValueLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeEstimate extends StatelessWidget {
  const _IncomeEstimate({required this.item});

  final EarnIncomeEstimateDraft item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3X2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height:
                    EarnSpacingTokens.stakingEarnPositionMetricLabelLineHeight,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              item.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: AppModuleAccents.earn,
                fontWeight: AppTextStyles.bold,
                height:
                    EarnSpacingTokens.stakingEarnPositionMetricValueLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 4 ? asset.substring(0, 4) : asset,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: EarnSpacingTokens.stakingEarnPositionAssetBadgeLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

List<EarnProductDraft> _filteredProducts(
  List<EarnProductDraft> products,
  _EarnFilter filter,
) {
  return switch (filter) {
    _EarnFilter.all => products,
    _EarnFilter.fixed =>
      products
          .where((product) => product.type == EarnProductType.fixed)
          .toList(),
    _EarnFilter.flexible =>
      products
          .where((product) => product.type == EarnProductType.flexible)
          .toList(),
    _EarnFilter.defi =>
      products
          .where((product) => product.type == EarnProductType.defi)
          .toList(),
  };
}

String _filterLabel(_EarnFilter filter) {
  return switch (filter) {
    _EarnFilter.all => 'Tat ca',
    _EarnFilter.fixed => 'Co dinh',
    _EarnFilter.flexible => 'Linh hoat',
    _EarnFilter.defi => 'DeFi',
  };
}

IconData _productTypeIcon(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => Icons.lock_outline_rounded,
    EarnProductType.flexible => Icons.lock_open_rounded,
    EarnProductType.defi => Icons.bolt_rounded,
  };
}

Color _productTypeColor(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => AppColors.warn,
    EarnProductType.flexible => AppColors.buy,
    EarnProductType.defi => AppColors.primary,
  };
}

String _productTypeLabel(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => 'Co dinh',
    EarnProductType.flexible => 'Linh hoat',
    EarnProductType.defi => 'DeFi Pool',
  };
}

Color _productAccent(EarnProductDraft product) {
  return switch (product.riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

String _riskLabel(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => 'Thap',
    EarnRiskLevel.medium => 'Trung binh',
    EarnRiskLevel.high => 'Cao',
  };
}
