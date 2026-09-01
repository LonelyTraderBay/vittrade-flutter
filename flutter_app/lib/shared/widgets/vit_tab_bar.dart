import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

TextStyle _vitTabBarLabelStyle({required bool active}) {
  return AppTextStyles.control.copyWith(
    color: active ? AppColors.primary : AppColors.text2,
    fontWeight: active ? AppTextStyles.medium : AppTextStyles.normal,
  );
}

/// Visual shape of a [VitTabBar]: wrapping pills, fill-width segments, or
/// an underlined tab row.
enum VitTabBarVariant { pill, segment, underline }

/// One tab entry (key/label/icon) rendered by [VitTabBar].
class VitTabItem {
  const VitTabItem({
    required this.key,
    required this.label,
    this.icon,
    this.widgetKey,
  });

  final String key;
  final String label;
  final IconData? icon;
  final Key? widgetKey;
}

/// Shared tab switcher rendering [tabs] as pill/segment/underline tabs per
/// [VitTabBarVariant].
class VitTabBar extends StatelessWidget {
  const VitTabBar({
    super.key,
    required this.tabs,
    required this.activeKey,
    required this.onChanged,
    this.variant = VitTabBarVariant.pill,
  });

  final List<VitTabItem> tabs;
  final String activeKey;
  final ValueChanged<String> onChanged;
  final VitTabBarVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == VitTabBarVariant.underline) {
      return Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _UnderlineTab(
                tab: tab,
                active: tab.key == activeKey,
                onChanged: onChanged,
              ),
            ),
        ],
      );
    }

    if (variant == VitTabBarVariant.segment) {
      return Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) SizedBox(width: AppSurfaceSpacing.x1),
            _PillTab(
              tab: tabs[i],
              active: tabs[i].key == activeKey,
              onChanged: onChanged,
              fillParent: true,
              segmentStyle: true,
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSurfaceSpacing.rowGapRegular,
                vertical: AppSurfaceSpacing.tabBarPillVertical,
              ),
            ),
          ],
        ],
      );
    }

    return Wrap(
      spacing: AppSurfaceSpacing.x3,
      runSpacing: AppSurfaceSpacing.x3,
      children: [
        for (final tab in tabs)
          _PillTab(
            tab: tab,
            active: tab.key == activeKey,
            onChanged: onChanged,
            fillParent: false,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSurfaceSpacing.rowGapRegular,
              vertical: AppSurfaceSpacing.tabBarPillVertical,
            ),
          ),
      ],
    );
  }
}

class _PillTab extends StatelessWidget {
  const _PillTab({
    required this.tab,
    required this.active,
    required this.onChanged,
    required this.fillParent,
    required this.padding,
    this.segmentStyle = false,
  });

  final VitTabItem tab;
  final bool active;
  final ValueChanged<String> onChanged;
  final bool fillParent;
  final EdgeInsetsGeometry padding;
  final bool segmentStyle;

  @override
  Widget build(BuildContext context) {
    final fill = active
        ? AppColors.primary12
        : segmentStyle
        ? AppColors.transparent
        : AppColors.surface2;
    final border = active
        ? AppColors.primary20
        : segmentStyle
        ? AppColors.portfolioBtnGhostBorder
        : AppColors.cardBorder;

    final content = DecoratedBox(
      decoration: ShapeDecoration(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: border),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: fillParent ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                color: active ? AppColors.primary : AppColors.text2,
                size: AppSurfaceSpacing.iconSm,
              ),
              SizedBox(width: AppSurfaceSpacing.x2),
            ],
            if (fillParent)
              Flexible(
                child: _PillTabLabel(tab: tab, active: active),
              )
            else
              _PillTabLabel(tab: tab, active: active),
          ],
        ),
      ),
    );

    final button = Material(
      key: tab.widgetKey,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onChanged(tab.key),
        borderRadius: AppRadii.inputRadius,
        child: content,
      ),
    );

    if (!fillParent) return button;
    return Expanded(child: button);
  }
}

class _PillTabLabel extends StatelessWidget {
  const _PillTabLabel({required this.tab, required this.active});

  final VitTabItem tab;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      tab.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _vitTabBarLabelStyle(active: active),
    );
  }
}

class _UnderlineTab extends StatelessWidget {
  const _UnderlineTab({
    required this.tab,
    required this.active,
    required this.onChanged,
  });

  final VitTabItem tab;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: tab.widgetKey,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onChanged(tab.key),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                vertical: AppSurfaceSpacing.x2,
              ),
              child: Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: _vitTabBarLabelStyle(active: active),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              child: SizedBox(
                height: AppSurfaceSpacing.tabBarUnderlineHeight,
                width: active ? AppSurfaceSpacing.tabBarUnderlineWidth : 0,
                child: const DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.primary,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
