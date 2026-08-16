part of '../../phone/pages/dashboard/bot_equity_curve_page.dart';

class _EquityChartCard extends StatelessWidget {
  const _EquityChartCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: _equityChartExtent,
            // PERF-HN5: isolate the heavy chart painter into its own
            // compositor layer.
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _EquityPainter(points),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hdr_strong_rounded,
                color: _equityGreen,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'Bot',
                style: AppTextStyles.micro.copyWith(
                  color: _equityGreen,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SharpeCard extends StatelessWidget {
  const _SharpeCard({required this.points});

  final List<TradeBotEquityCurvePoint> points;

  @override
  Widget build(BuildContext context) {
    final rolling = points
        .where((point) => point.rollingSharpe != null)
        .toList();
    final sharpeValues = rolling.map((point) => point.rollingSharpe!).toList();
    final currentSharpe = sharpeValues.isEmpty ? 0.0 : sharpeValues.last;
    final averageSharpe = sharpeValues.isEmpty
        ? 0.0
        : sharpeValues.reduce((a, b) => a + b) / sharpeValues.length;
    final minSharpe = sharpeValues.isEmpty
        ? 0.0
        : sharpeValues.reduce(math.min);
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: _equitySharpeExtent,
            // PERF-HN5: isolate the heavy chart painter into its own
            // compositor layer.
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _SharpePainter(rolling),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Hiện tại',
                  value: currentSharpe.toStringAsFixed(2),
                  status: _sharpeStatus(currentSharpe),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MiniStat(
                  label: 'Trung bình',
                  value: averageSharpe.toStringAsFixed(2),
                  status: _sharpeStatus(averageSharpe),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MiniStat(
                  label: 'Tối thiểu',
                  value: minSharpe.toStringAsFixed(2),
                  status: _sharpeStatus(minSharpe),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Illustrative rolling-Sharpe quality bands (matches the page's original
// design intent) — kept local since only this card classifies Sharpe values.
String _sharpeStatus(double value) {
  if (value >= 2.0) return 'Xuất sắc';
  if (value >= 1.7) return 'Tốt';
  return 'Khá';
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.status,
  });

  final String label;
  final String value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactPanelPadding,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            status,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MonthlyAlphaCard extends StatelessWidget {
  const _MonthlyAlphaCard({required this.months});

  final List<TradeBotMonthlyReturn> months;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        children: [
          for (final month in months) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    month.month,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  'Bot: +${month.botReturn.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: _equityGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  '${month.alpha >= 0 ? '+' : ''}${month.alpha.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.formFieldLabelGap),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: math.min(month.alpha.abs() * .20, 1),
                  child: ColoredBox(
                    color: month.alpha >= 0 ? _equityGreen : _equityRed,
                    child: const SizedBox(height: _equityProgressExtent),
                  ),
                ),
              ),
            ),
            if (month != months.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ],
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.stats});

  final List<TradeBotPerformanceStat> stats;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: GridView.count(
        crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        childAspectRatio:
            TradeSpacingTokens.tradeBotEquityPerformanceAspectRatio,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [for (final stat in stats) _PerformanceTile(stat: stat)],
      ),
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  const _PerformanceTile({required this.stat});

  final TradeBotPerformanceStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    final icon = switch (stat.id) {
      'annualized' => Icons.monitor_heart_outlined,
      'outperformance' => Icons.adjust_rounded,
      'average' => Icons.bar_chart_rounded,
      _ => Icons.trending_up_rounded,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactPanelPadding,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  stat.value,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
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
