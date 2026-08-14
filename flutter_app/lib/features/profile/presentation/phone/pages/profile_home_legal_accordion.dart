part of 'profile_page.dart';

/// STEP-P1.4 — searchable accordion for 39 GOM legal routes.
class _LegalAccordionSection extends StatefulWidget {
  const _LegalAccordionSection();

  @override
  State<_LegalAccordionSection> createState() => _LegalAccordionSectionState();
}

class _LegalAccordionSectionState extends State<_LegalAccordionSection> {
  final _searchController = TextEditingController();
  final Set<String> _expandedGroupIds = {'copy'};
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProfileLegalGroup> get _filteredGroups {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return ProfileLegalCatalog.groups;
    return [
      for (final group in ProfileLegalCatalog.groups)
        if (group.label.toLowerCase().contains(q) ||
            group.items.any((item) => item.label.toLowerCase().contains(q)))
          ProfileLegalGroup(
            id: group.id,
            label: group.label,
            items: [
              for (final item in group.items)
                if (group.label.toLowerCase().contains(q) ||
                    item.label.toLowerCase().contains(q))
                  item,
            ],
          ),
    ];
  }

  void _toggleGroup(String id) {
    setState(() {
      if (_expandedGroupIds.contains(id)) {
        _expandedGroupIds.remove(id);
      } else {
        _expandedGroupIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filteredGroups;
    final totalVisible = groups.fold<int>(
      0,
      (sum, group) => sum + group.items.length,
    );

    return VitCard(
      key: ProfilePage.legalScaffoldKey,
      borderColor: _profileBorder,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: ProfileSpacingTokens.profileMenuRowPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tài liệu tuân thủ & báo cáo',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  '$totalVisible / ${ProfileLegalCatalog.itemCount} mục',
                  style: AppTextStyles.micro.copyWith(color: _profileMuted),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitSearchBar(
                  key: ProfilePage.legalSearchKey,
                  controller: _searchController,
                  placeholder: 'Tìm tài liệu pháp lý…',
                  variant: VitSearchBarVariant.compact,
                  onChanged: (value) => setState(() => _query = value),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
              ],
            ),
          ),
          if (groups.isEmpty)
            Padding(
              padding: ProfileSpacingTokens.profileMenuRowPadding,
              child: Text(
                'Không có mục khớp «$_query».',
                style: AppTextStyles.micro.copyWith(color: _profileMuted),
              ),
            )
          else
            for (final group in groups) ...[
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
              _LegalGroupTile(
                group: group,
                expanded:
                    _expandedGroupIds.contains(group.id) || _query.isNotEmpty,
                onToggle: () => _toggleGroup(group.id),
              ),
            ],
        ],
      ),
    );
  }
}

class _LegalGroupTile extends StatelessWidget {
  const _LegalGroupTile({
    required this.group,
    required this.expanded,
    required this.onToggle,
  });

  final ProfileLegalGroup group;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.transparent,
          child: InkWell(
            key: ProfilePage.legalGroupKey(group.id),
            onTap: onToggle,
            child: VitIconListRow(
              minHeight: VitDensity.compact.controlHeight,
              padding: ProfileSpacingTokens.profileMenuRowPadding,
              gap: ProfileSpacingTokens.profileMenuGap,
              leading: SizedBox(
                width: ProfileSpacingTokens.profileMenuIconBox,
                height: ProfileSpacingTokens.profileMenuIconBox,
                child: Material(
                  color: _profileMuted.withValues(alpha: .12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: const Icon(
                    Icons.folder_outlined,
                    color: _profileMuted,
                    size: ProfileSpacingTokens.profileMenuIcon,
                  ),
                ),
              ),
              title: Text(
                group.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              subtitle: Text(
                '${group.items.length} tài liệu',
                style: AppTextStyles.micro.copyWith(color: _profileMuted),
              ),
              trailing: Icon(
                expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: _profileMuted,
                size: ProfileSpacingTokens.profileMenuChevron,
              ),
            ),
          ),
        ),
        if (expanded)
          for (final item in group.items) _LegalItemRow(item: item),
      ],
    );
  }
}

class _LegalItemRow extends StatelessWidget {
  const _LegalItemRow({required this.item});

  final ProfileLegalItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: ProfilePage.legalItemKey(item.id),
        onTap: () => context.push(item.route),
        child: VitIconListRow(
          minHeight: VitDensity.compact.controlHeight,
          padding: const EdgeInsetsDirectional.only(
            start:
                ProfileSpacingTokens.profileMenuIconBox +
                ProfileSpacingTokens.profileMenuGap +
                AppSpacing.x4,
            end: AppSpacing.x4,
            top: AppSpacing.x2,
            bottom: AppSpacing.x2,
          ),
          gap: ProfileSpacingTokens.profileMenuGap,
          leading: const Icon(
            Icons.description_outlined,
            color: _profileMuted,
            size: ProfileSpacingTokens.profileMenuIcon,
          ),
          title: Text(
            item.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: _profileMuted,
            size: ProfileSpacingTokens.profileMenuChevron,
          ),
        ),
      ),
    );
  }
}
