part of '../../phone/pages/tools/launchpad_event_log_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      key: LaunchpadEventLogPage.searchKey,
      controller: controller,
      placeholder: 'Tim kiem event...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
      onClear: onClear,
    );
  }
}

class _LevelFilterBar extends StatelessWidget {
  const _LevelFilterBar({
    required this.events,
    required this.activeValue,
    required this.onChanged,
  });

  final List<LaunchpadEventLogEntryDraft> events;
  final String activeValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = [
      'all',
      ...LaunchpadEventLogLevel.values.map((e) => e.value),
    ];
    return SingleChildScrollView(
      key: LaunchpadEventLogPage.levelsKey,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final value in values) ...[
            Builder(
              builder: (context) {
                final level = value == 'all'
                    ? null
                    : LaunchpadEventLogLevel.values.firstWhere(
                        (item) => item.value == value,
                      );
                final count = value == 'all'
                    ? events.length
                    : events
                          .where((event) => event.level.value == value)
                          .length;
                return VitFilterChip(
                  key: LaunchpadEventLogPage.levelKey(value),
                  label: value == 'all' ? 'Tat ca' : level!.label,
                  count: count,
                  semanticCountSuffix: 'events',
                  active: activeValue == value,
                  color: level?.color ?? AppModuleAccents.launchpad,
                  padding: LaunchpadSpacingTokens.launchpadPillPadding,
                  onTap: () => onChanged(value),
                );
              },
            ),
            if (value != values.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.sourceLabel,
    required this.sourceOpen,
    required this.selectedAll,
    required this.exportCount,
    required this.onToggleSources,
    required this.onToggleSelectAll,
    required this.onExport,
  });

  final String sourceLabel;
  final bool sourceOpen;
  final bool selectedAll;
  final int exportCount;
  final VoidCallback onToggleSources;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: LaunchpadEventLogPage.actionsKey,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallActionButton(
            icon: Icons.filter_alt_outlined,
            label: sourceLabel,
            trailing: sourceOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            onTap: onToggleSources,
          ),
          const SizedBox(width: AppSpacing.x5),
          _SmallActionButton(
            key: LaunchpadEventLogPage.selectAllKey,
            label: selectedAll ? 'Bo chon' : 'Chon tat ca',
            compact: true,
            onTap: onToggleSelectAll,
          ),
          const SizedBox(width: AppSpacing.x2),
          _SmallActionButton(
            key: LaunchpadEventLogPage.exportButtonKey,
            icon: Icons.copy_rounded,
            label: 'Export ($exportCount)',
            active: true,
            onTap: onExport,
          ),
        ],
      ),
    );
  }
}

class _SourceFilterCard extends StatelessWidget {
  const _SourceFilterCard({
    required this.sources,
    required this.activeValue,
    required this.onChanged,
  });

  final List<String> sources;
  final String activeValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadEventLogPage.sourcesKey,
      variant: VitCardVariant.inner,
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loc theo nguon',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final source in sources)
                VitFilterChip(
                  key: LaunchpadEventLogPage.sourceKey(source),
                  label: source == 'all' ? 'Tat ca' : source,
                  active: activeValue == source,
                  color: AppModuleAccents.launchpad,
                  padding: LaunchpadSpacingTokens.launchpadPillPadding,
                  onTap: () => onChanged(source),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
