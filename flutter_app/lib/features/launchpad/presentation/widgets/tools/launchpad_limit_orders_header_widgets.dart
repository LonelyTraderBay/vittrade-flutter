part of '../../phone/pages/tools/launchpad_limit_orders_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final LaunchpadLimitOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadLimitOrdersPage.statsKey,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          _StatCell(
            label: 'Active',
            value: '${snapshot.activeOrders.length}',
            color: AppColors.primary,
          ),
          _StatCell(
            label: 'Filled 24h',
            value: '${snapshot.filled24h}',
            color: AppColors.buy,
          ),
          _StatCell(
            label: 'Value',
            value: snapshot.totalValueLabel,
            color: AppColors.text1,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(value, style: AppTextStyles.amountSm.copyWith(color: color)),
        ],
      ),
    );
  }
}
