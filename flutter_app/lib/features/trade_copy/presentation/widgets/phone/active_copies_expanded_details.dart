part of '../../phone/pages/hub/active_copies_page.dart';

class _ExpandedCopyDetails extends StatelessWidget {
  const _ExpandedCopyDetails({
    required this.copy,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final TradeActiveCopy copy;
  final VoidCallback onViewDetails;
  final VoidCallback onConfigure;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.cardBorder,
        ),
        Padding(
          padding: TradeSpacingTokens.activeCopiesDetailsPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Performance (30 ngày)',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _MiniPerformanceStrip(points: copy.performanceHistory),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _DetailStat(
                      label: 'Số lượng trades',
                      value: '${copy.trades}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _DetailStat(
                      label: 'Win rate',
                      value: '${copy.winRate.toStringAsFixed(1)}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _DetailStat(
                      label: 'Copy mode',
                      value: _copyModeLabel(copy),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _DetailStat(
                      label: 'Stop-loss',
                      value: copy.hasCustomStopLoss
                          ? '-${copy.stopLossLevel?.toStringAsFixed(0)}%'
                          : 'Provider',
                    ),
                  ),
                ],
              ),
              if (copy.recentTrades.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Trades gần đây',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    VitCtaButton(
                      key: ActiveCopiesPage.detailsKey(copy.id),
                      onPressed: onViewDetails,
                      density: VitDensity.tool,
                      variant: VitCtaButtonVariant.ghost,
                      height: AppSpacing.buttonCompact,
                      fullWidth: false,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.x2,
                      ),
                      child: Text(
                        'Xem tất cả',
                        style: AppTextStyles.micro.copyWith(
                          color: _copyPrimary,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final trade in copy.recentTrades.take(3)) ...[
                  _RecentTradeRow(trade: trade),
                  if (trade != copy.recentTrades.take(3).last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                ],
              ],
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      key: ActiveCopiesPage.configureKey(copy.id),
                      label: 'Điều chỉnh',
                      icon: Icons.settings_rounded,
                      onTap: onConfigure,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _ActionButton(
                      key: ActiveCopiesPage.stopKey(copy.id),
                      label: 'Dừng copy',
                      icon: Icons.stop_rounded,
                      danger: true,
                      onTap: onStop,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniPerformanceStrip extends StatelessWidget {
  const _MiniPerformanceStrip({required this.points});

  final List<TradeCopyPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    final first = points.isEmpty ? 0.0 : points.first.value;
    final last = points.isEmpty ? 0.0 : points.last.value;
    final positive = last >= first;
    final color = positive ? AppColors.buy : AppColors.sell;
    final values = points.length < 2
        ? const [0.0, 0.0]
        : points.map((point) => point.value).toList(growable: false);

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: SizedBox(
        height: AppSpacing.x6,
        child: VitSparkline(
          values: values,
          color: color,
          showFill: false,
          strokeWidth: AppSpacing.dividerHairline,
        ),
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.activeCopiesSmallCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTradeRow extends StatelessWidget {
  const _RecentTradeRow({required this.trade});

  final TradeCopyRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final sideColor = trade.side == TradeOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.activeCopiesSmallCardPadding,
      child: Row(
        children: [
          VitAccentPill(
            label: trade.side == TradeOrderSide.buy ? 'BUY' : 'SELL',
            accentColor: sideColor,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              trade.pair,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            _formatSignedUsd(trade.pnl),
            style: AppTextStyles.micro.copyWith(
              color: trade.pnl >= 0 ? AppColors.buy : AppColors.sell,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      density: VitDensity.tool,
      variant: danger
          ? VitCtaButtonVariant.danger
          : VitCtaButtonVariant.secondary,
      leading: Icon(icon),
      padding: TradeSpacingTokens.activeCopiesActionPadding,
      child: Text(label),
    );
  }
}
