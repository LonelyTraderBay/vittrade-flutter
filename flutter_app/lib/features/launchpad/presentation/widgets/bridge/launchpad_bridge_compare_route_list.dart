part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _SortSelector extends StatelessWidget {
  const _SortSelector({
    required this.options,
    required this.activeValue,
    required this.onChanged,
  });

  final List<LaunchpadBridgeSortOptionDraft> options;
  final String activeValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final option in options) ...[
            VitFilterChip(
              key: LaunchpadBridgeComparePage.sortKey(option.value),
              label: option.label,
              active: option.value == activeValue,
              onTap: () => onChanged(option.value),
              color: AppColors.primary,
              padding: LaunchpadSpacingTokens.launchpadPillPadding,
              leading: Icon(
                _sortIcon(option.iconKey),
                size: LaunchpadSpacingTokens.launchpadIconSm,
              ),
              semanticLabel: 'Sắp xếp tuyến bridge theo ${option.label}',
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.rank,
    required this.comparison,
    required this.selected,
    required this.expanded,
    required this.onSelect,
    required this.onExpand,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final int rank;
  final LaunchpadBridgeComparisonDraft comparison;
  final bool selected;
  final bool expanded;
  final VoidCallback onSelect;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeComparePage.routeKey(route.id),
      radius: VitCardRadius.large,
      borderColor: selected
          ? route.accent.resolve().withValues(alpha: .48)
          : route.recommended
          ? AppColors.primary.withValues(alpha: .24)
          : AppColors.cardBorder,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          VitCard(
            key: LaunchpadBridgeComparePage.routeSelectKey(route.id),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            padding: LaunchpadSpacingTokens.launchpadPaddingX4,
            onTap: onSelect,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RankedProviderBadge(route: route, rank: rank),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              route.provider,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          if (route.recommended) const _RecommendedBadge(),
                        ],
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      _RouteTags(route: route, comparison: comparison),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _RouteMetrics(route: route, comparison: comparison),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? route.accent.resolve()
                      : AppColors.borderSolid,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          VitCard(
            key: LaunchpadBridgeComparePage.expandKey(route.id),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
            onTap: onExpand,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chi tiết',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
          if (expanded)
            _ExpandedRouteDetails(route: route, comparison: comparison),
        ],
      ),
    );
  }
}

class _RankedProviderBadge extends StatelessWidget {
  const _RankedProviderBadge({required this.route, required this.rank});

  final LaunchpadBridgeRouteOptionDraft route;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _ProviderBadge(
          label: route.providerIcon,
          accent: route.accent.resolve(),
          size: LaunchpadSpacingTokens.launchpadBox40,
        ),
        if (rank == 1)
          Positioned(
            top: -6,
            right: -6,
            child: SizedBox(
              width: LaunchpadSpacingTokens.launchpadBox17,
              height: LaunchpadSpacingTokens.launchpadBox17,
              child: DecoratedBox(
                decoration: const ShapeDecoration(
                  color: AppColors.primarySoft,
                  shape: CircleBorder(),
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                      height: LaunchpadSpacingTokens.launchpadLineHeightTight,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.primary08,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadMiniChipPadding,
        child: Text(
          'KHUYẾN NGHỊ',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
