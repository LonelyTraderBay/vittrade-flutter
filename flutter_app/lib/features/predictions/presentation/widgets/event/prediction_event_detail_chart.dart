part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Price / Probability',
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ChartPeriodTabs(),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              SizedBox(
                height: AppSpacing.x7 + AppSpacing.x7 + AppSpacing.x5,
                child: CustomPaint(
                  painter: _ProbabilityChartPainter(
                    values: snapshot.probabilityHistory,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Volume (24h)',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              SizedBox(
                height: AppSpacing.x5,
                child: _VolumeBars(values: snapshot.volumeHistory),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartPeriodTabs extends StatelessWidget {
  const _ChartPeriodTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = ['1H', '1D', '7D', '30D', 'All'];
    return Row(
      children: [
        for (var index = 0; index < tabs.length; index += 1) ...[
          Expanded(
            child: Material(
              color: tabs[index] == '30D'
                  ? _predictionPrimary.withValues(alpha: .14)
                  : AppColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
                side: BorderSide(
                  color: tabs[index] == '30D'
                      ? _predictionPrimary.withValues(alpha: .32)
                      : AppColors.transparent,
                ),
              ),
              child: SizedBox(
                height: VitDensity.compact.controlHeight,
                child: Center(
                  child: Text(
                    tabs[index],
                    style: AppTextStyles.micro.copyWith(
                      color: tabs[index] == '30D'
                          ? _predictionPrimary
                          : AppColors.text3,
                      fontWeight: tabs[index] == '30D'
                          ? AppTextStyles.bold
                          : AppTextStyles.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (index != tabs.length - 1)
            const SizedBox(
              width: PredictionsSpacingTokens.predictionDetailChartPeriodGap,
            ),
        ],
      ],
    );
  }
}

class _VolumeBars extends StatelessWidget {
  const _VolumeBars({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce(math.max).toDouble();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final value in values)
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: math.max(
                  PredictionsSpacingTokens
                      .predictionDetailChartVolumeBarMinFactor,
                  value / maxValue,
                ),
                child: Padding(
                  padding: PredictionsSpacingTokens
                      .predictionDetailChartVolumeBarMargin,
                  child: Material(
                    color: _predictionPrimary.withValues(alpha: .30),
                    borderRadius: AppRadii.predictionDetailChartVolumeBarRadius,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProbabilityChartPainter extends CustomPainter {
  const _ProbabilityChartPainter({required this.values});

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i += 1) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.length < 2) return;

    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = size.width * index / (values.length - 1);
      final y = size.height - (values[index] / 100) * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.buy.withValues(alpha: .30),
          AppColors.buy.withValues(alpha: .02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ProbabilityChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
