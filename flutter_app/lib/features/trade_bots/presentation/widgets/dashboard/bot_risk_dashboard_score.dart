part of '../../phone/pages/dashboard/bot_risk_dashboard_page.dart';

class _RiskScoreCard extends StatelessWidget {
  const _RiskScoreCard({required this.snapshot, required this.reveal});

  final TradeBotRiskDashboardSnapshot snapshot;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.riskScore);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm rủi ro danh mục',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                    Text(
                      '${snapshot.riskScore}/100',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: color,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                    Text(
                      snapshot.riskLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: reveal,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _RiskRingPainter(
                      percent:
                          (snapshot.riskScore / 100) *
                          Curves.easeOut.transform(reveal.value),
                      color: color,
                    ),
                    child: SizedBox(
                      width: _riskRingSize,
                      height: _riskRingSize,
                      child: Center(
                        child: Icon(
                          Icons.shield_outlined,
                          color: color,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
            density: VitDensity.tool,
            borderColor: color.withValues(alpha: .28),
            child: Text(
              snapshot.riskMessage,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskRingPainter extends CustomPainter {
  const _RiskRingPainter({required this.percent, required this.color});

  final double percent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = _riskTrack;
    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2, false, track);
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2 * percent.clamp(0.0, 1.0),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant _RiskRingPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color;
  }
}
