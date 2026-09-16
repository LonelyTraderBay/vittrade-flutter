part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-221: Biểu đồ nâng cao prediction — đường giá + MA7/MA25, dòng lệnh
// mua/bán, tín hiệu chỉ báo và mẫu hình, như phone SC-041.
// ---------------------------------------------------------------------------

class PredictionAdvancedChartTabletPage extends ConsumerWidget {
  const PredictionAdvancedChartTabletPage({super.key, required this.eventId});

  static const contentKey = Key('sc221_tablet_content');

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartAsync = ref.watch(
      predictionsAdvancedChartSnapshotProvider(eventId),
    );

    return chartAsync.when(
      loading: () => const VitTabletSectionFrame(
        gutterFlush: true,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Biểu đồ nâng cao prediction',
        title: 'Biểu đồ nâng cao',
        children: [VitSkeletonList(rows: 6)],
      ),
      error: (error, stackTrace) => VitTabletSectionFrame(
        gutterFlush: true,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Biểu đồ nâng cao prediction',
        title: 'Biểu đồ nâng cao',
        children: [
          _pdmError(
            'Không tải được biểu đồ',
            () => ref.invalidate(
              predictionsAdvancedChartSnapshotProvider(eventId),
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        gutterFlush: true,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Biểu đồ nâng cao prediction',
        title: 'Biểu đồ nâng cao',
        subtitle: snapshot.eventId,
        contentKey: PredictionAdvancedChartTabletPage.contentKey,
        backFallback: AppRoutePaths.marketsPredictionEvent(eventId),
        children: [
          VitPageSection(
            label: 'Giá · MA7 · MA25',
            accentColor: AppColors.primary,
            innerGap: TabletSpacingTokens.x4,
            children: [
              VitCard(
                density: VitDensity.compact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height:
                          TabletSpacingTokens.x7 +
                          TabletSpacingTokens.x7 +
                          TabletSpacingTokens.x3,
                      child: CustomPaint(
                        painter: _Sc221ChartPainter(
                          points: snapshot.priceHistory,
                        ),
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x3),
                    const Row(
                      children: [
                        _Sc221LegendDot(color: AppColors.primary, label: 'Giá'),
                        SizedBox(width: TabletSpacingTokens.x2),
                        _Sc221LegendDot(color: AppColors.accent, label: 'MA7'),
                        SizedBox(width: TabletSpacingTokens.x2),
                        _Sc221LegendDot(color: AppColors.warn, label: 'MA25'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          VitPageSection(
            label: 'Dòng lệnh mua/bán',
            accentColor: AppColors.buy,
            innerGap: TabletSpacingTokens.x4,
            children: [
              VitCard(
                density: VitDensity.compact,
                child: Column(
                  children: [
                    for (final flow in snapshot.orderFlow)
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingV,
                        child: Row(
                          children: [
                            SizedBox(
                              width:
                                  TabletSpacingTokens.x5 +
                                  TabletSpacingTokens.x2,
                              child: Text(
                                VitFormat.usd(flow.price),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _Sc221FlowBar(
                                value: flow.buyVolume,
                                color: AppColors.buy,
                              ),
                            ),
                            Expanded(
                              child: _Sc221FlowBar(
                                value: flow.sellVolume,
                                color: AppColors.sell,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          VitPageSection(
            label: 'Tín hiệu chỉ báo',
            accentColor: AppColors.accent,
            innerGap: TabletSpacingTokens.x4,
            children: [
              for (final indicator in snapshot.indicators)
                VitCard(
                  density: VitDensity.compact,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              indicator.name,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x1),
                            Text(
                              indicator.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _pdmTinyBadge(
                        label: indicator.signal,
                        color: indicator.tone.resolve(),
                        background: indicator.tone.resolve().withValues(
                          alpha: .12,
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x1),
                      Text(
                        indicator.strength,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (snapshot.patterns.isNotEmpty)
            VitPageSection(
              label: 'Mẫu hình nhận diện',
              accentColor: AppColors.warn,
              innerGap: TabletSpacingTokens.x4,
              children: [
                for (final pattern in snapshot.patterns)
                  VitCard(
                    density: VitDensity.compact,
                    child: Row(
                      children: [
                        SizedBox.square(
                          dimension: TabletSpacingTokens.iconSm,
                          child: Icon(
                            pattern.bullish
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: pattern.bullish
                                ? AppColors.buy
                                : AppColors.sell,
                            size: TabletSpacingTokens.iconSm,
                          ),
                        ),
                        const SizedBox(width: TabletSpacingTokens.x2),
                        Expanded(
                          child: Text(
                            pattern.name,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Độ tin cậy '
                          '${VitFormat.percent(pattern.confidence, fractionDigits: 0)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Sc221LegendDot extends StatelessWidget {
  const _Sc221LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: TabletSpacingTokens.iconSm,
          child: Material(color: color, shape: const CircleBorder()),
        ),
        const SizedBox(width: TabletSpacingTokens.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _Sc221FlowBar extends StatelessWidget {
  const _Sc221FlowBar({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.badgeRadius,
      child: SizedBox(
        height: TabletSpacingTokens.x3,
        child: Row(
          children: [
            Expanded(
              flex: value,
              child: ColoredBox(color: color.withValues(alpha: .30)),
            ),
            const Expanded(
              flex: 100,
              child: ColoredBox(color: AppColors.surface2),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sc221ChartPainter extends CustomPainter {
  const _Sc221ChartPainter({required this.points});

  final List<PredictionChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final prices = [
      for (final point in points) point.price,
      for (final point in points) point.ma7,
      for (final point in points) point.ma25,
    ];
    final minValue = prices.reduce((a, b) => a < b ? a : b);
    final maxValue = prices.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final norm = range > 0 ? range : 1.0;

    double x(int index) => size.width * index / (points.length - 1);
    double y(double value) =>
        size.height - ((value - minValue) / norm) * size.height;

    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i += 1) {
      final gy = size.height * i / 4;
      canvas.drawLine(Offset(0, gy), Offset(size.width, gy), gridPaint);
    }

    void drawSeries(
      double Function(PredictionChartPointDraft) pick,
      Color color,
    ) {
      final path = Path();
      for (var index = 0; index < points.length; index += 1) {
        final point = points[index];
        if (index == 0) {
          path.moveTo(x(index), y(pick(point)));
        } else {
          path.lineTo(x(index), y(pick(point)));
        }
      }
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = TabletSpacingTokens.hairlineStroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }

    drawSeries((point) => point.price, AppColors.primary);
    drawSeries((point) => point.ma7, AppColors.accent);
    drawSeries((point) => point.ma25, AppColors.warn);
  }

  @override
  bool shouldRepaint(covariant _Sc221ChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
