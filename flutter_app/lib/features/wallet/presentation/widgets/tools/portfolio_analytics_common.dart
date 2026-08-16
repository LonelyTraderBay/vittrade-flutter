part of '../../phone/pages/tools/portfolio_analytics_page.dart';

class _PlaceholderAnalyticsView extends StatelessWidget {
  const _PlaceholderAnalyticsView({required this.view});

  final String view;

  @override
  Widget build(BuildContext context) {
    final title = view == 'allocation'
        ? 'Ph\u00E2n b\u1ED5 danh m\u1EE5c'
        : 'L\u00E3i/L\u1ED7';

    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: VitSectionHeader(
        title: title,
        bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        icon: view == 'allocation'
            ? Icons.pie_chart_outline_rounded
            : Icons.trending_up_rounded,
        iconColor: _analyticsPrimary,
        density: VitDensity.compact,
      ),
    );
  }
}

String _formatUsd(double value, {bool symbol = true}) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs();
  final fixed = abs.toStringAsFixed(abs < 1 ? 4 : 2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  final prefix = symbol ? '\$' : '';
  return '$sign$prefix${buffer.toString()}.${parts[1]}';
}

String _formatCompactMoney(double value) {
  final fixed = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < fixed.length; i++) {
    if (i > 0 && (fixed.length - i) % 3 == 0) buffer.write(',');
    buffer.write(fixed[i]);
  }
  return buffer.toString();
}
