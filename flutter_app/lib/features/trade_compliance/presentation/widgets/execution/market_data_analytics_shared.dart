part of '../../phone/pages/execution/market_data_analytics_page.dart';

class _MetricBubble extends StatelessWidget {
  const _MetricBubble({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.bg = _analyticsPanel2,
  });

  final String label;
  final String value;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final status = color == _analyticsGreen
        ? VitStatusPillStatus.success
        : color == _analyticsRed
        ? VitStatusPillStatus.error
        : color == _analyticsAmber
        ? VitStatusPillStatus.warning
        : VitStatusPillStatus.info;
    return VitStatusPill(
      label: label,
      status: status,
      size: VitStatusPillSize.sm,
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({
    required this.text,
    this.bg = _analyticsSurface3,
    this.iconColor = _analyticsPrimary,
  });

  final String text;
  final Color bg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: iconColor, size: 14),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleBar extends StatelessWidget {
  const _ToggleBar({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          Expanded(
            child: VitStatusPill(
              label: left,
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.lg,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                right,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PctLabel extends StatelessWidget {
  const _PctLabel({
    required this.label,
    required this.color,
    required this.icon,
    this.iconAfter = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    final children = [
      Icon(icon, color: color, size: 15),
      const SizedBox(width: AppSpacing.x1),
      Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconAfter ? children.reversed.toList() : children,
    );
  }
}

class _RatioBar extends StatelessWidget {
  const _RatioBar({required this.longPct});

  final double longPct;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pillRadius,
      child: LinearProgressIndicator(
        minHeight: AppSpacing.x3,
        value: longPct / 100,
        backgroundColor: _analyticsRed,
        color: _analyticsGreen,
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.badge,
    this.badgeColor = _analyticsGreen,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? trailing;
  final String? badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: AppSpacing.ctaLoadingIcon),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          )
        else if (badge != null)
          _SmallBadge(label: badge!, color: badgeColor),
      ],
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _analyticsBorder.withValues(alpha: .72),
      child: child,
    );
  }
}

String _formatMillions(double value) {
  return '\$${(value / 1000000).toStringAsFixed(2)}M';
}

String _formatCompactUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatMoney(double value) => formatTradeMoney(value);

String _formatInt(int value) => formatTradeInt(value);
