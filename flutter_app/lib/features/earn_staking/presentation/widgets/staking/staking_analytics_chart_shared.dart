part of '../../phone/pages/staking/staking_analytics_page.dart';

const double _stakingAnalyticsChartHeight = 164;
const double _stakingAnalyticsInsightLineHeight = 1.22;
const double _stakingAnalyticsFooterLineHeight = 1.18;
const double _stakingAnalyticsLegendMarkerHeight = 6;

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.entries});

  final List<_LegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x2,
      children: [
        for (final entry in entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: entry.color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.swatchRadius,
                  ),
                ),
                child: const SizedBox(
                  width: EarnSpacingTokens.earnAnalyticsLegendMarkerWidth,
                  height: _stakingAnalyticsLegendMarkerHeight,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                entry.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LegendEntry {
  const _LegendEntry({required this.label, required this.color});

  final String label;
  final Color color;
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: _stakingAnalyticsCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.primary,
              size: EarnSpacingTokens.earnAnalyticsInsightIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _stakingAnalyticsInsightLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingAnalyticsCardPadding,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: _stakingAnalyticsFooterLineHeight,
        ),
      ),
    );
  }
}

class _YAxisLabels extends StatelessWidget {
  const _YAxisLabels({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: EarnSpacingTokens.earnAnalyticsAxisWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final label in labels)
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
        ],
      ),
    );
  }
}

class _DateLabels extends StatelessWidget {
  const _DateLabels({required this.dates});

  final List<String> dates;

  @override
  Widget build(BuildContext context) {
    final indexes = <int>{0, 1, 2, 3, dates.length - 1}.toList()..sort();

    return Row(
      children: [
        for (final index in indexes)
          Expanded(
            child: Text(
              dates[index],
              textAlign: index == 0
                  ? TextAlign.left
                  : index == dates.length - 1
                  ? TextAlign.right
                  : TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
      ],
    );
  }
}

final class _AssetPalette {
  const _AssetPalette._();

  static const Color btc = AppColors.primary;
  static const Color usdt = AppColors.buy;
  static const Color eth = AppColors.accent;
  static const Color sol = AppColors.primarySoft;
  static const Color lp = AppColors.sell;
}

void _paintGrid(Canvas canvas, Size size, int lines) {
  final paint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (var i = 0; i <= lines; i++) {
    final y = size.height * i / lines;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
}

Path _linePath(Size size, List<double> values, double maxValue) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final point = Offset(
      _x(size, i, values.length),
      _y(size, values[i], maxValue),
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  return path;
}

double _x(Size size, int index, int length) {
  if (length <= 1) return 0;
  return size.width * index / (length - 1);
}

double _y(Size size, double value, double maxValue, {double minValue = 0}) {
  final safeRange = math.max(1, maxValue - minValue);
  final normalized = ((value - minValue) / safeRange).clamp(0.0, 1.0);
  return size.height - normalized * size.height;
}

Color _assetColor(int index) {
  return switch (index) {
    0 => _AssetPalette.btc,
    1 => _AssetPalette.usdt,
    2 => _AssetPalette.eth,
    3 => _AssetPalette.sol,
    _ => _AssetPalette.lp,
  };
}
