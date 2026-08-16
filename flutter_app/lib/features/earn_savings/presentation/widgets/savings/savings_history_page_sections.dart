part of '../../phone/pages/savings/savings_history_page.dart';

class _SummaryMetrics extends StatelessWidget {
  const _SummaryMetrics({required this.snapshot});

  final SavingsHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryMetricTile(
            label: 'Tổng gửi',
            value: snapshot.totalSubscribed,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _SummaryMetricTile(
            label: 'Tổng lãi',
            value: snapshot.totalInterest,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _SummaryMetricTile(
            label: 'Đã rút',
            value: snapshot.totalRedeemed,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SummaryMetricTile extends StatelessWidget {
  const _SummaryMetricTile({
    required this.label,
    required this.value,
    this.color = AppColors.buy,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3X2,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.cardBorder),
          borderRadius: AppRadii.xlRadius,
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeFilterRow extends StatelessWidget {
  const _TypeFilterRow({required this.active, required this.onChanged});

  final _HistoryTypeFilter active;
  final ValueChanged<_HistoryTypeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = [
      _HistoryTypeFilter.all,
      _HistoryTypeFilter.subscribe,
      _HistoryTypeFilter.redeem,
      _HistoryTypeFilter.interest,
      _HistoryTypeFilter.compound,
      _HistoryTypeFilter.early,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            VitChoicePill(
              label: _typeFilterLabel(filter),
              selected: filter == active,
              onTap: () => onChanged(filter),
              accentColor: AppModuleAccents.earn,
              padding: EarnSpacingTokens.earnWidePillPadding,
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _DateFilterRow extends StatelessWidget {
  const _DateFilterRow({required this.active, required this.onChanged});

  final _HistoryDateFilter active;
  final ValueChanged<_HistoryDateFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = [
      _HistoryDateFilter.d7,
      _HistoryDateFilter.d30,
      _HistoryDateFilter.d90,
      _HistoryDateFilter.all,
    ];
    return Row(
      children: [
        Expanded(
          child: VitPresetChipRow<_HistoryDateFilter>(
            accentColor: AppModuleAccents.earn,
            selectedValue: active,
            onTap: onChanged,
            items: [
              for (final filter in filters)
                VitPresetChipItem(
                  value: filter,
                  label: _dateFilterLabel(filter),
                  semanticLabel: 'Lọc thời gian ${_dateFilterLabel(filter)}',
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        const DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.surface2,
            shape: CircleBorder(),
          ),
          child: SizedBox(
            width: EarnSpacingTokens.savingsHistoryFilterButton,
            height: EarnSpacingTokens.savingsHistoryFilterButton,
            child: Icon(
              Icons.filter_alt_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count giao dịch',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const Expanded(child: SizedBox()),
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
          ),
          child: Padding(
            padding: EarnSpacingTokens.earnPillPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  'Xuất CSV',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_month_outlined,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          date,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x2),
        const Expanded(
          child: Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
        ),
      ],
    );
  }
}
