part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    super.key,
    required this.strategy,
    required this.amount,
    required this.onTap,
  });

  final SavingsStrategyDraft strategy;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      borderColor: strategy.recommended ? AppColors.primary : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (strategy.recommended) ...[
            const Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
                SizedBox(width: AppSpacing.x2),
                _SmallPill(
                  label: 'Phù hợp nhất với bạn',
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strategy.title, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
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
                    _formatPercent(strategy.expectedApy),
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY ước tính',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _AllocationBar(allocation: strategy.allocation),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final item in strategy.allocation)
                _AllocationChip(item: item),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              _SmallPill(
                label: 'Match ${strategy.matchScore}%',
                color: strategy.matchScore >= 80
                    ? AppColors.buy
                    : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallPill(
                label: _strategyRiskLabel(strategy.riskLevel),
                color: _strategyRiskColor(strategy.riskLevel),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '+${_formatUsd(amount * strategy.expectedApy / 100)}/năm',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationBar extends StatelessWidget {
  const _AllocationBar({required this.allocation});

  final List<SavingsStrategyAllocationDraft> allocation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: Row(
        children: [
          for (final item in allocation)
            Expanded(
              flex: item.percentage,
              child: ColoredBox(
                color: _assetColor(item.asset),
                child: const SizedBox(
                  height: AppSpacing.pageRhythmCompactInnerGap,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AllocationChip extends StatelessWidget {
  const _AllocationChip({required this.item});

  final SavingsStrategyAllocationDraft item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          '${item.asset} ${item.percentage}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
