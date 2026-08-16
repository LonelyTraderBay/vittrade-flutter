part of '../../phone/pages/dashboard/bot_risk_dashboard_page.dart';

class _DrawdownChartCard extends StatefulWidget {
  const _DrawdownChartCard({required this.points, required this.limit});

  final List<TradeBotDrawdownPoint> points;
  final double limit;

  @override
  State<_DrawdownChartCard> createState() => _DrawdownChartCardState();
}

class _DrawdownChartCardState extends State<_DrawdownChartCard> {
  int? _scrubIndex;

  void _updateScrub(Offset local, Size size) {
    final points = widget.points;
    if (points.length < 2) return;
    final plot = Rect.fromLTWH(50, 8, size.width - 62, size.height - 40);
    final t = ((local.dx - plot.left) / plot.width).clamp(0.0, 1.0);
    final index = (t * (points.length - 1)).round().clamp(0, points.length - 1);
    if (index != _scrubIndex) setState(() => _scrubIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    final scrub = _scrubIndex;
    final headroom = points.isEmpty
        ? 0.0
        : (widget.limit.abs() - points.last.value.abs()).clamp(0.0, 999.0);
    final scrubPoint = scrub != null && scrub >= 0 && scrub < points.length
        ? points[scrub]
        : null;

    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  scrubPoint == null
                      ? 'Drawdown hiện tại ${points.isEmpty ? '—' : '${points.last.value.toStringAsFixed(1)}%'}'
                      : '${scrubPoint.label} · ${scrubPoint.value.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              VitAccentPill(
                label: 'Còn ${headroom.toStringAsFixed(1)}% tới hạn',
                accentColor: _riskAmber,
              ),
            ],
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          AspectRatio(
            aspectRatio: 2.2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) => _updateScrub(d.localPosition, size),
                  onHorizontalDragUpdate: (d) =>
                      _updateScrub(d.localPosition, size),
                  onHorizontalDragEnd: (_) =>
                      setState(() => _scrubIndex = null),
                  onTapCancel: () => setState(() => _scrubIndex = null),
                  child: CustomPaint(
                    painter: _DrawdownChartPainter(
                      points,
                      limit: widget.limit,
                      scrubIndex: scrub,
                    ),
                    child: const SizedBox.expand(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VarChartCard extends StatelessWidget {
  const _VarChartCard({required this.points});

  final List<TradeBotVarPoint> points;

  @override
  Widget build(BuildContext context) {
    final latest = points.isEmpty ? 0.0 : points.last.value;
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ước lỗ 1 ngày (độ tin cậy 95%) · ${_formatMoney(latest)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          AspectRatio(
            aspectRatio: 2.4,
            child: CustomPaint(
              painter: _VarChartPainter(points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawdownChartPainter extends CustomPainter {
  const _DrawdownChartPainter(
    this.points, {
    required this.limit,
    this.scrubIndex,
  });

  final List<TradeBotDrawdownPoint> points;
  final double limit;
  final int? scrubIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final plot = Rect.fromLTWH(50, 8, size.width - 62, size.height - 40);

    var minV = points.first.value;
    var maxV = points.first.value;
    for (final p in points) {
      minV = math.min(minV, p.value);
      maxV = math.max(maxV, p.value);
    }
    minV = math.min(minV, limit);
    maxV = math.max(maxV, 0);
    if ((maxV - minV).abs() < 0.01) {
      minV -= 1;
      maxV += 1;
    }
    final pad = (maxV - minV) * 0.08;
    minV -= pad;
    maxV += pad;
    final span = maxV - minV;

    final gridPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: 0.28)
      ..strokeWidth = 1;
    final yLabels = <String>[];
    for (var i = 0; i < 4; i++) {
      final t = i / 3;
      final value = maxV - span * t;
      final y = plot.top + plot.height * t;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      yLabels.add('${value.toStringAsFixed(0)}%');
      _drawSmallText(
        canvas,
        yLabels.last,
        Offset(plot.left - 6, y),
        alignRight: true,
      );
    }

    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .55)
      ..strokeWidth = 1;
    canvas
      ..drawLine(plot.bottomLeft, plot.topLeft, axisPaint)
      ..drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);

    // Limit line
    final limitY = plot.top + ((maxV - limit) / span) * plot.height;
    canvas.drawLine(
      Offset(plot.left, limitY),
      Offset(plot.right, limitY),
      Paint()
        ..color = _riskAmber.withValues(alpha: 0.7)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );

    Offset pointAt(int i) {
      final x = plot.left + plot.width * i / (points.length - 1).clamp(1, 999);
      final y = plot.top + ((maxV - points[i].value) / span) * plot.height;
      return Offset(x, y);
    }

    final path = Path();
    final area = Path();
    for (var i = 0; i < points.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
        area.moveTo(p.dx, plot.top);
        area.lineTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
        area.lineTo(p.dx, p.dy);
      }
    }
    area
      ..lineTo(pointAt(points.length - 1).dx, plot.top)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _riskRed.withValues(alpha: 0.22),
            _riskRed.withValues(alpha: 0.0),
          ],
        ).createShader(plot),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _riskRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final last = pointAt(points.length - 1);
    canvas.drawCircle(last, 4.5, Paint()..color = _riskRed);

    final labelIndexes = <int>{
      0,
      points.length - 1,
      if (points.length > 3) (points.length / 2).floor(),
    };
    for (final i in labelIndexes) {
      final p = pointAt(i);
      _drawSmallText(
        canvas,
        points[i].label,
        Offset(p.dx, plot.bottom + 12),
        center: true,
      );
    }

    if (scrubIndex != null) {
      final p = pointAt(scrubIndex!);
      canvas.drawLine(
        Offset(p.dx, plot.top),
        Offset(p.dx, plot.bottom),
        Paint()
          ..color = AppColors.text2.withValues(alpha: 0.45)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(p, 5, Paint()..color = _riskRed);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawdownChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.limit != limit ||
      oldDelegate.scrubIndex != scrubIndex;
}

class _VarChartPainter extends CustomPainter {
  const _VarChartPainter(this.points);

  final List<TradeBotVarPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final plot = Rect.fromLTWH(50, 10, size.width - 64, size.height - 36);

    var minV = points.first.value;
    var maxV = points.first.value;
    for (final p in points) {
      minV = math.min(minV, p.value);
      maxV = math.max(maxV, p.value);
    }
    if ((maxV - minV).abs() < 0.01) {
      maxV += 1;
      minV -= 1;
    }
    final pad = (maxV - minV) * 0.12;
    minV = math.max(0, minV - pad);
    maxV += pad;
    final span = maxV - minV;

    final gridPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: 0.28)
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final t = i / 2;
      final value = maxV - span * t;
      final y = plot.top + plot.height * t;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      _drawSmallText(
        canvas,
        '\$${value.toStringAsFixed(0)}',
        Offset(plot.left - 6, y),
        alignRight: true,
      );
    }

    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .55)
      ..strokeWidth = 1;
    canvas
      ..drawLine(plot.bottomLeft, plot.topLeft, axisPaint)
      ..drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);

    Offset pointAt(int i) {
      final x = plot.left + plot.width * i / (points.length - 1).clamp(1, 999);
      final y = plot.bottom - ((points[i].value - minV) / span) * plot.height;
      return Offset(x, y);
    }

    final path = Path();
    final area = Path();
    for (var i = 0; i < points.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
        area.moveTo(p.dx, plot.bottom);
        area.lineTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
        area.lineTo(p.dx, p.dy);
      }
    }
    area
      ..lineTo(pointAt(points.length - 1).dx, plot.bottom)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _riskPurple.withValues(alpha: 0.24),
            _riskPurple.withValues(alpha: 0.0),
          ],
        ).createShader(plot),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _riskPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < points.length; i++) {
      final p = pointAt(i);
      final isLast = i == points.length - 1;
      canvas.drawCircle(p, isLast ? 5 : 3.2, Paint()..color = _riskPurple);
      if (i == 0 || isLast || i == points.length ~/ 2) {
        _drawSmallText(
          canvas,
          points[i].label,
          Offset(p.dx, plot.bottom + 12),
          center: true,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VarChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

void _drawSmallText(
  Canvas canvas,
  String text,
  Offset offset, {
  bool alignRight = false,
  bool center = false,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  var dx = offset.dx;
  if (alignRight) dx -= painter.width;
  if (center) dx -= painter.width / 2;
  painter.paint(canvas, Offset(dx, offset.dy - painter.height / 2));
}
