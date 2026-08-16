part of '../../phone/pages/staking/staking_proof_of_reserves_page.dart';

const double _reserveProgressRingExtent = AppSpacing.x7 * 2 + AppSpacing.x4;

class _ReserveProgress extends StatelessWidget {
  const _ReserveProgress({required this.ratio});

  final double ratio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _reserveProgressRingExtent,
      height: _reserveProgressRingExtent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _ReserveProgressPainter(ratio),
            child: const SizedBox.expand(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                child: Material(
                  color: AppColors.transparent,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: AppColors.buy,
                      width: EarnSpacingTokens.stakingProofProgressBorderWidth,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                '${ratio.toStringAsFixed(1)}%',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'Covered',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReserveProgressPainter extends CustomPainter {
  const _ReserveProgressPainter(this.ratio);

  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - AppSpacing.x3;
    final stroke = AppSpacing.x4;
    final track = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final progress = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * math.min(ratio / 150, 1),
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _ReserveProgressPainter oldDelegate) {
    return oldDelegate.ratio != ratio;
  }
}

class _ReserveTrendPainter extends CustomPainter {
  const _ReserveTrendPainter(this.points);

  final List<StakingReserveHistoryPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 16.0;
    const top = 14.0;
    const right = 12.0;
    const bottom = 16.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    final gridPaint = Paint()
      ..color = AppColors.primary20
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3
      ..strokeWidth = 1.2;
    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }
    for (var i = 0; i <= 4; i++) {
      final x = chart.left + chart.width * i / 4;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - chart.height * ((points[i].ratio - 100) / 4);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.buy;
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - chart.height * ((points[i].ratio - 100) / 4);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReserveTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
