part of '../../phone/pages/staking/staking_analytics_page.dart';

const double _stakingAnalyticsEarningsChartHeight = 158;

class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitPageSection(
          label: 'Phân tích Thu nhập theo Tài sản',
          accentColor: AppColors.primary,
          density: VitDensity.compact,
          children: [_EarningsChartCard(points: snapshot.earningsBreakdown)],
        ),
        VitPageSection(
          label: 'Thu nhập theo Tài sản',
          accentColor: AppColors.primary,
          density: VitDensity.compact,
          children: [_AssetEarningsGrid(products: snapshot.productPerformance)],
        ),
      ],
    );
  }
}

class _EarningsChartCard extends StatelessWidget {
  const _EarningsChartCard({required this.points});

  final List<StakingEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAnalyticsPage.earningsChartKey,
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: _stakingAnalyticsEarningsChartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _YAxisLabels(
                  labels: ['\$320', '\$240', '\$160', '\$80', '\$0'],
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _StackedAreaPainter(points: points),
                          size: Size.infinite,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      _DateLabels(dates: points.map((p) => p.date).toList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const _LegendRow(
            entries: [
              _LegendEntry(label: 'BTC', color: _AssetPalette.btc),
              _LegendEntry(label: 'USDT', color: _AssetPalette.usdt),
              _LegendEntry(label: 'ETH', color: _AssetPalette.eth),
              _LegendEntry(label: 'SOL', color: _AssetPalette.sol),
              _LegendEntry(label: 'LP', color: _AssetPalette.lp),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetEarningsGrid extends StatelessWidget {
  const _AssetEarningsGrid({required this.products});

  final List<StakingProductPerformanceDraft> products;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: StakingAnalyticsPage.assetGridKey,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: EarnSpacingTokens.earnAnalyticsGridColumns,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: EarnSpacingTokens.stakingAnalyticsMetricGridAspect,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          final color = _assetColor(product.colorIndex);
          return VitCard(
            key: StakingAnalyticsPage.assetKey(product.asset),
            padding: _stakingAnalyticsCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: color,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.swatchRadius,
                        ),
                      ),
                      child: const SizedBox(
                        width: EarnSpacingTokens.earnAnalyticsAssetDot,
                        height: EarnSpacingTokens.earnAnalyticsAssetDot,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        product.asset,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  '+${EarnFormatters.usd(product.earnedUsd)}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StackedAreaPainter extends CustomPainter {
  const _StackedAreaPainter({required this.points});

  final List<StakingEarningsPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    if (points.length < 2) return;

    const series = [
      _SeriesSpec(color: _AssetPalette.btc, selector: _SeriesValue.btc),
      _SeriesSpec(color: _AssetPalette.usdt, selector: _SeriesValue.usdt),
      _SeriesSpec(color: _AssetPalette.eth, selector: _SeriesValue.eth),
      _SeriesSpec(color: _AssetPalette.sol, selector: _SeriesValue.sol),
      _SeriesSpec(color: _AssetPalette.lp, selector: _SeriesValue.lp),
    ];
    final maxValue = math.max(
      320.0,
      points.map((p) => p.total).reduce(math.max),
    );
    var previous = List<double>.filled(points.length, 0);

    for (final spec in series) {
      final next = <double>[
        for (var i = 0; i < points.length; i++)
          previous[i] + spec.value(points[i]),
      ];
      final topPath = _linePath(size, next, maxValue);
      final areaPath = Path.from(topPath);
      for (var i = points.length - 1; i >= 0; i--) {
        areaPath.lineTo(
          _x(size, i, points.length),
          _y(size, previous[i], maxValue),
        );
      }
      areaPath.close();

      canvas.drawPath(
        areaPath,
        Paint()
          ..color = spec.color.withValues(alpha: 0.62)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        topPath,
        Paint()
          ..color = spec.color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
      previous = next;
    }
  }

  @override
  bool shouldRepaint(covariant _StackedAreaPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _SeriesSpec {
  const _SeriesSpec({required this.color, required this.selector});

  final Color color;
  final _SeriesValue selector;

  double value(StakingEarningsPointDraft point) {
    return switch (selector) {
      _SeriesValue.btc => point.btc,
      _SeriesValue.usdt => point.usdt,
      _SeriesValue.eth => point.eth,
      _SeriesValue.sol => point.sol,
      _SeriesValue.lp => point.lp,
    };
  }
}

enum _SeriesValue { btc, usdt, eth, sol, lp }
