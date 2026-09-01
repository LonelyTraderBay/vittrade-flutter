import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

/// Chrome that a page's top-of-content tab/section switcher is wrapped in.
///
/// Two shapes are covered, both extracted from repeated local
/// `_SectionTabs` / `_TopTabs` widgets:
/// - [VitScrollableTabHeader.pillRow]: a horizontally scrollable, unpadded
///   row of self-contained pill widgets (e.g. `VitStatusPill`), with no
///   surface background.
/// - [VitScrollableTabHeader.surfaceDivider]: a fixed-width tab bar (e.g.
///   `VitTabBar`) wrapped in a surface-colored background with a trailing
///   hairline divider.
enum VitScrollableTabHeaderStyle { pillRow, surfaceDivider }

/// Page top tab/section switcher chrome, built via the named constructors
/// [VitScrollableTabHeader.pillRow] or [VitScrollableTabHeader.surfaceDivider].
class VitScrollableTabHeader extends StatelessWidget {
  const VitScrollableTabHeader.pillRow({
    super.key,
    required this.items,
    this.headerKey,
  }) : style = VitScrollableTabHeaderStyle.pillRow,
       tabBar = null;

  const VitScrollableTabHeader.surfaceDivider({
    super.key,
    required this.tabBar,
    this.headerKey,
  }) : style = VitScrollableTabHeaderStyle.surfaceDivider,
       items = const <Widget>[];

  /// Key applied to the outer scroll/surface container, matching the key
  /// previously placed on the local `_SectionTabs`/`_TopTabs` root widget.
  final Key? headerKey;
  final VitScrollableTabHeaderStyle style;

  /// Pre-built pill widgets for [VitScrollableTabHeaderStyle.pillRow].
  /// A [AppSurfaceSpacing.x2] gap is inserted between items automatically.
  final List<Widget> items;

  /// The tab bar wrapped for [VitScrollableTabHeaderStyle.surfaceDivider].
  final Widget? tabBar;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case VitScrollableTabHeaderStyle.pillRow:
        return SingleChildScrollView(
          key: headerKey,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                items[i],
                if (i != items.length - 1)
                  SizedBox(width: AppSurfaceSpacing.x2),
              ],
            ],
          ),
        );
      case VitScrollableTabHeaderStyle.surfaceDivider:
        return ColoredBox(
          key: headerKey,
          color: AppColors.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tabBar!,
              Divider(
                height: AppSurfaceSpacing.hairlineStroke,
                thickness: AppSurfaceSpacing.hairlineStroke,
                color: AppColors.border,
              ),
            ],
          ),
        );
    }
  }
}
