part of '../../phone/pages/provider/provider_leaderboard_page.dart';

class _SurvivorshipWarning extends StatelessWidget {
  const _SurvivorshipWarning({required this.snapshot});

  final TradeProviderLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerLeaderboardWarningPadding,
      density: VitDensity.tool,
      borderColor: _leaderWarningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _leaderWarningText,
            size: TradeSpacingTokens.providerLeaderboardWarningIcon,
          ),
          const SizedBox(width: _leaderSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _leaderWarningText,
                    fontWeight: AppTextStyles.bold,
                    height: _leaderLineFlat,
                  ),
                ),
                const SizedBox(height: _leaderTinySpace),
                Text(
                  snapshot.warningText,
                  style: AppTextStyles.micro.copyWith(
                    color: _leaderWarningText,
                    fontWeight: AppTextStyles.medium,
                    height: _leaderLineReadable,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortTabs extends StatelessWidget {
  const _SortTabs({
    required this.options,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderLeaderboardSort> options;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.searchBarCompactHeight,
      child: VitSegmentedTabBar(
        activeKey: activeId,
        onChanged: onChanged,
        tabs: [
          for (final option in options)
            VitTabItem(
              key: option.id,
              label: option.label,
              widgetKey: ProviderLeaderboardPage.sortKey(option.id),
            ),
        ],
      ),
    );
  }
}

class _RiskFilters extends StatelessWidget {
  const _RiskFilters({
    required this.filters,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderLeaderboardRiskFilter> filters;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Level',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: _leaderLineFlat,
          ),
        ),
        const SizedBox(height: _leaderTinySpace),
        Row(
          children: [
            for (final filter in filters) ...[
              _RiskChip(
                filter: filter,
                selected: filter.id == activeId,
                onTap: () => onChanged(filter.id),
              ),
              if (filter != filters.last) const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final TradeProviderLeaderboardRiskFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      key: ProviderLeaderboardPage.riskKey(filter.id),
      label: filter.label,
      status: selected ? VitStatusPillStatus.info : VitStatusPillStatus.neutral,
      size: VitStatusPillSize.md,
      onTap: onTap,
    );
  }
}

class _VerifiedToggle extends StatelessWidget {
  const _VerifiedToggle({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: ProviderLeaderboardPage.verifiedToggleKey,
      height: AppSpacing.searchBarCompactHeight,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerLeaderboardVerifiedPadding,
      density: VitDensity.tool,
      variant: VitCardVariant.inner,
      borderColor: AppColors.cardBorder,
      onTap: () => onChanged(!checked),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: checked ? _leaderPrimary : AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: _leaderLineFlat,
              ),
            ),
          ),
          VitTogglePill(
            enabled: checked,
            activeColor: _leaderPrimary,
            inactiveColor: AppColors.borderSolid,
            inactiveKnobColor: AppColors.onAccent,
          ),
        ],
      ),
    );
  }
}
