import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Sizing density of a [VitDiscoveryActionCard]: `standard` or `compact`.
enum VitDiscoveryActionCardVariant { standard, compact }

/// Tappable discovery entry card: gradient icon tile, title with status
/// badge, subtitle, optional action label, and trailing chevron.
class VitDiscoveryActionCard extends StatelessWidget {
  const VitDiscoveryActionCard({
    super.key,
    required this.title,
    required this.badgeLabel,
    required this.subtitle,
    required this.actionLabel,
    required this.icon,
    required this.accentColor,
    required this.borderColor,
    required this.background,
    required this.onTap,
    this.badgeStatus = VitStatusPillStatus.purple,
    this.variant = VitDiscoveryActionCardVariant.standard,
  });

  final String title;
  final String badgeLabel;
  final String subtitle;
  final String actionLabel;
  final IconData icon;
  final Color accentColor;
  final Color borderColor;
  final Gradient background;
  final VoidCallback onTap;
  final VitStatusPillStatus badgeStatus;
  final VitDiscoveryActionCardVariant variant;

  _DiscoveryCardMetrics get _metrics {
    return switch (variant) {
      VitDiscoveryActionCardVariant.standard => _DiscoveryCardMetrics(
        padding: AppSurfaceSpacing.cardPadding,
        iconContainerSize: SharedSpacingTokens.homeDiscoveryIconContainer,
        iconSize: SharedSpacingTokens.homeDiscoveryIconSize,
        titleStyle: AppTextStyles.body,
        showActionLabel: true,
      ),
      VitDiscoveryActionCardVariant.compact => const _DiscoveryCardMetrics(
        padding: SharedSpacingTokens.homeDiscoveryCompactPadding,
        iconContainerSize:
            SharedSpacingTokens.homeDiscoveryCompactIconContainer,
        iconSize: SharedSpacingTokens.homeDiscoveryCompactIconSize,
        titleStyle: AppTextStyles.caption,
        showActionLabel: true,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    return VitCard(
      onTap: onTap,
      borderColor: borderColor,
      padding: metrics.padding,
      child: Row(
        children: [
          SizedBox(
            width: metrics.iconContainerSize,
            height: metrics.iconContainerSize,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                gradient: background,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Icon(icon, color: accentColor, size: metrics.iconSize),
              ),
            ),
          ),
          const SizedBox(width: SharedSpacingTokens.homeMarketIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSurfaceSpacing.x3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: metrics.titleStyle.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    VitStatusPill(
                      label: badgeLabel,
                      status: badgeStatus,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                SizedBox(height: AppSurfaceSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (metrics.showActionLabel) ...[
                  SizedBox(height: AppSurfaceSpacing.x2),
                  Text(
                    actionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: accentColor,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: accentColor,
            size: SharedSpacingTokens.homeSectionActionChevronSize,
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCardMetrics {
  const _DiscoveryCardMetrics({
    required this.padding,
    required this.iconContainerSize,
    required this.iconSize,
    required this.titleStyle,
    required this.showActionLabel,
  });

  final EdgeInsetsGeometry padding;
  final double iconContainerSize;
  final double iconSize;
  final TextStyle titleStyle;
  final bool showActionLabel;
}
