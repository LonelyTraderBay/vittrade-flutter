part of '../../phone/pages/security/p2p_blacklist_page.dart';

class _BlacklistStats extends StatelessWidget {
  const _BlacklistStats({required this.snapshot, required this.entries});

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    final recentCount = entries.where((item) => item.recent30d).length;
    final reasonCount = _reasonCounts(
      entries,
    ).values.where((count) => count > 0).length;

    return Row(
      key: P2PBlacklistPage.summaryKey,
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.person_remove_alt_1_outlined,
            value: '${entries.length}',
            label: 'Đã chặn',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.schedule_rounded,
            value: '$recentCount',
            label: '30 ngày qua',
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.block_rounded,
            value: '$reasonCount',
            label: 'Lý do',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: AppSpacing.buttonCompact,
            child: Material(
              type: MaterialType.transparency,
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.lgRadius,
              child: Icon(icon, color: color, size: AppSpacing.iconMd),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _BlacklistReasonFilters extends StatelessWidget {
  const _BlacklistReasonFilters({
    required this.snapshot,
    required this.entries,
    required this.activeId,
    required this.onChanged,
  });

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final counts = _reasonCounts(entries);
    final filters = [
      P2PBlacklistReasonDraft(
        id: 'all',
        label: 'Tất cả (${entries.length})',
        iconKey: 'info',
        toneKey: 'primary',
      ),
      ...snapshot.reasons
          .where((reason) => (counts[reason.id] ?? 0) > 0)
          .map(
            (reason) => P2PBlacklistReasonDraft(
              id: reason.id,
              label: '${reason.label} (${counts[reason.id]})',
              iconKey: reason.iconKey,
              toneKey: reason.toneKey,
            ),
          ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: P2PSpacingTokens.p2pBlacklistFilterRailPadding,
      child: Row(
        children: [
          for (final filter in filters) ...[
            VitFilterChip(
              key: P2PBlacklistPage.filterKey(filter.id),
              label: filter.label,
              active: filter.id == activeId,
              onTap: () => onChanged(filter.id),
              color: filter.id == 'all'
                  ? AppModuleAccents.p2p
                  : _reasonColor(filter),
              padding: P2PSpacingTokens.p2pBlacklistListFilterChipPadding,
              semanticLabel: 'Bộ lọc danh sách đen ${filter.label}',
            ),
            const SizedBox(width: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}
