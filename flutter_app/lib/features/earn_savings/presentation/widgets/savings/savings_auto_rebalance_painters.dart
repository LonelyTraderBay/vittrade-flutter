part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _AllocationRingPainter extends CustomPainter {
  const _AllocationRingPainter({
    required this.allocations,
    required this.positions,
  });

  final Map<String, double> allocations;
  final List<SavingsRebalancePositionDraft> positions;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = math.min(size.width, size.height) * .2;
    final rect = Offset.zero & size;
    final ringRect = rect.deflate(stroke / 2);
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    for (final entry in allocations.entries) {
      final sweep = math.pi * 2 * (entry.value / 100);
      paint.color = _assetColorName(entry.key);
      canvas.drawArc(ringRect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_AllocationRingPainter oldDelegate) {
    return oldDelegate.allocations != allocations ||
        oldDelegate.positions != positions;
  }
}

class _DriftTrackPainter extends CustomPainter {
  const _DriftTrackPainter({
    required this.color,
    required this.driftColor,
    required this.current,
    required this.target,
  });

  final Color color;
  final Color driftColor;
  final double current;
  final double target;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.elliptical(size.height / 2, size.height / 2);
    final track = RRect.fromRectAndRadius(Offset.zero & size, radius);
    canvas.drawRRect(track, Paint()..color = AppColors.surface2);
    final left = size.width * (math.min(current, target) / 100);
    final right = size.width * (math.max(current, target) / 100);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, 0, right, size.height),
        radius,
      ),
      Paint()..color = driftColor.withValues(alpha: .72),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * (current / 100), 0, 2, size.height),
      Paint()..color = color,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * (target / 100), 0, 2, size.height),
      Paint()..color = AppColors.text2.withValues(alpha: .62),
    );
  }

  @override
  bool shouldRepaint(_DriftTrackPainter oldDelegate) {
    return oldDelegate.current != current ||
        oldDelegate.target != target ||
        oldDelegate.color != color ||
        oldDelegate.driftColor != driftColor;
  }
}

class _DriftBarPainter extends CustomPainter {
  const _DriftBarPainter({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 8, size.width - 42, size.height - 28);
    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (final value in [0, 2, 4, 6, 8]) {
      final y = chart.bottom - chart.height * (value / 8);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), grid);
    }

    final step = chart.width / points.length;
    final barWidth = step * .64;
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final height = chart.height * (point.drift / 8).clamp(0, 1);
      final x = chart.left + step * i + (step - barWidth) / 2;
      final color = _driftColor(point.drift).withValues(alpha: .86);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
          const Radius.elliptical(AppRadii.xs, AppRadii.xs),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_DriftBarPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
