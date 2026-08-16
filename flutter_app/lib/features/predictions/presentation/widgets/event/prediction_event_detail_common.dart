part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: PredictionsSpacingTokens.predictionHomeStatIcon,
        ),
        const SizedBox(
          width: PredictionsSpacingTokens.predictionHomeStatIconGap,
        ),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ChangeLabel extends StatelessWidget {
  const _ChangeLabel({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          value >= 0 ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
          color: color,
          size: PredictionsSpacingTokens.predictionHomeTrendIcon,
        ),
        Text(
          _formatPercent(value),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionHomeBadgePadding,
        child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) => VitFormat.usd(value.abs());

String _formatPrice(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return buffer.toString();
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _formatDate(DateTime value) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

// NOTE: countdown formatting for this page's `_timeRemaining(...)` call
// sites now lives in `predictionsTimeRemaining()`
// (widgets/predictions_time_remaining.dart), imported by
// prediction_event_detail_page.dart.
