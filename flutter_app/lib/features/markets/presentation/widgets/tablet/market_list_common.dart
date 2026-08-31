import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';

const marketListPrimary = AppColors.primary;
const marketListPredictionAccent = AppColors.accent;
const marketListArenaAccent = AppColors.caution;

/// Sort column ids → the state controller's sort values (`MarketSortOption`
/// ids). `volume` has no ascending option in the shared sort set, so its
/// cycle is default → desc → default.
const marketListSortCycle = <String, List<String>>{
  'price': ['price_desc', 'price_asc'],
  'change': ['change_desc', 'change_asc'],
  'volume': ['volume_desc'],
};

/// Next sort value when the user taps the sort header [columnId] while
/// [activeSort] is current. Tapping an inactive column starts at that
/// column's first step; tapping through the cycle's end falls back to
/// `'default'`.
String nextSortForColumn(String columnId, String activeSort) {
  final cycle = marketListSortCycle[columnId] ?? const <String>[];
  if (cycle.isEmpty) return activeSort;
  if (!cycle.contains(activeSort)) return cycle.first;
  final index = cycle.indexOf(activeSort);
  return index + 1 < cycle.length ? cycle[index + 1] : 'default';
}

/// One tappable sort header cell (label + direction icon). Shared by the
/// terminal master list's compact sort row; carries the input-state tokens
/// (`AppInputStates`) via its `InkWell` so hover/focus never go off-token.
class MarketListSortHeaderCell extends StatelessWidget {
  const MarketListSortHeaderCell({
    super.key,
    required this.columnId,
    required this.label,
    required this.activeSort,
    required this.onSortSelected,
  });

  final String columnId;
  final String label;
  final String activeSort;
  final ValueChanged<String> onSortSelected;

  @override
  Widget build(BuildContext context) {
    final cycle = marketListSortCycle[columnId] ?? const <String>[];
    final active = cycle.contains(activeSort);
    final ascending = active && activeSort.endsWith('_asc');
    return Semantics(
      button: true,
      label: 'Sắp xếp theo $label',
      child: Tooltip(
        message: 'Sắp xếp theo $label',
        child: InkWell(
          key: MarketsTabletKeys.sortColumn(columnId),
          onTap: () => onSortSelected(nextSortForColumn(columnId, activeSort)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: active ? AppColors.text1 : AppColors.text3,
                    fontWeight: active ? AppTextStyles.bold : null,
                  ),
                ),
              ),
              Icon(
                active
                    ? (ascending
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded)
                    : Icons.unfold_more_rounded,
                size: TabletSpacingTokens.iconSm,
                color: active ? AppColors.text1 : AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketListSparklinePainter extends CustomPainter {
  const MarketListSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - minValue) / range * (size.height - 6)) -
          3;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant MarketListSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

String marketListFormatPrice(double value) {
  if (value >= 1) {
    return _formatFixed(value, 2);
  }
  if (value >= 0.01) {
    return _formatFixed(value, 4);
  }
  return _formatFixed(value, 6);
}

String _formatFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String marketListFormatPct(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String marketListFormatVolume(double value) {
  if (value >= 1e9) {
    return '\$${(value / 1e9).toStringAsFixed(1)}B';
  }
  if (value >= 1e6) {
    return '\$${(value / 1e6).toStringAsFixed(1)}M';
  }
  if (value >= 1e3) {
    return '\$${(value / 1e3).toStringAsFixed(1)}K';
  }
  return '\$${value.toStringAsFixed(0)}';
}

/// [marketListFormatVolume] extended one tier (trillions) for market-cap
/// figures on the tablet pair table and pulse banner.
String marketListFormatMarketCap(double value) {
  if (value >= 1e12) {
    return '\$${(value / 1e12).toStringAsFixed(2)}T';
  }
  return marketListFormatVolume(value);
}
