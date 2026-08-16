part of '../../phone/pages/execution/market_data_analytics_page.dart';

class _TopTradersCard extends StatelessWidget {
  const _TopTradersCard({required this.data});

  final TradeTopTraderPositions data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          const _CardHeader(
            icon: Icons.visibility_rounded,
            iconColor: _analyticsAmber,
            title: 'Top Traders',
            badge: 'Long',
          ),
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            variant: VitCardVariant.inner,
            borderColor: _analyticsGreen.withValues(alpha: .2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Top traders dang Long',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                Text(
                  '${data.longPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.heroNumber.copyWith(
                    color: _analyticsGreen,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  'of top traders are long',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _RatioBar(longPct: data.longPct),
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            variant: VitCardVariant.inner,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24h Change',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        'Shifted ${data.change24h.toStringAsFixed(1)}% to Long',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: AppSpacing.x4,
                  backgroundColor: _analyticsGreen.withValues(alpha: .12),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: _analyticsGreen,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          _InfoStrip(
            iconColor: _analyticsAmber,
            bg: _analyticsAmber.withValues(alpha: .06),
            text:
                'Top traders = accounts voi volume cao nhat. Thuong la whales, institutions. Theo trend cua ho co the profitable.',
          ),
        ],
      ),
    );
  }
}

class _FundingRateCard extends StatelessWidget {
  const _FundingRateCard({required this.data});

  final TradeFundingRateHistory data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          _CardHeader(
            icon: Icons.attach_money_rounded,
            iconColor: _analyticsPrimary,
            title: 'Funding Rate',
            badge: '+${data.currentRatePct.toStringAsFixed(3)}%',
            badgeColor: _analyticsRed,
          ),
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            variant: VitCardVariant.inner,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Next funding in',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    data.nextFundingLabel,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: _analyticsPrimary,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBubble(
                  label: 'Current',
                  value: '+${data.currentRatePct.toStringAsFixed(3)}%',
                  color: _analyticsRed,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBubble(
                  label: '24h Avg',
                  value: '${data.avgRatePct.toStringAsFixed(3)}%',
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBubble(
                  label: 'Range',
                  value: '${data.rangePct.toStringAsFixed(3)}%',
                ),
              ),
            ],
          ),
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            variant: VitCardVariant.inner,
            child: AspectRatio(
              aspectRatio: 4.4,
              child: CustomPaint(
                painter: _FundingLinePainter(values: data.historyPct),
              ),
            ),
          ),
          const _InfoStrip(
            text:
                'Funding rate duong (do) = Long tra Short. Am (xanh) = Short tra Long. Thanh toan moi 8 gio.',
          ),
        ],
      ),
    );
  }
}

class _FundingLinePainter extends CustomPainter {
  const _FundingLinePainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final span = math.max(maxValue - minValue, .001);
    final zeroY = size.height * (maxValue / span).clamp(0, 1);
    final gridPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .18)
      ..strokeWidth = AppSpacing.dividerHairline;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), gridPaint);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minValue) / span * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = _analyticsRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.hairlineStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FundingLinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
