part of '../../phone/pages/dashboard/bot_history_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.totalTrades,
    required this.totalPnL,
    required this.totalFees,
  });

  final int totalTrades;
  final double totalPnL;
  final double totalFees;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              label: 'Tổng số giao dịch',
              value: '$totalTrades',
              color: AppColors.text1,
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: 'Tổng lãi/lỗ',
              value: _formatSignedMoney(totalPnL),
              color: totalPnL >= 0 ? _historyGreen : _historyRed,
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: 'Tổng phí',
              value: '\$${totalFees.toStringAsFixed(2)}',
              color: AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
