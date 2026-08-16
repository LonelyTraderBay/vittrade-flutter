part of '../../phone/pages/staking/staking_analytics_page.dart';

class _RoiTab extends StatelessWidget {
  const _RoiTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'ROI: Staking vs Holding',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        VitCard(
          key: StakingAnalyticsPage.roiChartKey,
          padding: _stakingAnalyticsCardPadding,
          child: Column(
            children: [
              SizedBox(
                height: _stakingAnalyticsChartHeight,
                child: CustomPaint(
                  painter: _RoiBarPainter(points: snapshot.roiComparison),
                  size: Size.infinite,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const _LegendRow(
                entries: [
                  _LegendEntry(label: 'Staking', color: AppColors.buy),
                  _LegendEntry(label: 'Holding', color: AppColors.sell),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const _InsightBox(
                text:
                    'Staking cho ROI cao hơn holding sau 6 tháng nhờ phần thưởng hằng ngày, nhưng lợi nhuận vẫn phụ thuộc biến động tài sản.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoiBarPainter extends CustomPainter {
  const _RoiBarPainter({required this.points});

  final List<StakingRoiComparisonPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    if (points.isEmpty) return;

    final baselineY = _y(size, 0, 16, minValue: -4);
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      Paint()
        ..color = AppColors.borderSolid
        ..strokeWidth = 1,
    );

    final groupWidth = size.width / points.length;
    final barWidth = math.min(15.0, groupWidth * 0.25);
    for (var i = 0; i < points.length; i++) {
      final center = groupWidth * i + groupWidth / 2;
      _paintBar(
        canvas,
        size,
        x: center - barWidth - 2,
        width: barWidth,
        value: points[i].staking,
        color: AppColors.buy,
      );
      _paintBar(
        canvas,
        size,
        x: center + 2,
        width: barWidth,
        value: points[i].holding,
        color: AppColors.sell,
      );
    }
  }

  void _paintBar(
    Canvas canvas,
    Size size, {
    required double x,
    required double width,
    required double value,
    required Color color,
  }) {
    final baselineY = _y(size, 0, 16, minValue: -4);
    final valueY = _y(size, value, 16, minValue: -4);
    final top = math.min(baselineY, valueY);
    final height = (baselineY - valueY).abs().clamp(3.0, size.height);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, top, width, height),
      AppRadii.xsCorner,
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RoiBarPainter oldDelegate) =>
      oldDelegate.points != points;
}
