part of '../../phone/pages/staking/staking_earn_page.dart';

class _EarnCtaRow extends StatelessWidget {
  const _EarnCtaRow({required this.savingsRoute, required this.dashboardRoute});

  final String savingsRoute;
  final String dashboardRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: StakingEarnPage.dashboardButtonKey,
            onPressed: () => context.go(dashboardRoute),
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.inputHeight,
            leading: const Icon(Icons.dashboard_outlined),
            child: const Text('Bảng điều khiển'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: StakingEarnPage.savingsButtonKey,
            onPressed: () => context.go(savingsRoute),
            height: AppSpacing.inputHeight,
            leading: const Icon(Icons.savings_outlined),
            child: const Text('Tiết kiệm'),
          ),
        ),
      ],
    );
  }
}

class _StakingToolsSection extends StatelessWidget {
  const _StakingToolsSection({required this.tools, required this.onNavigate});

  final List<EarnHubTool> tools;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarnPage.toolsSectionKey,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Công cụ staking',
            subtitle: 'Theo dõi lãi, lịch sử và thông tin hỗ trợ staking.',
            icon: Icons.hub_outlined,
            iconColor: AppModuleAccents.earn,
            accentColor: AppModuleAccents.earn,
            density: VitDensity.compact,
            bottomGap: AppSpacing.pageRhythmCompactInnerGap,
          ),
          VitActionTileGrid(
            density: VitDensity.compact,
            itemCount: tools.length,
            itemBuilder: (context, index, density) {
              final tool = tools[index];
              return VitServiceTile(
                key: StakingEarnPage.toolKey(tool.id),
                density: density,
                icon: switch (tool.iconKey) {
                  'analytics' => Icons.analytics_outlined,
                  'calendar' => Icons.calendar_month_outlined,
                  'history' => Icons.history_rounded,
                  'guide' => Icons.menu_book_outlined,
                  'faq' => Icons.help_outline_rounded,
                  'recommendations' => Icons.tips_and_updates_outlined,
                  'notifications' => Icons.notifications_active_outlined,
                  'staking' => Icons.account_balance_wallet_outlined,
                  _ => Icons.hub_outlined,
                },
                label: tool.label,
                accentColor: AppModuleAccents.earn,
                onTap: () => onNavigate(tool.route),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EarnLegalEntry extends StatelessWidget {
  const _EarnLegalEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarnPage.legalEntryKey,
      onTap: onTap,
      padding: AppSpacing.cardPaddingCompact,
      child: VitIconListRow(
        leading: const VitAccentIconBox(
          icon: Icons.policy_outlined,
          color: AppModuleAccents.earn,
        ),
        title: Text(
          'Tài liệu & rủi ro',
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
        subtitle: Text(
          '${EarnLegalCatalog.itemCount} tài liệu theo 5 cụm',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _EarnLegalSheet extends StatefulWidget {
  const _EarnLegalSheet({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  State<_EarnLegalSheet> createState() => _EarnLegalSheetState();
}

class _EarnLegalSheetState extends State<_EarnLegalSheet> {
  final Set<String> _expandedGroupIds = {EarnLegalCatalog.groups.first.id};

  void _toggleGroup(String id) {
    setState(() {
      if (!_expandedGroupIds.add(id)) {
        _expandedGroupIds.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: StakingEarnPage.legalSheetKey,
      title: 'Tài liệu & rủi ro',
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            '${EarnLegalCatalog.itemCount} tài liệu staking theo 5 cụm.',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final group in EarnLegalCatalog.groups) ...[
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            _EarnLegalGroupTile(
              group: group,
              expanded: _expandedGroupIds.contains(group.id),
              onToggle: () => _toggleGroup(group.id),
              onNavigate: widget.onNavigate,
            ),
          ],
        ],
      ),
    );
  }
}

class _EarnLegalGroupTile extends StatelessWidget {
  const _EarnLegalGroupTile({
    required this.group,
    required this.expanded,
    required this.onToggle,
    required this.onNavigate,
  });

  final EarnLegalGroup group;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.transparent,
          child: InkWell(
            key: StakingEarnPage.legalGroupKey(group.id),
            onTap: onToggle,
            child: VitIconListRow(
              minHeight: VitDensity.compact.controlHeight,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x2,
              ),
              leading: const VitAccentIconBox(
                icon: Icons.folder_outlined,
                color: AppModuleAccents.earn,
                muted: true,
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
                size: AppSpacing.iconMd,
              ),
            ),
          ),
        ),
        if (expanded)
          for (final item in group.items)
            _EarnLegalItemRow(item: item, onNavigate: onNavigate),
      ],
    );
  }
}

class _EarnLegalItemRow extends StatelessWidget {
  const _EarnLegalItemRow({required this.item, required this.onNavigate});

  final EarnLegalItem item;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: StakingEarnPage.legalItemKey(item.id),
        onTap: () => onNavigate(item.route),
        child: VitIconListRow(
          minHeight: VitDensity.compact.controlHeight,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          leading: const Icon(
            Icons.description_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
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
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}
