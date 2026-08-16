part of '../../phone/pages/settings/bot_guide_page.dart';

IconData _strategyIcon(String key) => switch (key) {
  'grid' => Icons.grid_view_rounded,
  'bolt' => Icons.bolt_rounded,
  'alert' => Icons.warning_amber_rounded,
  _ => Icons.trending_up_rounded,
};

IconData _practiceIcon(String key) => switch (key) {
  'chart' => Icons.bar_chart_rounded,
  'shield' => Icons.shield_outlined,
  'eye' => Icons.visibility_outlined,
  'target' => Icons.track_changes_rounded,
  'warning' => Icons.warning_amber_rounded,
  _ => Icons.lightbulb_outline_rounded,
};
