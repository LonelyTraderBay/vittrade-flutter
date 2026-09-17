part of 'prediction_portfolio_analyzer_tablet_page.dart';

// --- Tổng quan -------------------------------------------------------------

class _Sc218OverviewTab extends StatelessWidget {
  const _Sc218OverviewTab({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final invested = snapshot.positions.fold(
      0.0,
      (sum, position) => sum + position.shares * position.avgPrice,
    );
    final realized = snapshot.closedPositions.fold(
      0.0,
      (sum, position) => sum + (position.closedPnl ?? 0),
    );
    final unrealized = snapshot.openPositions.fold(
      0.0,
      (sum, position) =>
          sum + (position.currentPrice - position.avgPrice) * position.shares,
    );
    final returnPct = invested > 0
        ? ((realized + unrealized) / invested) * 100
        : 0;
    final closedCount = snapshot.closedPositions.length;
    final winCount = snapshot.closedPositions
        .where((position) => (position.closedPnl ?? 0) > 0)
        .length;
    final winRate = closedCount > 0 ? (winCount / closedCount) * 100 : 0;
    final receiptsTotal = snapshot.receipts.fold(
      0.0,
      (sum, receipt) => sum + receipt.total,
    );
    final avgTrade = snapshot.receipts.isEmpty
        ? 0.0
        : receiptsTotal / snapshot.receipts.length;

    // Khuôn như 2 tab kia: VitPageSection sở hữu nhãn + gap hệ thống giữa
    // các khối (children tight 8, label→children innerGap 12). Column trần
    // từng khiến 3 card dính 0dp — đo pixel emulator 2026-09-18.
    return VitPageSection(
      label: 'Tổng quan',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tóm tắt danh mục',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              Row(
                children: [
                  Expanded(
                    child: _Sc218SummaryMetric(
                      label: 'Đã đầu tư',
                      value: VitFormat.usd(invested),
                    ),
                  ),
                  Expanded(
                    child: _Sc218SummaryMetric(
                      label: 'Hiệu suất',
                      value: VitFormat.signedPercent(
                        returnPct,
                        fractionDigits: 2,
                      ),
                      valueColor: returnPct >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              Row(
                children: [
                  Expanded(
                    child: _Sc218SummaryMetric(
                      label: 'Lãi/lỗ đã khớp',
                      value: VitFormat.usdSigned(realized),
                      valueColor: realized >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                  Expanded(
                    child: _Sc218SummaryMetric(
                      label: 'Lãi/lỗ chưa khớp',
                      value: VitFormat.usdSigned(unrealized),
                      valueColor: unrealized >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          key: PredictionPortfolioAnalyzerTabletPage.statsRowKey,
          children: [
            for (var index = 0; index < 4; index += 1) ...[
              Expanded(
                child: _Sc218StatCard(
                  stat: switch (index) {
                    0 => (
                      label: 'Vị thế mở',
                      value: VitFormat.count(snapshot.openPositions.length),
                    ),
                    1 => (
                      label: 'Tỷ lệ thắng',
                      value: VitFormat.percent(winRate, fractionDigits: 0),
                    ),
                    2 => (
                      label: 'Tổng lệnh',
                      value: VitFormat.count(snapshot.orders.length),
                    ),
                    _ => (
                      label: 'Giá trị lệnh TB',
                      value: VitFormat.usd(avgTrade),
                    ),
                  },
                ),
              ),
              if (index != 3) const SizedBox(width: TabletSpacingTokens.x4),
            ],
          ],
        ),
        for (final (index, category) in _sc218Categories(snapshot).indexed)
          _Sc218CategoryCard(
            category: category.$1,
            openCount: category.$2,
            sharePct: category.$3,
            key: index == 0
                ? PredictionPortfolioAnalyzerTabletPage.firstCategoryKey
                : null,
          ),
      ],
    );
  }
}

/// Panel chỉ số nhanh ghim bên phải (Cụm C): 4 số cốt lõi đọc được khi đang
/// ở bất kỳ tab nào — cùng công thức với tab Tổng quan.
class _Sc218QuickStatsPanel extends StatelessWidget {
  const _Sc218QuickStatsPanel({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final invested = snapshot.positions.fold(
      0.0,
      (sum, position) => sum + position.shares * position.avgPrice,
    );
    final realized = snapshot.closedPositions.fold(
      0.0,
      (sum, position) => sum + (position.closedPnl ?? 0),
    );
    final unrealized = snapshot.openPositions.fold(
      0.0,
      (sum, position) =>
          sum + (position.currentPrice - position.avgPrice) * position.shares,
    );
    final returnPct = invested > 0
        ? ((realized + unrealized) / invested) * 100
        : 0;
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chỉ số nhanh',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _Sc218SummaryMetric(
            label: 'Đã đầu tư',
            value: VitFormat.usd(invested),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _Sc218SummaryMetric(
            label: 'Hiệu suất',
            value: VitFormat.signedPercent(returnPct, fractionDigits: 2),
            valueColor: returnPct >= 0 ? AppColors.buy : AppColors.sell,
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _Sc218SummaryMetric(
            label: 'Lãi/lỗ chưa khớp',
            value: VitFormat.usdSigned(unrealized),
            valueColor: unrealized >= 0 ? AppColors.buy : AppColors.sell,
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _Sc218SummaryMetric(
            label: 'Vị thế mở',
            value: VitFormat.count(snapshot.openPositions.length),
          ),
        ],
      ),
    );
  }
}

class _Sc218SummaryMetric extends StatelessWidget {
  const _Sc218SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Sc218StatCard extends StatelessWidget {
  const _Sc218StatCard({required this.stat});

  final ({String label, String value}) stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc218CategoryCard extends StatelessWidget {
  const _Sc218CategoryCard({
    super.key,
    required this.category,
    required this.openCount,
    required this.sharePct,
  });

  final String category;
  final int openCount;
  final double sharePct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: Text(
              category,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '$openCount vị thế',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Text(
            VitFormat.percent(sharePct, fractionDigits: 1),
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

List<(String, int, double)> _sc218Categories(
  PredictionPortfolioAnalyzerSnapshot snapshot,
) {
  final totals = <String, double>{};
  final counts = <String, int>{};
  var grand = 0.0;
  for (final position in snapshot.openPositions) {
    final value = position.shares * position.currentPrice;
    totals[position.category] = (totals[position.category] ?? 0) + value;
    counts[position.category] = (counts[position.category] ?? 0) + 1;
    grand += value;
  }
  final entries = totals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return [
    for (final entry in entries)
      (
        entry.key,
        counts[entry.key] ?? 0,
        grand > 0 ? (entry.value / grand) * 100 : 0,
      ),
  ];
}

// --- Hiệu suất ---------------------------------------------------------------

class _Sc218PerformanceTab extends StatelessWidget {
  const _Sc218PerformanceTab({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlHistory = snapshot.pnlHistory;
    final winning = snapshot.closedPositions
        .where((position) => (position.closedPnl ?? 0) > 0)
        .length;
    final losing = snapshot.closedPositions.length - winning;

    return VitPageSection(
      label: 'Hiệu suất',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        if (pnlHistory.length >= 2)
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lãi/lũy lỗ theo thời gian',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
                SizedBox(
                  height: TabletSpacingTokens.x7 + TabletSpacingTokens.x5,
                  child: CustomPaint(
                    painter: _Sc218PnlLinePainter(points: pnlHistory),
                  ),
                ),
              ],
            ),
          ),
        VitCard(
          density: VitDensity.compact,
          child: Row(
            children: [
              Expanded(
                child: _Sc218SummaryMetric(
                  label: 'Lệnh thắng',
                  value: VitFormat.count(winning),
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _Sc218SummaryMetric(
                  label: 'Lệnh thua',
                  value: VitFormat.count(losing),
                  valueColor: AppColors.sell,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Rủi ro ------------------------------------------------------------------

class _Sc218RiskTab extends StatelessWidget {
  const _Sc218RiskTab({required this.snapshot});

  final PredictionPortfolioAnalyzerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlHistory = snapshot.pnlHistory;
    final drawdown = _sc218MaxDrawdown(pnlHistory);
    final volatility = _sc218Volatility(pnlHistory);
    final concentration = _sc218Concentration(snapshot);
    final sharpe = volatility > 0
        ? ((pnlHistory.isNotEmpty
                  ? (pnlHistory.last.value - pnlHistory.first.value) /
                        pnlHistory.length
                  : 0) /
              volatility)
        : 0;

    return VitPageSection(
      label: 'Rủi ro',
      accentColor: AppColors.warn,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              VitInfoRow(
                label: 'Sụt giảm tối đa',
                value: VitFormat.usd(drawdown),
                valueColor: AppColors.sell,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Biến động danh mục',
                value: VitFormat.usd(volatility),
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Tập trung (top 3)',
                value: VitFormat.percent(concentration, fractionDigits: 1),
                valueColor: AppColors.warn,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Chỉ số Sharpe',
                value: sharpe.toStringAsFixed(2),
                density: VitDensity.compact,
              ),
            ],
          ),
        ),
        const VitCard(
          density: VitDensity.compact,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Text(
                  'Chỉ số rủi ro suy ra từ dữ liệu giả lập. Danh mục tập '
                  'trung cao tăng rủi ro khi thị trường đảo chiều.',
                  style: AppTextStyles.numericMicro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

double _sc218MaxDrawdown(List<PredictionAnalyzerPnlPointDraft> points) {
  var peak = 0.0;
  var maxDrawdown = 0.0;
  for (final point in points) {
    if (point.value > peak) peak = point.value;
    final drawdown = peak - point.value;
    if (drawdown > maxDrawdown) maxDrawdown = drawdown;
  }
  return maxDrawdown;
}

double _sc218Volatility(List<PredictionAnalyzerPnlPointDraft> points) {
  if (points.length < 2) return 0;
  final diffs = <double>[];
  for (var i = 1; i < points.length; i += 1) {
    diffs.add(points[i].value - points[i - 1].value);
  }
  final mean = diffs.fold(0.0, (sum, diff) => sum + diff) / diffs.length;
  final variance =
      diffs.fold(0.0, (sum, diff) => sum + (diff - mean) * (diff - mean)) /
      diffs.length;
  return variance > 0 ? variance : 0;
}

double _sc218Concentration(PredictionPortfolioAnalyzerSnapshot snapshot) {
  final values = [
    for (final position in snapshot.openPositions)
      position.shares * position.currentPrice,
  ]..sort((a, b) => b.compareTo(a));
  final total = values.fold(0.0, (sum, value) => sum + value);
  if (total <= 0 || values.isEmpty) return 0;
  final top3 = values.take(3).fold(0.0, (sum, value) => sum + value);
  return (top3 / total) * 100;
}

class _Sc218PnlLinePainter extends CustomPainter {
  const _Sc218PnlLinePainter({required this.points});

  final List<PredictionAnalyzerPnlPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final values = [for (final point in points) point.value];
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final norm = range > 0 ? range : 1.0;

    double x(int index) => size.width * index / (points.length - 1);
    double y(double value) =>
        size.height - ((value - minValue) / norm) * size.height;

    final path = Path();
    for (var index = 0; index < points.length; index += 1) {
      if (index == 0) {
        path.moveTo(x(index), y(points[index].value));
      } else {
        path.lineTo(x(index), y(points[index].value));
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
          AppColors.primary.withValues(alpha: .30),
          AppColors.primary.withValues(alpha: .02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = TabletSpacingTokens.hairlineStroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _Sc218PnlLinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
