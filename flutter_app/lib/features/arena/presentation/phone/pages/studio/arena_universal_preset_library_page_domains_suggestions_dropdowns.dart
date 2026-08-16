part of 'arena_universal_preset_library_page.dart';

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.sections,
    required this.activeId,
    required this.onChanged,
  });

  final List<ArenaPresetSectionDraft> sections;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: ArenaUniversalPresetLibraryPage.sectionTabsKey,
      color: AppColors.bg,
      shape: const Border(bottom: BorderSide(color: AppColors.borderSolid)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: ArenaSpacingTokens.arenaPresetSectionTabsPadding,
        child: Row(
          children: [
            for (final section in sections) ...[
              _SectionChip(
                section: section,
                active: activeId == section.id,
                onTap: () => onChanged(section.id),
              ),
              const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  const _SectionChip({
    required this.section,
    required this.active,
    required this.onTap,
  });

  final ArenaPresetSectionDraft section;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaUniversalPresetLibraryPage.sectionKey(section.id),
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.large,
      padding: ArenaSpacingTokens.arenaPresetSectionChipPadding,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _sectionIcon(section.id),
            color: active ? AppColors.warn : AppColors.text3,
            size: ArenaSpacingTokens.arenaPresetSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            section.label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.warn : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DomainPacksSection extends StatelessWidget {
  const _DomainPacksSection({
    required this.packs,
    required this.expandedId,
    required this.onToggle,
  });

  final List<ArenaDomainPackDraft> packs;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Domain Packs',
          subtitle: '10 lĩnh vực bao phủ mọi loại challenge',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final pack in packs) ...[
          _DomainPackCard(
            pack: pack,
            expanded: expandedId == pack.id,
            onTap: () => onToggle(pack.id),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _DomainPackCard extends StatelessWidget {
  const _DomainPackCard({
    required this.pack,
    required this.expanded,
    required this.onTap,
  });

  final ArenaDomainPackDraft pack;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaUniversalPresetLibraryPage.domainKey(pack.id),
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: ArenaSpacingTokens.arenaPaddingX4,
            child: Row(
              children: [
                _DomainIcon(id: pack.id),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pack.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const Padding(
                        padding: ArenaSpacingTokens.arenaTopPaddingX1,
                      ),
                      Text(
                        pack.description,
                        maxLines: expanded ? 3 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: _presetCaptionLineRatio,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: ArenaSpacingTokens.arenaPresetDomainIcon,
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: ArenaSpacingTokens.arenaPresetDomainExpandedPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: AppColors.borderSolid,
                    height: _presetDividerExtent,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    'CHALLENGE TYPES HỖ TRỢ',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final type in pack.supportedTypes)
                        _SmallPill(label: type, accentColor: _arenaAccent),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    'GỢI Ý MẪU',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  for (final example in pack.examples)
                    Padding(
                      padding: ArenaSpacingTokens.arenaBottomPaddingX2,
                      child: _ExampleRow(text: example),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection({
    required this.packs,
    required this.suggestionsByDomain,
    required this.activeDomainId,
    required this.selectedSuggestion,
    required this.onDomainChanged,
    required this.onSuggestionSelected,
  });

  final List<ArenaDomainPackDraft> packs;
  final Map<String, List<ArenaPresetSuggestionDraft>> suggestionsByDomain;
  final String activeDomainId;
  final String? selectedSuggestion;
  final ValueChanged<String> onDomainChanged;
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    final activePack = packs.firstWhere(
      (pack) => pack.id == activeDomainId,
      orElse: () => packs.first,
    );
    final suggestions =
        suggestionsByDomain[activeDomainId] ??
        suggestionsByDomain['sports'] ??
        const <ArenaPresetSuggestionDraft>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Suggestion Library',
          subtitle: '6-8 gợi ý cho mỗi lĩnh vực',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final pack in packs.take(6)) ...[
                VitFilterChip(
                  label: pack.title,
                  active: pack.id == activeDomainId,
                  onTap: () => onDomainChanged(pack.id),
                  color: AppColors.warn,
                  padding: ArenaSpacingTokens.arenaPresetChipPadding,
                  leading: Icon(
                    _domainIcon(pack.id),
                    color: pack.id == activeDomainId
                        ? AppColors.warn
                        : AppColors.text3,
                    size: ArenaSpacingTokens.arenaPresetSmallIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          padding: ArenaSpacingTokens.arenaPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MiniHeader(
                icon: Icons.auto_awesome_rounded,
                label: 'Gợi ý — ${activePack.title}',
                count: suggestions.length,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final item in suggestions)
                    _SuggestionChip(
                      item: item,
                      selected: selectedSuggestion == item.text,
                      onTap: () => onSuggestionSelected(item.text),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          padding: ArenaSpacingTokens.arenaPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MiniHeader(
                icon: Icons.search_rounded,
                label: 'SmartAutocompleteList',
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const _SearchBox(text: 'Gõ để tìm gợi ý...'),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              for (final item in suggestions.take(3))
                _AutocompleteRow(
                  item: item,
                  selected: item.text == selectedSuggestion,
                ),
            ],
          ),
        ),
        if (selectedSuggestion != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            key: ArenaUniversalPresetLibraryPage.selectedSuggestionKey,
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn,
            padding: ArenaSpacingTokens.arenaPaddingX3,
            child: Text(
              selectedSuggestion!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DropdownsSection extends StatelessWidget {
  const _DropdownsSection({required this.groups});

  final List<ArenaPresetDropdownGroupDraft> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Dropdown / Autocomplete',
          subtitle: 'Component set có đầy đủ states',
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final group in groups) ...[
          VitCard(
            padding: ArenaSpacingTokens.arenaPaddingX4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.disabled
                      ? 'STATE — DISABLED'
                      : 'SEARCHABLE DROPDOWN — ${group.label.toUpperCase()}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _DropdownPreview(group: group),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _DemoFlowsSection extends StatelessWidget {
  const _DemoFlowsSection({
    required this.flows,
    required this.activeIndex,
    required this.onChanged,
  });

  final List<ArenaPresetDemoFlowDraft> flows;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final activeFlow = flows[activeIndex.clamp(0, flows.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PresetSectionHeader(
          title: 'Example Mappings',
          subtitle: 'Demo mini-flow minh họa end-to-end',
          accentColor: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < flows.length; i++) ...[
                _DemoSelectorChip(
                  flow: flows[i],
                  active: i == activeIndex,
                  onTap: () => onChanged(i),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _DemoFlowCard(flow: activeFlow),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          padding: ArenaSpacingTokens.arenaPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MiniHeader(
                icon: Icons.menu_book_outlined,
                label: 'Tổng quan demo flows',
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              for (var i = 0; i < flows.length; i++)
                _DemoSummaryRow(
                  flow: flows[i],
                  selected: i == activeIndex,
                  onTap: () => onChanged(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
