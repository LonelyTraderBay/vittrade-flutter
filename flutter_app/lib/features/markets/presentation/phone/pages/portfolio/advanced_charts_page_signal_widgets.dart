part of 'advanced_charts_page.dart';

class _SignalSummaryCard extends StatelessWidget {
  const _SignalSummaryCard({required this.signal});

  final TechSignalSummaryDraft signal;

  @override
  Widget build(BuildContext context) {
    final signalMeta = _signalMeta(signal.overallSignal);
    final maMeta = _signalMeta(signal.maSummary);
    final oscMeta = _signalMeta(signal.oscSummary);

    return VitCard(
      padding: _advancedCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      signal.pair,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: _advancedCompactGap),
                    Material(
                      color: AppColors.surface2,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.xsRadius,
                      ),
                      child: Padding(
                        padding: _advancedCategoryBadgePadding,
                        child: Text(
                          signal.timeframe,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: _advancedLineHeightCaption,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _SignalPill(meta: signalMeta),
            ],
          ),
          const SizedBox(height: _advancedFooterGap),
          _SignalBar(signal: signal),
          const SizedBox(height: _advancedGap),
          Row(
            children: [
              Expanded(
                child: _SignalMetricCard(
                  label: 'Moving Averages',
                  meta: maMeta,
                ),
              ),
              const SizedBox(width: _advancedCompactGap),
              Expanded(
                child: _SignalMetricCard(label: 'Oscillators', meta: oscMeta),
              ),
            ],
          ),
          const SizedBox(height: _advancedGap),
          Text(
            'Pivot Points',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _advancedMiniHeaderGap),
          _PivotPoints(points: signal.pivotPoints),
        ],
      ),
    );
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({required this.meta});

  final _SignalMeta meta;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: meta.label, accentColor: meta.color);
  }
}

class _SignalBar extends StatelessWidget {
  const _SignalBar({required this.signal});

  final TechSignalSummaryDraft signal;

  @override
  Widget build(BuildContext context) {
    final total = signal.buyCount + signal.sellCount + signal.neutralCount;
    return Column(
      children: [
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: _advancedSignalBarHeight,
            child: Row(
              children: [
                Expanded(
                  flex: signal.buyCount,
                  child: const ColoredBox(color: AppColors.buy),
                ),
                Expanded(
                  flex: signal.neutralCount,
                  child: const ColoredBox(color: AppColors.text3),
                ),
                Expanded(
                  flex: signal.sellCount,
                  child: const ColoredBox(color: AppColors.sell),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: _advancedSmallGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CountText(
              label: 'Mua',
              count: signal.buyCount,
              color: AppColors.buy,
            ),
            Text(
              'Trung lập ${signal.neutralCount}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            _CountText(
              label: 'Bán',
              count: signal.sellCount,
              color: AppColors.sell,
            ),
          ],
        ),
        Semantics(label: 'Tổng tín hiệu $total'),
      ],
    );
  }
}

class _CountText extends StatelessWidget {
  const _CountText({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label $count',
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _SignalMetricCard extends StatelessWidget {
  const _SignalMetricCard({required this.label, required this.meta});

  final String label;
  final _SignalMeta meta;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      child: Padding(
        padding: _advancedSignalMetricPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.dividerHairline),
            Text(
              meta.label,
              style: AppTextStyles.caption.copyWith(
                color: meta.color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PivotPoints extends StatelessWidget {
  const _PivotPoints({required this.points});

  final List<TechPivotPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final point in points) ...[
          Expanded(child: _PivotPointCell(point: point)),
          if (point != points.last)
            const SizedBox(width: AppSpacing.dividerHairline),
        ],
      ],
    );
  }
}

class _PivotPointCell extends StatelessWidget {
  const _PivotPointCell({required this.point});

  final TechPivotPointDraft point;

  @override
  Widget build(BuildContext context) {
    final isPivot = point.label == 'Pivot';
    final isSupport = point.label.startsWith('S');
    final color = isPivot
        ? _marketPrimary
        : isSupport
        ? AppColors.buy
        : AppColors.sell;

    return Material(
      color: isPivot ? color.withValues(alpha: .08) : AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.xsRadius,
        side: isPivot
            ? BorderSide(color: color.withValues(alpha: .20))
            : BorderSide.none,
      ),
      child: Padding(
        padding: _advancedPivotPadding,
        child: Column(
          children: [
            Text(
              point.label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: _advancedLineHeightCaption,
              ),
            ),
            const SizedBox(height: AppSpacing.dividerHairline),
            Text(
              _formatPrice(point.value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _advancedLineHeightCaption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AdvancedChartCategory? _categoryFor(
  List<AdvancedChartCategory> categories,
  String id,
) {
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return null;
}

_SignalMeta _signalMeta(TechSignal signal) {
  return switch (signal) {
    TechSignal.strongBuy => const _SignalMeta('Mua mạnh', AppColors.buyDark),
    TechSignal.buy => const _SignalMeta('Mua', AppColors.buy),
    TechSignal.neutral => const _SignalMeta('Trung lập', AppColors.text3),
    TechSignal.sell => const _SignalMeta('Bán', AppColors.sell),
    TechSignal.strongSell => const _SignalMeta('Bán mạnh', AppColors.sellDark),
  };
}

final class _SignalMeta {
  const _SignalMeta(this.label, this.color);

  final String label;
  final Color color;
}

String _formatPrice(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return '\$${buffer.toString()}';
}
