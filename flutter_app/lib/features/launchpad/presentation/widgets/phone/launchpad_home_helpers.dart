part of '../../phone/pages/hub/launchpad_page.dart';

enum _LaunchpadTab {
  all('all', 'Tất cả'),
  active('active', 'Đang mở'),
  upcoming('upcoming', 'Sắp tới'),
  ended('ended', 'Đã kết thúc');

  const _LaunchpadTab(this.id, this.label);

  final String id;
  final String label;
}

final class _LabelStyle {
  const _LabelStyle({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

List<LaunchpadProjectDraft> _projectsFor(
  List<LaunchpadProjectDraft> projects,
  _LaunchpadTab tab,
) {
  final status = switch (tab) {
    _LaunchpadTab.all => null,
    _LaunchpadTab.active => LaunchpadProjectStatus.active,
    _LaunchpadTab.upcoming => LaunchpadProjectStatus.upcoming,
    _LaunchpadTab.ended => LaunchpadProjectStatus.ended,
  };
  if (status == null) return projects;
  return projects.where((project) => project.status == status).toList();
}

_LabelStyle _typeStyle(LaunchpadProjectType type) {
  return switch (type) {
    LaunchpadProjectType.ieo => const _LabelStyle(
      label: 'IEO',
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    LaunchpadProjectType.ido => const _LabelStyle(
      label: 'IDO',
      color: AppColors.accent,
      background: AppColors.accent12,
    ),
    LaunchpadProjectType.launchpool => const _LabelStyle(
      label: 'Launchpool',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
  };
}

_LabelStyle _statusStyle(LaunchpadProjectStatus status) {
  return switch (status) {
    LaunchpadProjectStatus.upcoming => const _LabelStyle(
      label: 'Sắp diễn ra',
      color: AppColors.warn,
      background: AppColors.warn10,
    ),
    LaunchpadProjectStatus.active => const _LabelStyle(
      label: 'Đang diễn ra',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    LaunchpadProjectStatus.ended => const _LabelStyle(
      label: 'Đã kết thúc',
      color: AppColors.text2,
      background: AppColors.surface2,
    ),
  };
}

IconData _toolIcon(String key) {
  return switch (key) {
    'bell' => Icons.notifications_none_rounded,
    'event' => Icons.receipt_long_outlined,
    'compare' => Icons.compare_arrows_rounded,
    'book' => Icons.menu_book_outlined,
    'webhook' => Icons.hub_outlined,
    'fuel' => Icons.local_gas_station_outlined,
    'pie' => Icons.donut_large_rounded,
    'lock' => Icons.lock_outline_rounded,
    'swap' => Icons.swap_horiz_rounded,
    'clock' => Icons.schedule_rounded,
    'money' => Icons.attach_money_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.apps_rounded,
  };
}
