part of '../../phone/pages/dashboard/bot_portfolio_dashboard_page.dart';

const double _portfolioEquityChartExtent = AppSpacing.x7 * 3;
const double _portfolioDistributionChartExtent =
    AppSpacing.x7 * 3 + AppSpacing.x4;

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeBotPortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCardData(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: _portfolioPrimary,
        label: 'Vốn danh mục',
        value: _formatUsd(summary.totalEquity),
      ),
      _SummaryCardData(
        icon: Icons.trending_up_rounded,
        iconColor: _portfolioGreen,
        label: 'Tổng lãi/lỗ',
        value: '+\$${summary.totalPnl.toStringAsFixed(0)}',
        valueColor: _portfolioGreen,
        caption: '+${summary.pnlPercent.toStringAsFixed(1)}%',
        captionColor: _portfolioGreen,
      ),
      _SummaryCardData(
        icon: Icons.show_chart_rounded,
        iconColor: _portfolioPrimary,
        label: 'Sharpe danh mục',
        value: summary.portfolioSharpe.toStringAsFixed(2),
        caption: 'Xuất sắc',
        captionColor: _portfolioGreen,
      ),
      _SummaryCardData(
        icon: Icons.pie_chart_outline_rounded,
        iconColor: _portfolioAmber,
        label: 'Đa dạng hóa',
        value: '${summary.diversificationScore}/100',
        caption: 'Tốt',
        captionColor: _portfolioAmber,
      ),
    ];

    return GridView.count(
      crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
      crossAxisSpacing: TradeSpacingTokens.tradeBotCardGap,
      mainAxisSpacing: TradeSpacingTokens.tradeBotCardGap,
      childAspectRatio: TradeSpacingTokens.tradeBotPortfolioMetricAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [for (final card in cards) _SummaryCard(data: card)],
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.caption,
    this.captionColor = AppColors.text3,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final String? caption;
  final Color captionColor;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _SummaryCardData data;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingLoose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.iconColor, size: 21),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            data.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: data.valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          if (data.caption != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              data.caption!,
              style: AppTextStyles.micro.copyWith(color: data.captionColor),
            ),
          ],
        ],
      ),
    );
  }
}

class _EquityCard extends StatelessWidget {
  const _EquityCard({required this.points});

  final List<TradeBotPortfolioEquityPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPadding,
      child: SizedBox(
        height: _portfolioEquityChartExtent,
        child: CustomPaint(
          painter: _EquityPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.allocations});

  final List<TradeBotPortfolioAllocation> allocations;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: _portfolioDistributionChartExtent,
            child: CustomPaint(
              painter: _DonutPainter(allocations),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          GridView.count(
            crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
            childAspectRatio:
                TradeSpacingTokens.tradeBotAllocationLegendAspectRatio,
            crossAxisSpacing: TradeSpacingTokens.tradeBotSmallGap,
            mainAxisSpacing: TradeSpacingTokens.tradeBotSmallGap,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              for (final item in allocations)
                VitLegendItem(
                  label: item.strategy,
                  value: '\$${item.value.toStringAsFixed(0)}',
                  color: Color(item.colorHex),
                  dotSize: TradeSpacingTokens.tradeBotCardGap,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CorrelationCard extends StatelessWidget {
  const _CorrelationCard({required this.rows});

  final List<TradeBotCorrelationRow> rows;

  @override
  Widget build(BuildContext context) {
    final headers = rows.map((row) => row.bot).toList();
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: _TableHeaderText('Bot', alignLeft: true)),
              for (final header in headers)
                SizedBox(
                  width: TradeSpacingTokens.tradeBotCorrelationColumnWidth,
                  child: _TableHeaderText(header),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.bot,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (final header in headers)
                  SizedBox(
                    width: TradeSpacingTokens.tradeBotCorrelationColumnWidth,
                    child: Center(
                      child: _CorrelationPill(value: row.values[header] ?? 0),
                    ),
                  ),
              ],
            ),
            if (row != rows.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text.rich(
            const TextSpan(
              children: [
                TextSpan(text: 'Tương quan thấp (<0.2) = Đa dạng hóa tốt '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.circle,
                    color: _portfolioGreen,
                    size: TradeSpacingTokens.tradeBotCorrelationLegendDot,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderText extends StatelessWidget {
  const _TableHeaderText(this.text, {this.alignLeft = false});

  final String text;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignLeft ? TextAlign.left : TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _CorrelationPill extends StatelessWidget {
  const _CorrelationPill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value.abs() < .2
        ? _portfolioGreen
        : value.abs() < .5
        ? _portfolioAmber
        : _portfolioRed;
    return VitAccentPill(
      label: value.toStringAsFixed(2),
      accentColor: color,
      semanticStatus: value.abs() < .2
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.warning,
    );
  }
}
