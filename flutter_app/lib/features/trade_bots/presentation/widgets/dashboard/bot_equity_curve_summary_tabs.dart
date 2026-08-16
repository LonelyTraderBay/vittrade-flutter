part of '../../phone/pages/dashboard/bot_equity_curve_page.dart';

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.summary});

  final TradeBotEquityCurveSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Lợi nhuận Bot',
        '+${summary.botReturnPct.toStringAsFixed(1)}%',
        _equityGreen,
      ),
      (
        'Buy & Hold',
        '+${summary.buyHoldReturnPct.toStringAsFixed(1)}%',
        AppColors.text1,
      ),
      ('Alpha', '+${summary.alphaPct.toStringAsFixed(1)}%', _equityGreen),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _Card(
              padding: TradeSpacingTokens.tradeBotCompactPanelPadding,
              child: SizedBox(
                height: _equitySummaryMetricExtent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      items[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.formFieldLabelGap),
                    Text(
                      items[i].$2,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: items[i].$3,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}
