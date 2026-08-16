part of '../../phone/pages/provider/trader_profile_page.dart';

class _StatsTab extends StatelessWidget {
  const _StatsTab({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final wins = (trader.totalTrades * trader.winRate / 100).round();
    final losses = trader.totalTrades - wins;
    final rows = [
      _StatRow('Tổng PnL', _signedUsd(trader.totalPnl), _profileGreen),
      _StatRow(
        'ROI tổng',
        '+${trader.totalPnlPct.toStringAsFixed(1)}%',
        _profileGreen,
      ),
      _StatRow(
        'Sharpe Ratio',
        trader.sharpeRatio.toStringAsFixed(2),
        _profileAmber,
      ),
      _StatRow(
        'Max Drawdown',
        '${trader.maxDrawdown.toStringAsFixed(1)}%',
        _profileRed,
      ),
      _StatRow('Avg Holding Time', trader.avgHoldingTime, AppColors.onAccent),
      _StatRow('Tổng lệnh', _formatInt(trader.totalTrades), AppColors.onAccent),
      _StatRow('AUM', _compactUsd(trader.aum), _profilePrimary),
      _StatRow(
        'Copiers',
        '${trader.copiers} / ${trader.maxCopiers}',
        _profilePrimary,
      ),
    ];

    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tỷ lệ thắng/thua',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: AppRadii.pillRadius,
                      child: LinearProgressIndicator(
                        minHeight: AppSpacing.x3,
                        value: trader.winRate / 100,
                        backgroundColor: _profileRed,
                        color: _profileGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Flexible(
                    child: Text(
                      '${trader.winRate.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  _LegendDot(color: _profileGreen, label: 'Thắng: $wins'),
                  const SizedBox(width: AppSpacing.x2),
                  _LegendDot(color: _profileRed, label: 'Thua: $losses'),
                ],
              ),
            ],
          ),
        ),
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Thống kê chi tiết',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              for (final row in rows) _StatsLine(row: row),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow {
  const _StatRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}

class _StatsLine extends StatelessWidget {
  const _StatsLine({required this.row});

  final _StatRow row;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x1,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  row.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                row.value,
                style: AppTextStyles.caption.copyWith(
                  color: row.color,
                  fontWeight: AppTextStyles.medium,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.hairlineStroke,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: AppSpacing.x3),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: child,
    );
  }
}

class _RiskPresentation {
  const _RiskPresentation(this.color, this.label);

  final Color color;
  final String label;
}

_RiskPresentation _riskPresentation(TradeCopyRiskLevel level) {
  return switch (level) {
    TradeCopyRiskLevel.low => const _RiskPresentation(_profileGreen, 'Thấp'),
    TradeCopyRiskLevel.medium => const _RiskPresentation(
      _profileAmber,
      'Trung bình',
    ),
    TradeCopyRiskLevel.high => const _RiskPresentation(_profileRed, 'Cao'),
  };
}

extension _TakeLast<T> on Iterable<T> {
  List<T> takeLast(int count) {
    final list = toList(growable: false);
    if (list.length <= count) return list;
    return list.sublist(list.length - count);
  }
}

String _signedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatMoney(value.abs())}';
}

String _compactUsd(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(value >= 10000000 ? 1 : 2)}M';
  }
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) => formatTradeMoney(value);

String _formatPrice(double value) {
  return value
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}

String _formatInt(int value) => formatTradeInt(value);
