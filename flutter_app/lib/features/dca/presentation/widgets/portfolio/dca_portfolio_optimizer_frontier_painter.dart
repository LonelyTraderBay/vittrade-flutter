part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _FrontierChartPainter extends CustomPainter {
  const _FrontierChartPainter(this.points);

  final List<DcaFrontierPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width - AppSpacing.x6 - AppSpacing.x3,
      size.height - AppSpacing.x6,
    );
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .45)
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final x = chart.left + chart.width * i / 3;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      axisPaint,
    );

    for (final point in points) {
      final x = chart.left + chart.width * (point.riskPercent / 60);
      final y = chart.bottom - chart.height * (point.returnPercent / 60);
      final active = point.label == 'Optimal (Max Sharpe)';
      final paint = Paint()
        ..color = active ? AppColors.accent : AppColors.accent30;
      canvas.drawCircle(
        Offset(x, y),
        active ? AppSpacing.x3 : AppSpacing.x2,
        paint,
      );
      if (active) {
        canvas.drawCircle(
          Offset(x, y),
          AppSpacing.x4,
          Paint()
            ..color = AppColors.accent20
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }

    _paintChartLabel(
      canvas,
      'Rủi ro (%)',
      Offset(chart.center.dx - AppSpacing.x6, size.height - AppSpacing.x3),
    );
    canvas.save();
    canvas.translate(AppSpacing.x3, chart.center.dy + AppSpacing.x7);
    canvas.rotate(-math.pi / 2);
    _paintChartLabel(canvas, 'Lợi nhuận (%)', Offset.zero);
    canvas.restore();
  }

  void _paintChartLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _FrontierChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
