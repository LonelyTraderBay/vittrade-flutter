import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_portfolio_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_formatters.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_overview.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class PositionsTab extends StatelessWidget {
  const PositionsTab({
    super.key,
    required this.snapshot,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final SavingsPortfolioSnapshot snapshot;
  final PositionFilter activeFilter;
  final ValueChanged<PositionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final positions = snapshot.positions.where((position) {
      return switch (activeFilter) {
        PositionFilter.all => true,
        PositionFilter.flexible => position.type == SavingsProductType.flexible,
        PositionFilter.locked => position.type == SavingsProductType.locked,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTabBar(
          activeKey: activeFilter.name,
          onChanged: (key) =>
              onFilterChanged(PositionFilter.values.byName(key)),
          tabs: const [
            VitTabItem(key: 'all', label: 'Tất cả'),
            VitTabItem(key: 'flexible', label: 'Linh hoạt'),
            VitTabItem(key: 'locked', label: 'Cố định'),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final position in positions) ...[
          _PositionCard(position: position),
          if (position != positions.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final SavingsPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = assetColor(position.asset);
    return VitCard(
      radius: VitCardRadius.large,
      padding: savingsPortfolioCardPadding,
      child: Row(
        children: [
          AssetBadge(asset: position.asset, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.product,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${position.amount} - ${position.apy} APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                position.earned,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                position.usdValue,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EarningsTab extends StatelessWidget {
  const EarningsTab({
    super.key,
    required this.snapshot,
    required this.hideBalance,
  });

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: savingsPortfolioCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Tổng lãi nhận được',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: StatusPill(label: '+0.752%', color: AppColors.buy),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                hideBalance ? '••••••' : '+\$77.72',
                style: AppTextStyles.numericDisplayXl.copyWith(
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'APY ${snapshot.weightedApy} - Lãi tiết kiệm',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const SectionLabel(label: 'Lãi theo tài sản', color: AppColors.accent),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: savingsPortfolioCardPadding,
          child: Column(
            children: [
              for (final position in snapshot.positions) ...[
                AllocationRow(position: position),
                if (position != snapshot.positions.last)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
