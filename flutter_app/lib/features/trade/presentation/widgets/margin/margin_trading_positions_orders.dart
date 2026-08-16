part of '../../phone/pages/margin/margin_trading_page.dart';

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});

  final List<TradeMarginPosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return _Panel(
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.pageRhythmFormSectionGap,
          top: AppSpacing.searchBarCompactHeight,
          right: AppSpacing.pageRhythmFormSectionGap,
          bottom: AppSpacing.searchBarCompactHeight,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              'Chưa có vị thế',
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final position in positions) ...[
          _PositionCard(position: position),
          if (position != positions.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final TradeMarginPosition position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? _marginGreen : _marginRed;
    return _Panel(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(position.pair, style: AppTextStyles.baseMedium),
              const SizedBox(width: AppSpacing.x3),
              _MiniBadge(
                label: '${position.side.toUpperCase()} ${position.leverage}x',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _ValueText('PnL', _signedMoney(position.pnl), color),
              ),
              Expanded(
                child: _ValueText(
                  'Liq. Price',
                  _formatPrice(position.liquidationPrice),
                  _marginRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
