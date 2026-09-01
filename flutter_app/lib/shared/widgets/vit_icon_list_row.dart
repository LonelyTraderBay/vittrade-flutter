import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

/// Horizontal "icon box + title/subtitle column + trailing accessory" row.
///
/// Used for profile-style list rows: a leading icon box, a title/subtitle
/// text column, and an optional trailing accessory (chevron, status pill,
/// toggle, or a combination). Callers build [leading]/[title]/[subtitle]/
/// [trailing] themselves so per-row icon styling and text styles stay
/// unchanged; this widget only owns the shared row skeleton.
///
/// For a label:value only row, use [VitInfoRow] or [VitKeyValueRow]
/// instead. For a vertical grid tile, use [VitActionTileGrid].
class VitIconListRow extends StatelessWidget {
  const VitIconListRow({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.gap,
    this.subtitleGap,
    this.padding,
    this.minHeight,
    this.columnMainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
  });

  /// Pre-built leading accessory (icon box, avatar, level indicator, ...).
  final Widget leading;

  /// Primary row title. Callers control text style so density/weight can
  /// vary per call site.
  final Widget title;

  /// Optional secondary line rendered below [title].
  final Widget? subtitle;

  /// Optional trailing accessory (chevron, status pill, toggle, or a Row
  /// combining several — build any extra internal spacing into this
  /// widget, since no gap is added between the column and [trailing]).
  final Widget? trailing;

  /// Gap between [leading] and the title/subtitle column.
  final double? gap;

  /// Gap between [title] and [subtitle] when [subtitle] is set.
  final double? subtitleGap;

  final EdgeInsetsGeometry? padding;
  final double? minHeight;
  final MainAxisAlignment columnMainAxisAlignment;

  /// Optional row-level tap handler. Leave null when the enclosing
  /// [VitCard]/[InkWell] already owns the tap target.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedGap = gap ?? AppSurfaceSpacing.x3;
    final resolvedSubtitleGap = subtitleGap ?? AppSurfaceSpacing.x1;
    Widget content = Row(
      children: [
        leading,
        SizedBox(width: resolvedGap),
        Expanded(
          child: Column(
            mainAxisAlignment: columnMainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (subtitle != null) ...[
                SizedBox(height: resolvedSubtitleGap),
                subtitle!,
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (minHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight!),
        child: content,
      );
    }
    if (onTap != null) {
      content = Material(
        color: AppColors.transparent,
        child: InkWell(onTap: onTap, child: content),
      );
    }
    return content;
  }
}
