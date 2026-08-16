part of '../../phone/pages/research/token_info_page.dart';

class _SupplyCard extends StatelessWidget {
  const _SupplyCard({required this.fundamentals, required this.supplyPct});

  final TokenFundamentalsDraft fundamentals;
  final double? supplyPct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _tokenInfoSupplyCardPadding,
      child: Column(
        children: [
          _MetricLine(
            label: 'Lưu hành',
            value:
                '${_formatCompact(fundamentals.circulatingSupply)} ${fundamentals.symbol}',
          ),
          if (supplyPct != null) ...[
            const SizedBox(height: _tokenInfoMetricGap),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.swatchRadius,
                    child: LinearProgressIndicator(
                      minHeight: _tokenInfoSupplyProgressHeight,
                      value: (supplyPct! / 100).clamp(0, 1).toDouble(),
                      backgroundColor: AppColors.surface3,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primarySoft,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: _tokenInfoSupplyProgressGap),
                Text(
                  '${supplyPct!.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: _tokenInfoMetricGap),
          _MetricLine(
            label: 'Tổng cung',
            value:
                '${_formatCompact(fundamentals.totalSupply)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Cung toi da',
            value:
                '${_formatCompact(fundamentals.maxSupply ?? 0)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Ty le lam phat',
            value: '+${fundamentals.inflationRate.toStringAsFixed(2)}%',
            valueColor: AppColors.warn,
          ),
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.label,
    required this.value,
    this.muted = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool muted;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _tokenInfoMetricLinePadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor ?? (muted ? AppColors.text2 : AppColors.text1),
              fontWeight: muted ? AppTextStyles.medium : AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.distribution});

  final List<SupplyDistributionDraft> distribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _tokenInfoSupplyCardPadding,
      child: Row(
        children: [
          CustomPaint(
            size: const Size.square(_tokenInfoDonutSize),
            painter: _DonutPainter(distribution),
          ),
          const SizedBox(width: _tokenInfoDistributionGap),
          Expanded(
            child: Column(
              children: [
                for (final item in distribution)
                  Padding(
                    padding: _tokenInfoMetricLinePadding,
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: _tokenInfoDistributionDot,
                          color: item.color.resolve(),
                        ),
                        const SizedBox(width: _tokenInfoDistributionDotGap),
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Text(
                          '${item.percentage.toStringAsFixed(1)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.distribution);

  final List<SupplyDistributionDraft> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _tokenInfoDonutStroke
      ..strokeCap = StrokeCap.butt;
    for (final item in distribution) {
      final sweep = math.pi * 2 * (item.percentage / 100);
      canvas.drawArc(
        rect.deflate(_tokenInfoDonutInset),
        start,
        sweep,
        false,
        paint..color = item.color.resolve(),
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.distribution != distribution;
  }
}

class _AthAtlCards extends StatelessWidget {
  const _AthAtlCards({
    required this.fundamentals,
    required this.athDropPct,
    required this.atlGainPct,
  });

  final TokenFundamentalsDraft fundamentals;
  final double athDropPct;
  final double atlGainPct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PriceRecordCard(
            label: 'ATH',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            value: formatMarketPriceFixed2(fundamentals.allTimeHigh),
            date: fundamentals.allTimeHighDate,
            delta: '${athDropPct.toStringAsFixed(1)}% so voi ATH',
            deltaColor: AppColors.sell,
          ),
        ),
        const SizedBox(width: _tokenInfoRecordCardGap),
        Expanded(
          child: _PriceRecordCard(
            label: 'ATL',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            value: formatMarketPriceFixed2(fundamentals.allTimeLow),
            date: fundamentals.allTimeLowDate,
            delta: '+${atlGainPct.toStringAsFixed(1)}% so voi ATL',
            deltaColor: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _PriceRecordCard extends StatelessWidget {
  const _PriceRecordCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.date,
    required this.delta,
    required this.deltaColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String value;
  final String date;
  final String delta;
  final Color deltaColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _tokenInfoRecordCardPadding,
      borderColor: color.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: _tokenInfoRecordIcon, color: color),
              const SizedBox(width: _tokenInfoRecordIconGap),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _tokenInfoRecordValueGap),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            date,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _tokenInfoRecordDeltaGap),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: deltaColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLink extends StatelessWidget {
  const _ChartLink({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TokenInfoPage.chartButtonKey,
      onTap: () => context.go(AppRoutePaths.pairDetail(pairId)),
      padding: _tokenInfoChartCardPadding,
      child: Row(
        children: [
          SizedBox(
            width: _tokenInfoChartIconBox,
            height: _tokenInfoChartIconBox,
            child: Material(
              color: _marketPrimary.withValues(alpha: 0.12),
              borderRadius: AppRadii.cardRadius,
              child: const Icon(Icons.bar_chart_rounded, color: _marketPrimary),
            ),
          ),
          const SizedBox(width: _tokenInfoChartIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem bieu do & giao dich',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _tokenInfoChartSubtitleGap),
                Text(
                  'Chart, so lenh, giao dich gan day',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}
