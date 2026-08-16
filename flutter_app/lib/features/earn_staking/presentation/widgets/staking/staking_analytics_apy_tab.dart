part of '../../phone/pages/staking/staking_analytics_page.dart';

class _ApyTab extends StatelessWidget {
  const _ApyTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Xu hướng APY (6 tháng)',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        VitCard(
          key: StakingAnalyticsPage.apyChartKey,
          padding: _stakingAnalyticsCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _stakingAnalyticsChartHeight,
                child: Row(
                  children: [
                    const _YAxisLabels(
                      labels: ['25%', '20%', '15%', '10%', '5%'],
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomPaint(
                              painter: _ApyTrendPainter(
                                points: snapshot.apyTrends,
                              ),
                              size: Size.infinite,
                            ),
                          ),
                          const SizedBox(
                            height: AppSpacing.pageRhythmCompactInnerGap,
                          ),
                          _DateLabels(
                            dates: snapshot.apyTrends
                                .map((p) => p.date)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const _LegendRow(
                entries: [
                  _LegendEntry(label: 'Linh hoạt', color: AppColors.buy),
                  _LegendEntry(label: 'Cố định', color: AppColors.primarySoft),
                  _LegendEntry(label: 'DeFi', color: AppColors.warn),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const _InsightBox(
                text:
                    'APY DeFi biến động cao do thanh khoản pool thay đổi. APY Fixed và Flexible ổn định hơn trong cùng kỳ.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ApyTrendPainter extends CustomPainter {
  const _ApyTrendPainter({required this.points});

  final List<StakingApyTrendPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.flexible).toList(),
      maxValue: 25,
      color: AppColors.buy,
    );
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.fixed).toList(),
      maxValue: 25,
      color: AppColors.primarySoft,
    );
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.defi).toList(),
      maxValue: 25,
      color: AppColors.warn,
    );
  }

  @override
  bool shouldRepaint(covariant _ApyTrendPainter oldDelegate) =>
      oldDelegate.points != points;
}

void _drawLine(
  Canvas canvas,
  Size size, {
  required List<double> values,
  required double maxValue,
  required Color color,
}) {
  if (values.length < 2) return;
  final path = _linePath(size, values, maxValue);
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  canvas.drawPath(path, paint);
  final dotPaint = Paint()..color = color;
  for (var i = 0; i < values.length; i++) {
    canvas.drawCircle(
      Offset(_x(size, i, values.length), _y(size, values[i], maxValue)),
      3,
      dotPaint,
    );
  }
}
