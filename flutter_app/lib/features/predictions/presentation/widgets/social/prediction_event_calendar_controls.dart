part of '../../phone/pages/social/prediction_event_calendar_page.dart';

class _EventCalendarTabBar extends StatelessWidget {
  const _EventCalendarTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _CalendarTab activeTab;
  final ValueChanged<_CalendarTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_CalendarTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      items: const [
        (
          PredictionEventCalendarPage.calendarTabKey,
          _CalendarTab.calendar,
          'Lich',
        ),
        (
          PredictionEventCalendarPage.upcomingTabKey,
          _CalendarTab.upcoming,
          'Sap toi',
        ),
        (
          PredictionEventCalendarPage.notificationsTabKey,
          _CalendarTab.notifications,
          'Thong bao',
        ),
      ],
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.snapshot,
    required this.selectedCategory,
    required this.onChanged,
  });

  final PredictionEventCalendarSnapshot snapshot;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        VitFilterChip(
          label: 'Tat ca',
          active: selectedCategory == null,
          onTap: () => onChanged(null),
          color: _predictionPrimary,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x1,
          ),
        ),
        for (final category in snapshot.categories)
          VitFilterChip(
            key: PredictionEventCalendarPage.categoryKey(category),
            label: category,
            active: selectedCategory == category,
            onTap: () => onChanged(category),
            color: _predictionPrimary,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x1,
            ),
          ),
      ],
    );
  }
}
