part of '../../phone/pages/execution/best_execution_reports_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      density: VitDensity.tool,
      title: 'MiFID II RTS 27/28 Compliance',
      message:
          'Quarterly disclosure of Top 5 execution venues by trading volume. Review price, cost, speed, execution likelihood, settlement, and next steps before publishing.',
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeBestExecutionSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.bar_chart_rounded,
            iconColor: _bestPrimary,
            label: 'Total Orders',
            value: _formatInt(summary.totalOrders),
            subtitle: 'Q1 2026 (YTD)',
          ),
        ),
        const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
        Expanded(
          child: _SummaryCard(
            icon: Icons.attach_money_rounded,
            iconColor: _bestGreen,
            label: 'Total Value',
            value: '\$${(summary.totalValue / 1000000000).toStringAsFixed(2)}B',
            subtitle: 'Executed value',
          ),
        ),
        const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
        Expanded(
          child: _SummaryCard(
            icon: Icons.workspace_premium_outlined,
            iconColor: _bestAmber,
            label: 'Avg Score',
            value: summary.avgScore.toStringAsFixed(1),
            subtitle: 'Quality index',
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _bestBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 15),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
