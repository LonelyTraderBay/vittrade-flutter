part of '../../phone/pages/tools/advanced_analytics_page.dart';

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('ai', 'AI Signals', Icons.psychology_rounded),
    ('risk', 'Risk Analysis', Icons.shield_outlined),
    ('journal', 'Trade Journal', Icons.menu_book_rounded),
    ('sizing', 'Position Sizing', Icons.calculate_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            icon: tab.$3,
            widgetKey: AdvancedAnalyticsPage.tabKey(tab.$1),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _advancedBorder.withValues(alpha: .7),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.iconSize = TradeSpacingTokens.tradeBotDisputeDropdownIcon,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppSpacing.x4,
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(icon, color: color, size: iconSize),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.ctaLoadingIcon),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.alignLeft = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    return VitMetricBox(
      label: label,
      value: value,
      valueColor: valueColor,
      alignLeft: alignLeft,
      radius: VitCardRadius.tight,
    );
  }
}

String _formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
