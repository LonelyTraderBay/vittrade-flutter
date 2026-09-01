import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/domain/profile_legal_catalog.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet-dashboard public port of Profile's private
/// `_LegalAccordionSection` (`profile_home_legal_accordion.dart`,
/// phone-only — not importable outside `profile_page.dart`'s `part`
/// family). Same searchable accordion over the 39 GOM legal/compliance
/// routes.
///
/// Collapsed by default (2026-08-27): the whole compliance library renders
/// as ONE menu row until the user opens it — the master menu stays lean
/// while every document stays one tap away. Inside, each group also starts
/// collapsed; searching auto-expands matches as before.
class ProfileLegalAccordionPanel extends StatefulWidget {
  const ProfileLegalAccordionPanel({super.key});

  @override
  State<ProfileLegalAccordionPanel> createState() =>
      _ProfileLegalAccordionPanelState();
}

class _ProfileLegalAccordionPanelState
    extends State<ProfileLegalAccordionPanel> {
  final _searchController = TextEditingController();
  bool _panelOpen = false;
  final Set<String> _expandedGroupIds = {};
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
    if (!_panelOpen) return _buildCollapsedRow();
    return _buildExpandedPanel(context);
  }

  /// The lean default: one framed menu row — same card idiom as the other
  /// menu groups — that expands the whole library on tap.
  Widget _buildCollapsedRow() {
    return VitCard(
      key: ProfileTabletKeys.legalScaffold,
      borderColor: AppColors.cardBorder,
      density: VitDensity.compact,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          key: ProfileTabletKeys.legalToggle,
          onTap: () => setState(() => _panelOpen = true),
          child: VitIconListRow(
            minHeight: VitDensity.standard.controlHeight,
            padding: ProfileSpacingTokens.profileMenuRowPadding,
            gap: TabletSpacingTokens.x3,
            leading: SizedBox(
              width: ProfileSpacingTokens.profileMenuTabletIconBox,
              height: ProfileSpacingTokens.profileMenuTabletIconBox,
              child: Material(
                color: AppColors.text3.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.folder_outlined,
                  color: AppColors.text3,
                  size: ProfileSpacingTokens.profileMenuTabletIcon,
                ),
              ),
            ),
            title: Text(
              'Tài liệu tuân thủ & báo cáo',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            subtitle: Text(
              '${ProfileLegalCatalog.itemCount} tài liệu — mở để xem',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            trailing: const Icon(
              Icons.expand_more_rounded,
              color: AppColors.text3,
              size: ProfileSpacingTokens.profileMenuChevron,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedPanel(BuildContext context) {
    final groups = _filteredGroups;
    final totalVisible = groups.fold<int>(
      0,
      (sum, group) => sum + group.items.length,
    );

    return VitCard(
      key: ProfileTabletKeys.legalScaffold,
      borderColor: AppColors.cardBorder,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: ProfileSpacingTokens.profileMenuRowPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tapping the heading collapses the library back to the
                // single menu row (same toggle as the collapsed state).
                InkWell(
                  key: ProfileTabletKeys.legalToggle,
                  onTap: () => setState(() => _panelOpen = false),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tài liệu tuân thủ & báo cáo',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.expand_less_rounded,
                        color: AppColors.text3,
                        size: ProfileSpacingTokens.profileMenuChevron,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  '$totalVisible / ${ProfileLegalCatalog.itemCount} mục',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                VitSearchBar(
                  key: ProfileTabletKeys.legalSearch,
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
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            )
          else
            for (final group in groups) ...[
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
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
            key: ProfileTabletKeys.legalGroup(group.id),
            onTap: onToggle,
            child: VitIconListRow(
              minHeight: VitDensity.compact.controlHeight,
              padding: ProfileSpacingTokens.profileMenuRowPadding,
              gap: TabletSpacingTokens.x3,
              leading: SizedBox(
                width: ProfileSpacingTokens.profileMenuTabletIconBox,
                height: ProfileSpacingTokens.profileMenuTabletIconBox,
                child: Material(
                  color: AppColors.text3.withValues(alpha: .12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: const Icon(
                    Icons.folder_outlined,
                    color: AppColors.text3,
                    size: ProfileSpacingTokens.profileMenuTabletIcon,
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
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              trailing: Icon(
                expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: AppColors.text3,
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
        key: ProfileTabletKeys.legalItem(item.id),
        onTap: () => context.push(item.route),
        child: VitIconListRow(
          minHeight: VitDensity.compact.controlHeight,
          padding: const EdgeInsetsDirectional.only(
            start:
                ProfileSpacingTokens.profileMenuTabletIconBox +
                TabletSpacingTokens.x3 +
                TabletSpacingTokens.x4,
            end: TabletSpacingTokens.x4,
            top: TabletSpacingTokens.x2,
            bottom: TabletSpacingTokens.x2,
          ),
          gap: TabletSpacingTokens.x3,
          leading: const Icon(
            Icons.description_outlined,
            color: AppColors.text3,
            size: ProfileSpacingTokens.profileMenuTabletIcon,
          ),
          title: Text(
            item.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: ProfileSpacingTokens.profileMenuChevron,
          ),
        ),
      ),
    );
  }
}
