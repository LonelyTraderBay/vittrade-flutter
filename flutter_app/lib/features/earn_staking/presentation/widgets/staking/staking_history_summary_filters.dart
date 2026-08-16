part of '../../phone/pages/staking/staking_history_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final StakingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingHistoryPage.summaryKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Đã stake',
              value: EarnFormatters.usd(snapshot.totalStakedUsd),
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              label: 'Đã nhận',
              value: '+${EarnFormatters.usd(snapshot.totalEarnedUsd)}',
              color: AppColors.primarySoft,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              label: 'Đã rút',
              value: EarnFormatters.usd(snapshot.totalUnstakedUsd),
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchAndActions extends StatelessWidget {
  const _SearchAndActions({
    required this.controller,
    required this.placeholder,
    required this.filtersActive,
    required this.onQueryChanged,
    required this.onFilter,
    required this.onExport,
  });

  final TextEditingController controller;
  final String placeholder;
  final bool filtersActive;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSearchBar(
            fieldKey: StakingHistoryPage.searchKey,
            controller: controller,
            placeholder: placeholder,
            variant: VitSearchBarVariant.compact,
            onChanged: onQueryChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        _RoundActionButton(
          key: StakingHistoryPage.filterButtonKey,
          type: VitHeaderActionType.filter,
          active: filtersActive,
          onTap: onFilter,
        ),
        const SizedBox(width: AppSpacing.x2),
        _RoundActionButton(
          key: StakingHistoryPage.exportButtonKey,
          type: VitHeaderActionType.export,
          onTap: onExport,
        ),
      ],
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    super.key,
    required this.type,
    required this.onTap,
    this.active = false,
  });

  final VitHeaderActionType type;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return VitHeaderActionButton(
      type: type,
      active: active,
      tone: active ? VitHeaderActionTone.primary : VitHeaderActionTone.neutral,
      onPressed: onTap,
    );
  }
}

class _HistoryFilterSection extends StatelessWidget {
  const _HistoryFilterSection({
    super.key,
    required this.typeFilter,
    required this.statusFilter,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onClear,
  });

  final _HistoryTypeFilter typeFilter;
  final _HistoryStatusFilter statusFilter;
  final ValueChanged<_HistoryTypeFilter> onTypeChanged;
  final ValueChanged<_HistoryStatusFilter> onStatusChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitCtaButton(
                onPressed: onClear,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                child: const Text('Xóa'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Loại giao dịch',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final value in _HistoryTypeFilter.values)
                VitChoicePill(
                  label: _typeFilterLabel(value),
                  selected: value == typeFilter,
                  onTap: () => onTypeChanged(value),
                  tone: VitChoicePillTone.primary,
                  padding: EarnSpacingTokens.earnPillPaddingLarge,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Trạng thái',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final value in _HistoryStatusFilter.values)
                VitChoicePill(
                  label: _statusFilterLabel(value),
                  selected: value == statusFilter,
                  onTap: () => onStatusChanged(value),
                  tone: VitChoicePillTone.primary,
                  padding: EarnSpacingTokens.earnPillPaddingLarge,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.count,
    required this.filtered,
    required this.total,
    required this.onClear,
  });

  final int count;
  final bool filtered;
  final int total;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            filtered
                ? '$count giao dịch (đã lọc từ $total)'
                : '$count giao dịch',
            key: StakingHistoryPage.resultCountKey,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        if (filtered)
          VitCtaButton(
            onPressed: onClear,
            variant: VitCtaButtonVariant.ghost,
            fullWidth: false,
            child: const Text('Xóa bộ lọc'),
          ),
      ],
    );
  }
}
