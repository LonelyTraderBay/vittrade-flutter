import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

/// Tablet-width sibling of [VitBottomNav]: the same five destinations and
/// the same [VitBottomNavDestinationVisuals] icon/label source, rendered as
/// a persistent left-side rail instead of a floating bottom capsule.
/// `TabletAppShell`/`WebAppShell` host this rail while `PhoneAppShell` hosts
/// the bottom nav — the navigation model (`activeDestination`,
/// `onDestinationSelected`) is identical.
class VitNavigationRail extends StatelessWidget {
  const VitNavigationRail({
    super.key,
    this.activeDestination = VitBottomNavDestination.home,
    this.onDestinationSelected,
    this.homeNotificationBadgeCount,
  });

  static const double width = 96;

  final VitBottomNavDestination activeDestination;
  final ValueChanged<VitBottomNavDestination>? onDestinationSelected;
  final int? homeNotificationBadgeCount;

  @override
  Widget build(BuildContext context) {
    // No internal SafeArea — matches VitBottomNav's own pattern of leaving
    // safe-area handling to the caller (the per-surface app shell), since
    // the correct inset side (left vs bottom) depends on which chrome is
    // active.
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.x5),
            for (final destination in VitBottomNavDestination.values)
              _VitNavigationRailItem(
                destination: destination,
                active: destination == activeDestination,
                badgeCount: destination == VitBottomNavDestination.home
                    ? (homeNotificationBadgeCount ?? 0)
                    : 0,
                onTap: () => onDestinationSelected?.call(destination),
              ),
          ],
        ),
      ),
    );
  }
}

class _VitNavigationRailItem extends StatelessWidget {
  const _VitNavigationRailItem({
    required this.destination,
    required this.active,
    required this.badgeCount,
    required this.onTap,
  });

  final VitBottomNavDestination destination;
  final bool active;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.navActive : AppColors.navInactive;
    final semanticLabel = badgeCount > 0
        ? '${destination.navLabel}, $badgeCount unread notifications'
        : destination.navLabel;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.x4),
      child: Semantics(
        key: Key('vit_navigation_rail_${destination.name}'),
        button: true,
        selected: active,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: active
                  ? AppColors.primary.withValues(alpha: .12)
                  : AppColors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            child: SizedBox(
              width: VitNavigationRail.width - AppSpacing.x4,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: AppSpacing.x3,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Badge(
                      isLabelVisible: badgeCount > 0,
                      label: Text(badgeCount > 99 ? '99+' : '$badgeCount'),
                      backgroundColor: AppColors.sell,
                      child: Icon(
                        key: active
                            ? Key(
                                'vit_navigation_rail_active_${destination.name}',
                              )
                            : null,
                        destination.navIcon,
                        color: color,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      destination.navLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: active
                            ? AppTextStyles.medium
                            : AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
