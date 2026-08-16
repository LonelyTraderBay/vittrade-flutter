part of '../phone/pages/announcements_page.dart';

class _AnnouncementTypeFilters extends StatelessWidget {
  const _AnnouncementTypeFilters({
    required this.filters,
    required this.activeFilterId,
    required this.onChanged,
  });

  final List<AnnouncementFilterDraft> filters;
  final String activeFilterId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: AnnouncementsPage.filtersKey,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: SupportSpacingTokens.supportFilterRailPadding,
      child: Row(
        children: [
          for (final filter in filters) ...[
            VitChoicePill(
              key: AnnouncementsPage.filterKey(filter.id),
              label: filter.label,
              selected: filter.id == activeFilterId,
              onTap: () => onChanged(filter.id),
              height: SupportSpacingTokens.supportFilterChipHeight,
              padding: SupportSpacingTokens.supportFilterChipPadding,
              accentColor: AppColors.primary,
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}
