part of '../../phone/pages/execution/slippage_monitoring_page.dart';

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.summary});

  final TradeSlippageSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        Icons.monitor_heart_outlined,
        _slipPrimary,
        'Total\nEvents',
        summary.total.toString(),
        'Last 24h',
        AppColors.text3,
      ),
      (
        Icons.track_changes_outlined,
        _slipGreen,
        'Avg\nSlippage',
        '${summary.avgSlippage.toStringAsFixed(1)}\nbps',
        '${(summary.avgSlippage / 100).toStringAsFixed(3)}%',
        AppColors.text3,
      ),
      (
        Icons.trending_up_rounded,
        _slipAmber,
        'Max\nSlippage',
        '${summary.maxSlippage.toStringAsFixed(1)}\nbps',
        '${(summary.maxSlippage / 100).toStringAsFixed(2)}%',
        _slipRed,
      ),
      (
        Icons.warning_amber_rounded,
        _slipRed,
        'Critical',
        summary.critical.toString(),
        '${summary.warning} warning',
        _slipRed,
      ),
    ];

    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(child: _StatCard(card: card)),
          if (card != cards.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final (IconData, Color, String, String, String, Color) card;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _slipBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(card.$1, color: card.$2, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.formFieldLabelGap),
              Expanded(
                child: Text(
                  card.$3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              card.$4,
              style: AppTextStyles.body.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            card.$5,
            style: AppTextStyles.micro.copyWith(
              color: card.$6,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
