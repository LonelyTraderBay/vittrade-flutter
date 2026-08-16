part of '../../phone/pages/hub/regulatory_reports_dashboard_page.dart';

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.ranges,
    required this.activeId,
    required this.onChanged,
  });

  final List<String> ranges;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          VitStatusPill(
            key: RegulatoryReportsDashboardPage.rangeKey(range),
            label: range,
            status: activeId == range
                ? VitStatusPillStatus.info
                : VitStatusPillStatus.neutral,
            size: VitStatusPillSize.lg,
            onTap: () => onChanged(range),
          ),
          if (range != ranges.last)
            const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
        ],
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onQueue, required this.onArmStatus});

  final VoidCallback onQueue;
  final VoidCallback onArmStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            key: RegulatoryReportsDashboardPage.actionKey('queue'),
            label: 'Live Queue',
            icon: Icons.waves_rounded,
            color: _dashPrimary,
            onTap: onQueue,
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
        Expanded(
          child: _QuickAction(
            key: RegulatoryReportsDashboardPage.actionKey('arm-status'),
            label: 'ARM Status',
            icon: Icons.shield_outlined,
            color: _dashGreen,
            onTap: onArmStatus,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      borderColor: _dashBorder,
      constraints: BoxConstraints(minHeight: VitDensity.tool.controlHeight),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: TradeSpacingTokens.tradeBotMediumIcon),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: TradeSpacingTokens.tradeBotMediumIcon,
          ),
        ],
      ),
    );
  }
}
