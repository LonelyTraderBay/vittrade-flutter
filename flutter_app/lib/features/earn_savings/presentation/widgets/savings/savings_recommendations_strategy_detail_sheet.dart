part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _StrategyDetailSheet extends StatelessWidget {
  const _StrategyDetailSheet({
    required this.strategy,
    required this.amount,
    required this.savingsRoute,
  });

  final SavingsStrategyDraft strategy;
  final double amount;
  final String savingsRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(strategy.title, style: AppTextStyles.sectionTitle),
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
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            _SmallPill(
              label: 'Match ${strategy.matchScore}%',
              color: strategy.matchScore >= 80
                  ? AppColors.buy
                  : AppColors.primary,
            ),
            _SmallPill(
              label: 'Rủi ro ${_strategyRiskLabel(strategy.riskLevel)}',
              color: _strategyRiskColor(strategy.riskLevel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnPaddingX3,
          child: Column(
            children: [
              _SheetMetric(
                label: 'APY ước tính TB',
                value: _formatPercent(strategy.expectedApy),
                color: AppColors.buy,
              ),
              _SheetMetric(
                label: 'Thanh khoản tức thì',
                value: '${strategy.liquidityRatio}%',
                color: strategy.liquidityRatio >= 50
                    ? AppColors.buy
                    : AppColors.warn,
              ),
              _SheetMetric(
                label: 'Ước tính lãi/năm (${_formatUsd(amount)})',
                value: '+${_formatUsd(amount * strategy.expectedApy / 100)}',
                color: AppColors.buy,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Text(
          'Phân bổ chi tiết',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in strategy.allocation) ...[
          _AllocationDetailRow(item: item, amount: amount),
          if (item != strategy.allocation.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _AllocationBar(allocation: strategy.allocation),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BulletSection(
          title: 'Ưu điểm',
          items: strategy.pros,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BulletSection(
          title: 'Lưu ý / Nhược điểm',
          items: strategy.cons,
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BulletSection(
          title: 'Phù hợp với',
          items: strategy.bestFor,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          key: SavingsRecommendationsPage.detailCtaKey,
          onPressed: () {
            unawaited(HapticFeedback.selectionClick());
            Navigator.of(context).pop();
            context.go(savingsRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Đăng ký sản phẩm theo chiến lược'),
        ),
      ],
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationDetailRow extends StatelessWidget {
  const _AllocationDetailRow({required this.item, required this.amount});

  final SavingsStrategyAllocationDraft item;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(item.asset);
    return Row(
      children: [
        _AssetBadge(asset: item.asset, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  Icon(
                    item.type == SavingsStrategyAllocationType.flexible
                        ? Icons.lock_open_rounded
                        : Icons.lock_outline_rounded,
                    color: item.type == SavingsStrategyAllocationType.flexible
                        ? AppColors.buy
                        : AppColors.warn,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Expanded(
                    child: Text(
                      item.type == SavingsStrategyAllocationType.flexible
                          ? 'Linh hoạt'
                          : 'Cố định ${item.lockDays}D',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    '${_formatPercent(item.apy)} APY ước tính',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
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
              '${item.percentage}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              _formatUsd(amount * item.percentage / 100),
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EarnSpacingTokens.savingsRecommendationsBulletPadding,
                child: SizedBox.square(
                  dimension: AppSpacing.x1,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: color,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppTextStyles.caption.height,
                  ),
                ),
              ),
            ],
          ),
          if (item != items.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}
