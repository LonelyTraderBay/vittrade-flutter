part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.history});

  final List<SavingsRebalanceHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '${history.length} lần tái cân bằng',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [for (final event in history) _HistoryCard(event: event)],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.event});

  final SavingsRebalanceHistoryDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _historyColor(event.status);

    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _savingsRebalanceIconBox,
            child: Material(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
              child: Icon(
                _historyIcon(event.status),
                color: color,
                size: _savingsRebalanceIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.strategy,
                      style: _captionMedium.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitAccentPill(
                      label: _historyLabel(event.status),
                      accentColor: color,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${event.date} · ${event.actions} thao tác · ${_formatUsd(event.totalMoved)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '${event.driftBefore.toStringAsFixed(1)}% → ${event.driftAfter.toStringAsFixed(1)}%',
            style: _captionMedium.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

Color _historyColor(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return AppColors.buy;
    case SavingsRebalanceHistoryStatus.partial:
      return AppColors.primary;
    case SavingsRebalanceHistoryStatus.failed:
      return AppColors.sell;
  }
}

String _historyLabel(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return 'Hoàn tất';
    case SavingsRebalanceHistoryStatus.partial:
      return 'Một phần';
    case SavingsRebalanceHistoryStatus.failed:
      return 'Thất bại';
  }
}

IconData _historyIcon(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return Icons.check_circle_outline_rounded;
    case SavingsRebalanceHistoryStatus.partial:
      return Icons.warning_amber_rounded;
    case SavingsRebalanceHistoryStatus.failed:
      return Icons.error_outline_rounded;
  }
}
