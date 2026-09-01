import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// The five top-level destinations reachable from [VitBottomNav].
enum VitBottomNavDestination { home, markets, trade, wallet, profile }

/// Maps a [VitBottomNavDestination] to its top-level route path.
extension VitBottomNavDestinationRoute on VitBottomNavDestination {
  String get routePath {
    switch (this) {
      case VitBottomNavDestination.home:
        return '/home';
      case VitBottomNavDestination.markets:
        return '/markets';
      case VitBottomNavDestination.trade:
        return '/trade';
      case VitBottomNavDestination.wallet:
        return '/wallet';
      case VitBottomNavDestination.profile:
        return '/profile';
    }
  }
}

/// Shared icon/label pairing for a [VitBottomNavDestination] — the single
/// source of truth both [VitBottomNav] (bottom capsule) and
/// `VitNavigationRail` (tablet side rail) render from, so the two nav chrome
/// variants can never drift apart on icon/label.
extension VitBottomNavDestinationVisuals on VitBottomNavDestination {
  IconData get navIcon {
    switch (this) {
      case VitBottomNavDestination.home:
        return Icons.home_rounded;
      case VitBottomNavDestination.markets:
        return Icons.bar_chart_rounded;
      case VitBottomNavDestination.trade:
        return Icons.swap_horiz_rounded;
      case VitBottomNavDestination.wallet:
        return Icons.account_balance_wallet_rounded;
      case VitBottomNavDestination.profile:
        return Icons.person_rounded;
    }
  }

  String get navLabel {
    switch (this) {
      case VitBottomNavDestination.home:
        return 'Trang chủ';
      case VitBottomNavDestination.markets:
        return 'Thị trường';
      case VitBottomNavDestination.trade:
        return 'Giao dịch';
      case VitBottomNavDestination.wallet:
        return 'Ví';
      case VitBottomNavDestination.profile:
        return 'Tôi';
    }
  }
}

/// The app's bottom navigation capsule: five tappable destinations with a
/// raised center Trade button, active-state dot, and unread badge.
class VitBottomNav extends StatelessWidget {
  const VitBottomNav({
    super.key,
    this.activeDestination = VitBottomNavDestination.home,
    this.onDestinationSelected,
    this.homeNotificationBadgeCount,
    this.homeBadgeCount = 0,
    this.renderMode = ShellRenderMode.native,
  });

  final VitBottomNavDestination activeDestination;
  final ValueChanged<VitBottomNavDestination>? onDestinationSelected;
  final int? homeNotificationBadgeCount;
  final int homeBadgeCount;
  final ShellRenderMode renderMode;

  static List<_VitBottomNavItem> get _items => [
    for (final destination in VitBottomNavDestination.values)
      _VitBottomNavItem(
        destination: destination,
        icon: destination.navIcon,
        label: destination.navLabel,
        isCenter: destination == VitBottomNavDestination.trade,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final height = renderMode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final capsuleHeight = renderMode.usesVisualQaFrame
        ? AppSurfaceSpacing.bottomNavCapsuleHeightVisual
        : AppSurfaceSpacing.bottomNavCapsuleHeightNative;
    final bottomGap = renderMode.usesVisualQaFrame
        ? AppSurfaceSpacing.bottomNavBottomGapVisual
        : AppSurfaceSpacing.bottomNavBottomGapNative;

    return SizedBox(
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: AppSurfaceSpacing.bottomNavHorizontalInset,
              right: AppSurfaceSpacing.bottomNavHorizontalInset,
              bottom: bottomGap,
              height: capsuleHeight,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surface2.withValues(alpha: .98),
                      AppColors.bg.withValues(alpha: .96),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.pillRadius,
                    side: BorderSide(
                      color: AppColors.borderSolid.withValues(alpha: .46),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: AppColors.bg.withValues(alpha: .45),
                      blurRadius: AppSurfaceSpacing.bottomNavSurfaceShadowBlur,
                      offset: Offset(
                        0,
                        AppSurfaceSpacing.bottomNavSurfaceShadowOffsetY,
                      ),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .12),
                      blurRadius: AppSurfaceSpacing.bottomNavPrimaryShadowBlur,
                      offset: Offset(
                        0,
                        AppSurfaceSpacing.bottomNavPrimaryShadowOffsetY,
                      ),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final horizontalPad = constraints.maxWidth < 340
                        ? AppSurfaceSpacing.bottomNavHorizontalPadCompact
                        : AppSurfaceSpacing.bottomNavHorizontalPad;
                    return Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: horizontalPad,
                      ),
                      child: Row(
                        children: [
                          for (final item in _items)
                            Expanded(
                              child: _VitBottomNavButton(
                                item: item,
                                active: item.destination == activeDestination,
                                renderMode: renderMode,
                                badgeCount:
                                    item.destination ==
                                        VitBottomNavDestination.home
                                    ? homeNotificationBadgeCount ??
                                          homeBadgeCount
                                    : 0,
                                onTap: () => onDestinationSelected?.call(
                                  item.destination,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitBottomNavItem {
  const _VitBottomNavItem({
    required this.destination,
    required this.icon,
    required this.label,
    this.isCenter = false,
  });

  final VitBottomNavDestination destination;
  final IconData icon;
  final String label;
  final bool isCenter;
}

class _VitBottomNavButton extends StatelessWidget {
  const _VitBottomNavButton({
    required this.item,
    required this.active,
    required this.onTap,
    required this.renderMode,
    this.badgeCount = 0,
  });

  final _VitBottomNavItem item;
  final bool active;
  final VoidCallback? onTap;
  final ShellRenderMode renderMode;
  final int badgeCount;

  static final double _nativeCenterButtonTop =
      AppSurfaceSpacing.bottomNavCenterButtonTopNative;
  static final double _visualQaCenterButtonTop =
      AppSurfaceSpacing.bottomNavCenterButtonTopVisual;

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.navActive;
    const activeShadow = AppColors.primary;
    final semanticLabel =
        item.destination == VitBottomNavDestination.home && badgeCount > 0
        ? '${item.label}, $badgeCount thông báo chưa đọc'
        : item.label;

    if (item.isCenter) {
      return Semantics(
        key: Key('vit_bottom_nav_${item.destination.name}'),
        button: true,
        selected: active,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: SizedBox(
            width: double.infinity,
            height: DeviceMetrics.tabBar,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: renderMode.usesVisualQaFrame
                      ? _visualQaCenterButtonTop
                      : _nativeCenterButtonTop,
                  child: SizedBox(
                    key: active
                        ? Key('vit_bottom_nav_active_${item.destination.name}')
                        : null,
                    width: renderMode.usesVisualQaFrame
                        ? AppSurfaceSpacing.bottomNavCenterButtonSizeVisual
                        : AppSurfaceSpacing.bottomNavCenterButtonSizeNative,
                    height: renderMode.usesVisualQaFrame
                        ? AppSurfaceSpacing.bottomNavCenterButtonSizeVisual
                        : AppSurfaceSpacing.bottomNavCenterButtonSizeNative,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        gradient: AppGradients.navCenter,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.lgRadius,
                          side: BorderSide(
                            color: AppColors.primarySoft.withValues(alpha: .20),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: activeShadow.withValues(alpha: .40),
                            blurRadius:
                                AppSurfaceSpacing.bottomNavCenterGlowBlur,
                            offset: Offset(
                              0,
                              AppSurfaceSpacing.bottomNavCenterGlowOffsetY,
                            ),
                          ),
                          BoxShadow(
                            color: activeShadow.withValues(alpha: .20),
                            blurRadius:
                                AppSurfaceSpacing.bottomNavCenterGlowWeakBlur,
                          ),
                        ],
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.navCenterIcon,
                        size: AppSurfaceSpacing.bottomNavCenterIconSize,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: renderMode.usesVisualQaFrame
                      ? AppSurfaceSpacing.bottomNavBottomOffsetCompact
                      : AppSurfaceSpacing.bottomNavBottomOffsetRegular,
                  child: Text(
                    key: item.destination == VitBottomNavDestination.trade
                        ? const Key('vit_bottom_nav_trade_label')
                        : null,
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: activeColor,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Semantics(
      key: Key('vit_bottom_nav_${item.destination.name}'),
      button: true,
      selected: active,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: SizedBox(
          width: double.infinity,
          height: AppSurfaceSpacing.bottomNavItemHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: active ? activeColor : AppColors.navInactive,
                    size: AppSurfaceSpacing.iconMd,
                  ),
                  if (active)
                    Positioned(
                      bottom: AppSurfaceSpacing.bottomNavActiveDotOffset,
                      child: SizedBox.square(
                        key: Key(
                          'vit_bottom_nav_active_${item.destination.name}',
                        ),
                        dimension: AppSurfaceSpacing.bottomNavActiveDotSize,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: activeColor,
                            shape: const CircleBorder(),
                            shadows: [
                              BoxShadow(
                                color: activeShadow.withValues(alpha: .60),
                                blurRadius:
                                    AppSurfaceSpacing.bottomNavActiveDotBlur,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (badgeCount > 0)
                    Positioned(
                      top: AppSurfaceSpacing.bottomNavBadgeTopOffset,
                      right: AppSurfaceSpacing.bottomNavBadgeRightOffset,
                      child: _NavBadge(count: badgeCount),
                    ),
                ],
              ),
              SizedBox(height: AppSurfaceSpacing.bottomNavLabelGap),
              Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: active ? activeColor : AppColors.navInactive,
                  fontWeight: active
                      ? AppTextStyles.medium
                      : AppTextStyles.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  const _NavBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: AppSurfaceSpacing.bottomNavBadgeMinWidth,
        minHeight: AppSurfaceSpacing.bottomNavBadgeHeight,
      ),
      child: SizedBox(
        height: AppSurfaceSpacing.bottomNavBadgeHeight,
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.sell,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.pillRadius),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSurfaceSpacing.bottomNavBadgeHorizontalPadding,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : '$count',
                style: AppTextStyles.navLabel.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
