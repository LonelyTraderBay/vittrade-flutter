part of '../../phone/pages/tools/market_correlations_page.dart';

class _MatrixCard extends StatelessWidget {
  const _MatrixCard({required this.snapshot});

  final MarketCorrelationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: MarketCorrelationsPage.matrixCardKey,
      padding: MarketsSpacingTokens.marketCorrelationsMatrixPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ma trận tương quan (${_timeframeLabel(snapshot.timeframe)})',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _corrMatrixGap),
          _CorrelationHeatmap(assets: snapshot.assets, matrix: snapshot.matrix),
        ],
      ),
    );
  }
}

class _CorrelationHeatmap extends StatelessWidget {
  const _CorrelationHeatmap({required this.assets, required this.matrix});

  final List<CorrelationAsset> assets;
  final List<List<double>> matrix;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labelSize =
            MarketsSpacingTokens.marketCorrelationsHeatmapLabelSize;
        final n = assets.length;
        final cellSize = (constraints.maxWidth - labelSize) / n;
        final height = labelSize + cellSize * n;
        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: CustomPaint(
            painter: _CorrelationHeatmapPainter(
              assets: assets,
              matrix: matrix,
              labelSize: labelSize,
              cellSize: cellSize,
            ),
          ),
        );
      },
    );
  }
}

class _CorrelationHeatmapPainter extends CustomPainter {
  const _CorrelationHeatmapPainter({
    required this.assets,
    required this.matrix,
    required this.labelSize,
    required this.cellSize,
  });

  final List<CorrelationAsset> assets;
  final List<List<double>> matrix;
  final double labelSize;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var col = 0; col < assets.length; col += 1) {
      final asset = assets[col];
      textPainter.text = TextSpan(
        text: asset.symbol,
        style: AppTextStyles.chartLabelTiny.copyWith(
          color: AppAssetColors.forSymbol(asset.symbol),
          fontWeight: AppTextStyles.bold,
        ),
      );
      textPainter.layout();
      final x =
          labelSize + col * cellSize + cellSize / 2 - textPainter.width / 2;
      textPainter.paint(canvas, Offset(x, labelSize - 18));
    }

    for (var row = 0; row < assets.length; row += 1) {
      final asset = assets[row];
      final y = labelSize + row * cellSize + cellSize / 2;
      textPainter.text = TextSpan(
        text: asset.symbol,
        style: AppTextStyles.chartLabelTiny.copyWith(
          color: AppAssetColors.forSymbol(asset.symbol),
          fontWeight: AppTextStyles.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelSize - 4 - textPainter.width, y - 6),
      );

      for (var col = 0; col < assets.length; col += 1) {
        final value = matrix[row][col];
        final x = labelSize + col * cellSize;
        final cellY = labelSize + row * cellSize;
        final color = _correlationColor(value);
        final opacity = row == col ? .60 : .12 + value * .35;
        final rect = Rect.fromLTWH(
          x + 1,
          cellY + 1,
          cellSize - 2,
          cellSize - 2,
        );
        canvas.drawRect(
          rect,
          Paint()..color = color.withValues(alpha: opacity),
        );
        canvas.drawRect(
          rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = .5
            ..color = AppColors.borderSolid,
        );

        textPainter.text = TextSpan(
          text: row == col ? '1.0' : value.toStringAsFixed(2),
          style:
              (row == col
                      ? AppTextStyles.chartLabelTiny
                      : AppTextStyles.chartLabelNano)
                  .copyWith(
                    color: value >= .7 ? AppColors.onAccent : AppColors.text1,
                    fontWeight: row == col
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                  ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            x + cellSize / 2 - textPainter.width / 2,
            cellY + cellSize / 2 - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CorrelationHeatmapPainter oldDelegate) {
    return oldDelegate.matrix != matrix || oldDelegate.assets != assets;
  }
}

class _CorrelationLegend extends StatelessWidget {
  const _CorrelationLegend();

  @override
  Widget build(BuildContext context) {
    const items = [
      _LegendEntry('Rất cao (>0.85)', AppDataVizColors.correlationVeryHigh),
      _LegendEntry('Cao (0.7-0.85)', AppColors.sell),
      _LegendEntry('TB (0.5-0.7)', AppColors.warn),
      _LegendEntry('Thấp (0.3-0.5)', AppColors.buy),
      _LegendEntry('Rất thấp (<0.3)', AppDataVizColors.correlationVeryLow),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: MarketsSpacingTokens.marketCorrelationsLegendDot,
                color: item.color,
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketCorrelationsLegendGap,
              ),
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
      ],
    );
  }
}

final class _LegendEntry {
  const _LegendEntry(this.label, this.color);

  final String label;
  final Color color;
}

class _MatrixInfoCard extends StatelessWidget {
  const _MatrixInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _marketPrimary.withValues(alpha: .20),
      padding: MarketsSpacingTokens.marketCorrelationsInfoPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: MarketsSpacingTokens.marketCorrelationsInfoIcon,
            color: _marketPrimary,
          ),
          const SizedBox(
            width: MarketsSpacingTokens.marketCorrelationsInfoIconGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cách đọc ma trận',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _corrInfoTitleGap),
                Text(
                  'Giá trị 1.0 = hoàn toàn cùng chiều. Giá trị 0 = không liên quan. Tương quan cao có nghĩa 2 tài sản thường di chuyển cùng hướng. Để giảm rủi ro, nên giữ tài sản có tương quan thấp.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _corrBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickInsights extends StatelessWidget {
  const _QuickInsights({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InsightCard(
            label: 'Cao nhất',
            value: score.highestCorr.value.toStringAsFixed(2),
            sub: score.highestCorr.pair,
            color: AppColors.sell,
          ),
        ),
        const SizedBox(
          width: MarketsSpacingTokens.marketCorrelationsInsightGap,
        ),
        Expanded(
          child: _InsightCard(
            label: 'Thấp nhất',
            value: score.lowestCorr.value.toStringAsFixed(2),
            sub: score.lowestCorr.pair,
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: MarketsSpacingTokens.marketCorrelationsInsightPadding,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _corrInsightValueGap),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _corrInsightSubGap),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final String recommendation;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _marketPrimary.withValues(alpha: .20),
      padding: MarketsSpacingTokens.marketCorrelationsRecommendationPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            size: MarketsSpacingTokens.marketCorrelationsRecommendationIcon,
            color: _marketPrimary,
          ),
          const SizedBox(
            width: MarketsSpacingTokens.marketCorrelationsRecommendationIconGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khuyến nghị',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _corrRecommendationTitleGap),
                Text(
                  recommendation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _corrBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
