part of '../../phone/pages/staking/staking_risk_score_calculator_page.dart';

class _RiskRadarChart extends StatelessWidget {
  const _RiskRadarChart({required this.axes, required this.color});

  final List<_RiskRadarAxis> axes;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _RiskRadarPainter(axes: axes, color: color),
          ),
        ),
        _RadarLabel(
          label: axes[0].label,
          left: 0,
          right: 0,
          top: 0,
          textAlign: TextAlign.center,
        ),
        _RadarLabel(
          label: axes[1].label,
          right: 0,
          top: 94,
          textAlign: TextAlign.right,
        ),
        _RadarLabel(
          label: axes[2].label,
          left: 0,
          bottom: 34,
          textAlign: TextAlign.left,
        ),
        _RadarLabel(
          label: axes[3].label,
          right: 0,
          bottom: 22,
          textAlign: TextAlign.right,
        ),
        _RadarLabel(
          label: axes[4].label,
          left: 0,
          top: 94,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class _RadarLabel extends StatelessWidget {
  const _RadarLabel({
    required this.label,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.textAlign,
  });

  final String label;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Text(
        label,
        maxLines: 2,
        textAlign: textAlign,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _RiskRadarPainter extends CustomPainter {
  const _RiskRadarPainter({required this.axes, required this.color});

  final List<_RiskRadarAxis> axes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (axes.length < 3) return;
    final center = Offset(size.width / 2, size.height / 2 + AppSpacing.x2);
    final radius = math.min(size.width, size.height) * 0.32;
    final gridPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final axisPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;

    for (var ring = 1; ring <= 4; ring++) {
      final ringPath = Path();
      final ringRadius = radius * ring / 4;
      for (var i = 0; i < axes.length; i++) {
        final point = _pointFor(center, ringRadius, i, axes.length);
        if (i == 0) {
          ringPath.moveTo(point.dx, point.dy);
        } else {
          ringPath.lineTo(point.dx, point.dy);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, gridPaint);
    }

    for (var i = 0; i < axes.length; i++) {
      final end = _pointFor(center, radius, i, axes.length);
      canvas.drawLine(center, end, axisPaint);
    }

    final profilePath = Path();
    for (var i = 0; i < axes.length; i++) {
      final valueRadius = radius * (axes[i].value / 100).clamp(0, 1);
      final point = _pointFor(center, valueRadius, i, axes.length);
      if (i == 0) {
        profilePath.moveTo(point.dx, point.dy);
      } else {
        profilePath.lineTo(point.dx, point.dy);
      }
    }
    profilePath.close();

    canvas.drawPath(
      profilePath,
      Paint()
        ..color = color.withValues(alpha: 0.24)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      profilePath,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  Offset _pointFor(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + index * 2 * math.pi / count;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(covariant _RiskRadarPainter oldDelegate) {
    return oldDelegate.axes != axes || oldDelegate.color != color;
  }
}
