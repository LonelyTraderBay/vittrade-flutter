part of '../../phone/pages/points/arena_points_ledger_page.dart';

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.summary});

  final ArenaPointsLedgerSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _LedgerHeroKpi(
                  label: 'Số dư hiện tại',
                  value: '${formatArenaPoints(summary.currentBalance)} pts',
                  valueStyle: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    letterSpacing: 0,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _LedgerHeroKpi(
                    label: 'Đã nhận',
                    value: '+${formatArenaPoints(summary.pointsEarned)}',
                    valueStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Text(
                'Đã dùng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Spacer(),
              Text(
                '-${formatArenaPoints(summary.pointsSpent)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LedgerHeroKpi extends StatelessWidget {
  const _LedgerHeroKpi({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: valueStyle,
        ),
      ],
    );
  }
}

class _LedgerFilterRow extends StatelessWidget {
  const _LedgerFilterRow({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<ArenaPointsLedgerFilterDraft> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            VitFilterChip(
              key: ArenaPointsLedgerPage.filterKey(filter.id),
              label: filter.label,
              active: filter.id == activeFilter,
              onTap: () => onChanged(filter.id),
              color: AppModuleAccents.arena,
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _LedgerList extends StatelessWidget {
  const _LedgerList({required this.entries});

  final List<ArenaPointsLedgerEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _LedgerRow(entry: entries[i]),
            if (i < entries.length - 1)
              const Divider(
                height: _ledgerDividerExtent,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.entry});

  final ArenaPointsLedgerEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final color = _entryColor(entry.typeId);

    return Material(
      type: MaterialType.transparency,
      child: VitCard(
        key: ArenaPointsLedgerPage.entryKey(entry.id),
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          context.go(AppRoutePaths.arenaLedgerEntry(entry.id));
        },
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: Padding(
          padding: ArenaSpacingTokens.arenaPointsLedgerRowPadding,
          child: Row(
            children: [
              _LedgerIcon(typeId: entry.typeId, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        _TypeBadge(label: entry.typeLabel, color: color),
                        const SizedBox(width: AppSpacing.x2),
                        Flexible(
                          child: Text(
                            entry.time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: _ledgerCompactLineRatio,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _amountLabel(entry.amount),
                    style: AppTextStyles.caption.copyWith(
                      color: _amountColor(entry.amount),
                      fontWeight: AppTextStyles.bold,
                      height: _ledgerCompactLineRatio,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.text3,
                        size: ArenaSpacingTokens
                            .arenaPointsLedgerBalanceArrowIcon,
                      ),
                      const SizedBox(
                        width:
                            ArenaSpacingTokens.arenaPointsLedgerBalanceArrowGap,
                      ),
                      Text(
                        formatArenaPoints(entry.balanceAfter),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: _ledgerCompactLineRatio,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LedgerIcon extends StatelessWidget {
  const _LedgerIcon({required this.typeId, required this.color});

  final String typeId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: ArenaSpacingTokens.arenaPointsLedgerIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: _entryTint(typeId),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Icon(
            _entryIcon(typeId),
            color: color,
            size: ArenaSpacingTokens.arenaPointsLedgerGlyph,
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaPointsLedgerBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _ledgerCompactLineRatio,
          ),
        ),
      ),
    );
  }
}

class _AuditNotice extends StatelessWidget {
  const _AuditNotice({required this.disclaimer});

  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaPointsLedgerNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: ArenaSpacingTokens.arenaPointsInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              disclaimer,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _ledgerNoticeLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
