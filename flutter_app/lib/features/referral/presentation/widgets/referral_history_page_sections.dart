part of '../phone/pages/referral_history_page.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final ReferralStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return VitStatsGrid(
      key: ReferralHistoryPage.statsKey,
      padding: EdgeInsets.zero,
      gap: AppSpacing.x4,
      cellBackground: true,
      cells: [
        VitStatCell(
          label: 'Tổng bạn bè',
          value: '${stats.totalFriends}',
          valueColor: AppColors.primary,
          valueStyle: AppTextStyles.base.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        VitStatCell(
          label: 'Đã KYC',
          value: '${stats.kycCompleted}',
          valueColor: AppColors.buy,
          valueStyle: AppTextStyles.base.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        VitStatCell(
          label: 'Hoạt động',
          value: '${stats.activeFriends}',
          valueColor: AppColors.accent,
          valueStyle: AppTextStyles.base.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ReferralFriendFilters extends StatelessWidget {
  const _ReferralFriendFilters({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralFilterDraft> filters;
  final ReferralFriendFilter active;
  final ValueChanged<ReferralFriendFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralHistoryPage.filtersKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in filters) ...[
            VitChoicePill(
              key: ReferralHistoryPage.filterKey(item.filter),
              label: '${item.label} (${item.count})',
              selected: item.filter == active,
              onTap: () => onChanged(item.filter),
              accentColor: AppColors.primary,
              height: ReferralSpacingTokens.referralHistoryFilterHeight,
              padding: ReferralSpacingTokens.referralFilterChipPadding,
            ),
            const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _SortRail extends StatelessWidget {
  const _SortRail({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralSortDraft> options;
  final ReferralHistorySort active;
  final ValueChanged<ReferralHistorySort> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSortRail<ReferralHistorySort>(
      key: ReferralHistoryPage.sortKey,
      selected: active,
      onChanged: onChanged,
      optionHeight: ReferralSpacingTokens.referralStepBox,
      optionPadding: ReferralSpacingTokens.referralSortChipPadding,
      iconSize: ReferralSpacingTokens.referralSortIcon,
      options: [
        for (final option in options)
          VitSortRailOption(
            key: ReferralHistoryPage.sortOptionKey(option.sort),
            value: option.sort,
            label: option.label,
          ),
      ],
    );
  }
}
