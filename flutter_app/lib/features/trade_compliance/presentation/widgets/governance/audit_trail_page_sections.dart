part of '../../phone/pages/governance/audit_trail_page.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<TradeAuditStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(child: _StatCard(stat: stat)),
          if (stat != stats.last)
            const SizedBox(width: TradeSpacingTokens.tradeToolPageTopGap),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final TradeAuditStat stat;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: TradeSpacingTokens.tradeToolMetricHeight,
      padding: TradeSpacingTokens.tradeToolMetricPadding,
      radius: VitCardRadius.tight,
      borderColor: _auditBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeToolTinyGap),
          Text(
            stat.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: stat.emphasized ? _auditGreen : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSearchBar(
            fieldKey: AuditTrailPage.searchKey,
            placeholder: placeholder,
            variant: VitSearchBarVariant.compact,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeToolInlineGap),
        VitIconButton(
          icon: Icons.filter_alt_outlined,
          tooltip: 'Filter audit trail',
          onPressed: () => _showComingSoon(
            context,
            'Bộ lọc nhật ký kiểm toán sẽ sớm ra mắt',
          ),
          variant: VitIconButtonVariant.ghost,
          size: VitIconButtonSize.md,
        ),
      ],
    );
  }
}

class _AuditTabs extends StatelessWidget {
  const _AuditTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: AuditTrailPage.tabKey(tab.id),
          ),
      ],
    );
  }
}
