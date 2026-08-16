part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.snapshot,
    required this.strategy,
    required this.drift,
    required this.onClose,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;
  final double drift;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final actions = _rebalanceActions(snapshot, strategy);
    final totalMove = actions.fold<double>(0, (sum, item) => sum + item.amount);

    return ColoredBox(
      color: AppColors.dynamicIslandBg.withValues(alpha: .55),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: VitCard(
          key: SavingsAutoRebalancePage.previewSheetKey,
          radius: VitCardRadius.large,
          padding: _savingsRebalanceCardPadding,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Xem trước tái cân bằng',
                        style: _baseBold.copyWith(color: AppColors.text1),
                      ),
                    ),
                    VitIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Đóng',
                      onPressed: onClose,
                      variant: VitIconButtonVariant.transparent,
                      size: VitIconButtonSize.md,
                    ),
                  ],
                ),
                _PreviewRow(label: 'Chiến lược', value: strategy.name),
                _PreviewRow(
                  label: 'Drift hiện tại',
                  value: '${drift.toStringAsFixed(1)}%',
                  valueColor: _driftColor(drift),
                ),
                _PreviewRow(
                  label: 'Tổng di chuyển ước tính',
                  value: _formatUsd(totalMove / 2),
                ),
                _PreviewRow(label: 'Số thao tác', value: '${actions.length}'),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final action in actions.take(3))
                  Padding(
                    padding: EarnSpacingTokens.earnBottomPaddingX2,
                    child: Row(
                      children: [
                        Icon(
                          action.increase
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: action.increase
                              ? AppColors.buy
                              : AppColors.sell,
                          size: _savingsRebalanceInlineIcon,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            '${action.increase ? 'Tăng' : 'Giảm'} ${action.asset}',
                            style: _captionMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          _formatUsd(action.amount),
                          style: _captionMedium.copyWith(
                            color: action.increase
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitCtaButton(
                  onPressed: onClose,
                  variant: VitCtaButtonVariant.warning,
                  child: const Text('Xác nhận tái cân bằng'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

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
          Text(value, style: _captionMedium.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _RebalanceActionDraft {
  const _RebalanceActionDraft({
    required this.asset,
    required this.increase,
    required this.amount,
  });

  final String asset;
  final bool increase;
  final double amount;
}

List<_RebalanceActionDraft> _rebalanceActions(
  SavingsAutoRebalanceSnapshot snapshot,
  SavingsRebalanceStrategyDraft strategy,
) {
  return [
    for (final position in snapshot.positions)
      if (position.rebalanceable)
        (() {
          final target =
              strategy.allocations[position.asset] ?? position.targetPct;
          final diff = target - position.currentPct;
          final amount = (diff.abs() / 100) * snapshot.totalPortfolio;
          if (diff.abs() < .5 || amount < snapshot.settings.minTradeSize) {
            return null;
          }
          return _RebalanceActionDraft(
            asset: position.asset,
            increase: diff > 0,
            amount: amount,
          );
        })(),
  ].whereType<_RebalanceActionDraft>().toList();
}
