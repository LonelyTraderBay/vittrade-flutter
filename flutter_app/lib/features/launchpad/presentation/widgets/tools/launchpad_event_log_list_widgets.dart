part of '../../phone/pages/tools/launchpad_event_log_page.dart';

class _EventList extends StatelessWidget {
  const _EventList({
    required this.events,
    required this.selectedIds,
    required this.expandedId,
    required this.onSelect,
    required this.onExpand,
  });

  final List<LaunchpadEventLogEntryDraft> events;
  final Set<String> selectedIds;
  final String? expandedId;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onExpand;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: LaunchpadEventLogPage.eventListKey,
      children: [
        for (final event in events) ...[
          _EventLogCard(
            event: event,
            selected: selectedIds.contains(event.id),
            expanded: expandedId == event.id,
            onSelect: () => onSelect(event.id),
            onExpand: () => onExpand(event.id),
          ),
          if (event != events.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _EventLogCard extends StatelessWidget {
  const _EventLogCard({
    required this.event,
    required this.selected,
    required this.expanded,
    required this.onSelect,
    required this.onExpand,
  });

  final LaunchpadEventLogEntryDraft event;
  final bool selected;
  final bool expanded;
  final VoidCallback onSelect;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final color = event.level.color;
    return VitCard(
      key: LaunchpadEventLogPage.eventKey(event.id),
      borderColor: selected
          ? color.withValues(alpha: .44)
          : AppColors.cardBorder,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: LaunchpadSpacingTokens.launchpadPaddingX3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SelectBox(
                  key: LaunchpadEventLogPage.eventSelectKey(event.id),
                  selected: selected,
                  color: color,
                  onTap: onSelect,
                ),
                const SizedBox(width: AppSpacing.x3),
                VitAccentIconBox(
                  icon: event.level.icon,
                  color: event.level.color,
                  boxSize: LaunchpadSpacingTokens.launchpadBox30,
                  iconSize: LaunchpadSpacingTokens.launchpadIconXl,
                  bordered: false,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _LevelBadge(level: event.level),
                          const SizedBox(width: AppSpacing.x2),
                          Expanded(
                            child: Text(
                              event.source,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                          Text(
                            event.timestamp,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        event.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.extraBold,
                          height:
                              LaunchpadSpacingTokens.launchpadLineHeightLabel,
                        ),
                      ),
                      if (event.tags.isNotEmpty) ...[
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Wrap(
                          spacing: AppSpacing.x1,
                          runSpacing: AppSpacing.x1,
                          children: [
                            for (final tag in event.tags) _TagPill(label: tag),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                VitIconButton(
                  key: LaunchpadEventLogPage.eventExpandKey(event.id),
                  onPressed: onExpand,
                  icon: expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  tooltip: expanded ? 'Thu gon event' : 'Mo chi tiet event',
                  variant: VitIconButtonVariant.transparent,
                  size: VitIconButtonSize.sm,
                ),
              ],
            ),
          ),
          if (expanded) _EventDetails(event: event),
        ],
      ),
    );
  }
}

class _EventDetails extends StatelessWidget {
  const _EventDetails({required this.event});

  final LaunchpadEventLogEntryDraft event;

  @override
  Widget build(BuildContext context) {
    final rows = [
      if (event.details != null) ('Chi tiet', event.details!),
      if (event.txHash != null) ('TxHash', event.txHash!),
      if (event.chain != null) ('Chain', event.chain!),
      if (event.contractAddress != null) ('Contract', event.contractAddress!),
      if (event.gasUsed != null) ('Gas used', event.gasUsed!),
      if (event.blockNumber != null)
        ('Block', '#${event.blockNumber!.toString()}'),
    ];
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          shape: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Padding(
          padding: LaunchpadSpacingTokens.launchpadPaddingX3,
          child: Column(
            children: [
              for (final row in rows)
                VitKeyValueRow(
                  label: row.$1,
                  value: row.$2,
                  labelWidth: LaunchpadSpacingTokens.launchpadBox76,
                  padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
                  labelStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                  valueStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                    height: LaunchpadSpacingTokens.launchpadLineHeightCompact,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
