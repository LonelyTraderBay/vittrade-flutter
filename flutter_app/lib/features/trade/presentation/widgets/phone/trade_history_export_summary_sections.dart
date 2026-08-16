part of '../../phone/pages/hub/trade_history_export_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stats});

  final TradeExportStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Tổng lệnh',
                  value: _formatInteger(stats.totalTrades),
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Tổng KL giao dịch',
                  value: _formatCompact(stats.totalVolume),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Tổng phí',
                  value: _formatMoney(stats.totalFees),
                  color: AppColors.primarySoft,
                  small: true,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Lãi/Lỗ ròng',
                  value: '+${_formatMoney(stats.netPnl)}',
                  color: AppColors.buy,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (small ? AppTextStyles.body : AppTextStyles.baseMedium)
              .copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}
