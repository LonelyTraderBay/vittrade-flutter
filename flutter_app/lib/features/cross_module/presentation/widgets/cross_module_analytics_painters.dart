part of '../phone/pages/cross_module_analytics_page.dart';

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _RoiBarPainter extends CustomPainter {
  const _RoiBarPainter({required this.modules});

  final List<CrossModuleMetricDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    final maxRoi = modules.map((item) => item.roi).reduce(math.max);
    final slot = size.width / modules.length;
    final barWidth = math.min(AppSpacing.x7, slot * .56);
    final baseY = size.height - AppSpacing.x5;
    final axis = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, baseY), Offset(size.width, baseY), axis);

    for (var i = 0; i < modules.length; i++) {
      final module = modules[i];
      final height = module.roi / maxRoi * (size.height - AppSpacing.x7);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          slot * i + (slot - barWidth) / 2,
          baseY - height,
          barWidth,
          height,
        ),
        AppRadii.xsCorner,
      );
      canvas.drawRRect(rect, Paint()..color = AppColors.buy);
    }
  }

  @override
  bool shouldRepaint(covariant _RoiBarPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

class _MonthlyLinePainter extends CustomPainter {
  const _MonthlyLinePainter({required this.points});

  final List<CrossModuleMonthlyPerformanceDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final allValues = [
      for (final point in points) ...[
        point.trading,
        point.p2p,
        point.predictions,
        point.dca,
      ],
    ];
    final minValue = allValues.reduce(math.min);
    final maxValue = allValues.reduce(math.max);

    void drawSeries(
      double Function(CrossModuleMonthlyPerformanceDraft point) valueOf,
      Color color,
    ) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = i / (points.length - 1) * size.width;
        final y =
            size.height -
            (valueOf(points[i]) - minValue) /
                (maxValue - minValue) *
                (size.height - AppSpacing.x6);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppSpacing.x1
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }

    drawSeries((point) => point.trading, AppColors.buy);
    drawSeries((point) => point.p2p, AppModuleAccents.p2p);
    drawSeries((point) => point.predictions, AppModuleAccents.predictions);
    drawSeries((point) => point.dca, AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant _MonthlyLinePainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RadarMetricPainter extends CustomPainter {
  const _RadarMetricPainter({required this.modules});

  final List<CrossModuleMetricDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .38;
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.divider;
    for (final scale in [.35, .68, 1.0]) {
      _drawPolygon(canvas, center, radius * scale, gridPaint);
    }
    _drawRadarSeries(
      canvas,
      center,
      radius,
      modules.map((module) => module.roi * 4).toList(),
      AppColors.buy,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      modules.map((module) => module.winRate).toList(),
      AppColors.primary,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      modules.map((module) => module.totalVolume / 2500).toList(),
      AppColors.warn,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarMetricPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

class _RiskReturnPainter extends CustomPainter {
  const _RiskReturnPainter({required this.modules});

  final List<CrossModuleMetricDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - AppSpacing.x4),
      Offset(size.width, size.height - AppSpacing.x4),
      axis,
    );
    canvas.drawLine(
      const Offset(AppSpacing.x4, 0),
      Offset(AppSpacing.x4, size.height),
      axis,
    );

    for (final module in modules) {
      final x =
          AppSpacing.x4 + module.riskScore / 100 * (size.width - AppSpacing.x6);
      final y =
          size.height -
          AppSpacing.x4 -
          module.roi / 22 * (size.height - AppSpacing.x6);
      canvas.drawCircle(
        Offset(x, y),
        AppSpacing.x3,
        Paint()..color = _analyticsAccent(module.id),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RiskReturnPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

void _drawPolygon(Canvas canvas, Offset center, double radius, Paint paint) {
  final path = Path();
  for (var i = 0; i < 4; i++) {
    final angle = -math.pi / 2 + i * math.pi / 2;
    final point = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(path, paint);
}

void _drawRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final angle = -math.pi / 2 + i * math.pi * 2 / values.length;
    final normalized = values[i].clamp(0, 100) / 100;
    final point = Offset(
      center.dx + math.cos(angle) * radius * normalized,
      center.dy + math.sin(angle) * radius * normalized,
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: .18),
  );
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.x1
      ..color = color,
  );
}

double _efficiency(CrossModuleMetricDraft module) =>
    module.riskScore == 0 ? 0 : module.roi / module.riskScore * 100;

Color _riskColor(int riskScore) {
  if (riskScore > 70) return AppColors.sell;
  if (riskScore > 50) return AppColors.warn;
  return AppColors.buy;
}

Color _analyticsAccent(AnalyticsModuleId id) {
  switch (id) {
    case AnalyticsModuleId.trading:
      return AppColors.buy;
    case AnalyticsModuleId.p2p:
      return AppModuleAccents.p2p;
    case AnalyticsModuleId.predictions:
      return AppModuleAccents.predictions;
    case AnalyticsModuleId.dca:
      return AppColors.accent;
  }
}
