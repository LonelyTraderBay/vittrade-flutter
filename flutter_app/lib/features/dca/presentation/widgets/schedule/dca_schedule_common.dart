part of '../../phone/pages/schedule/dca_schedule_config_page.dart';

IconData _iconForOption(DcaScheduleOptionIcon icon) {
  switch (icon) {
    case DcaScheduleOptionIcon.clock:
      return Icons.schedule_outlined;
    case DcaScheduleOptionIcon.trend:
      return Icons.trending_down;
    case DcaScheduleOptionIcon.bolt:
      return Icons.bolt_outlined;
    case DcaScheduleOptionIcon.chart:
      return Icons.bar_chart;
  }
}

Color _accentForStrategy(DcaScheduleStrategy strategy) {
  switch (strategy) {
    case DcaScheduleStrategy.fixed:
      return AppColors.text3;
    case DcaScheduleStrategy.volatility:
      return AppColors.accent;
    case DcaScheduleStrategy.gasOptimized:
      return AppColors.warn;
    case DcaScheduleStrategy.volume:
      return AppColors.primarySoft;
    case DcaScheduleStrategy.hybrid:
      return AppColors.buy;
  }
}
