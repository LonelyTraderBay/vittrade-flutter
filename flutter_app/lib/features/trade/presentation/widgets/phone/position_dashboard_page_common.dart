part of '../../phone/pages/hub/position_dashboard_page.dart';

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final isProfit = position.pnl >= 0;
    final pnlColor = isProfit ? AppColors.buy : AppColors.sell;

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: AppSpacing.zeroInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TypeBadge(type: position.type),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  position.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SideBadge(position: position),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  _formatSignedMoney(position.pnl),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: pnlColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitMetricColumn(
                  label: 'KL',
                  value: _formatAmount(position.size),
                  valueStyle: VitMetricValueStyle.numericCode,
                  gap: AppSpacing.x1,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: 'Giá vào',
                  value: _formatMoney(position.entryPrice),
                  valueStyle: VitMetricValueStyle.numericCode,
                  gap: AppSpacing.x1,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: 'Giá hiện tại',
                  value: _formatMoney(position.currentPrice),
                  valueStyle: VitMetricValueStyle.numericCode,
                  gap: AppSpacing.x1,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: '%P/L',
                  value: _formatSignedPct(position.pnlPct),
                  valueColor: pnlColor,
                  valueStyle: VitMetricValueStyle.numericCode,
                  align: CrossAxisAlignment.end,
                  gap: AppSpacing.x1,
                ),
              ),
            ],
          ),
          if (position.takeProfit != null || position.stopLoss != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.formFieldLabelGap,
              children: [
                if (position.takeProfit != null)
                  _RiskChip(
                    icon: Icons.my_location_rounded,
                    label: 'TP ${_formatMoney(position.takeProfit!)}',
                    status: VitStatusPillStatus.success,
                  ),
                if (position.stopLoss != null)
                  _RiskChip(
                    icon: Icons.shield_outlined,
                    label: 'SL ${_formatMoney(position.stopLoss!)}',
                    status: VitStatusPillStatus.error,
                  ),
                if (position.liquidPrice != null)
                  _RiskChip(
                    icon: Icons.warning_amber_rounded,
                    label: 'Liq ${_formatMoney(position.liquidPrice!)}',
                    status: VitStatusPillStatus.warning,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TradePositionType type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      TradePositionType.spot => 'Spot',
      TradePositionType.futures => 'Futures',
      TradePositionType.margin => 'Margin',
    };
    final status = switch (type) {
      TradePositionType.spot => VitStatusPillStatus.info,
      TradePositionType.futures => VitStatusPillStatus.warning,
      TradePositionType.margin => VitStatusPillStatus.purple,
    };
    return VitStatusPill(
      label: label,
      status: status,
      size: VitStatusPillSize.sm,
    );
  }
}

class _SideBadge extends StatelessWidget {
  const _SideBadge({required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final isLong = position.side == TradePositionSide.long;
    final leverage = position.leverage == null ? '' : ' ${position.leverage}x';
    return VitStatusPill(
      label: '${isLong ? 'LONG' : 'SHORT'}$leverage',
      status: isLong ? VitStatusPillStatus.success : VitStatusPillStatus.error,
      size: VitStatusPillSize.sm,
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({
    required this.icon,
    required this.label,
    required this.status,
  });

  final IconData icon;
  final String label;
  final VitStatusPillStatus status;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: status,
      icon: icon,
      size: VitStatusPillSize.sm,
    );
  }
}

class _EmptyPositions extends StatelessWidget {
  const _EmptyPositions();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      density: VitDensity.tool,
      icon: Icons.bar_chart_rounded,
      title: 'Không có vị thế nào',
    );
  }
}

String _formatSignedMoney(double value) => formatTradeSignedMoney(value);

String _formatSignedPct(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}

String _formatCompactMoney(double value) {
  if (value.abs() >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(1)}K';
  }
  return '\$${_formatMoney(value)}';
}

String _formatMoney(double value) => formatTradeMoney(value);

String _formatAmount(double value) {
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}
