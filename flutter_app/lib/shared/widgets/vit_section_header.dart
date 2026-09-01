import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Leading-decoration style of a [VitSectionHeader]: no decoration, a
/// colored accent bar, or a smaller marker-title bar.
enum VitSectionHeaderVariant { plain, accentBar, markerTitle }

/// Section title row: optional accent bar/icon/subtitle and a trailing
/// "see more"-style text action.
class VitSectionHeader extends StatelessWidget {
  const VitSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.actionLabel,
    this.onAction,
    this.actionKey,
    this.actionSemanticLabel,
    this.actionShowChevron = true,
    this.variant = VitSectionHeaderVariant.plain,
    this.accentColor = AppColors.primary,
    this.density = VitDensity.standard,
    this.bottomGap,
    this.titleColor,
    this.titleFontWeight,
    this.titleLetterSpacing,
    this.titleHeight,
  });

  final String title;

  /// Optional secondary line rendered below [title] (micro/text3). Used by
  /// section headers that need a short explanatory line, e.g. Arena flow
  /// map/leaderboard section markers.
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  /// Overrides the leading [icon]'s size. Defaults to [AppSurfaceSpacing.iconMd].
  final double? iconSize;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  /// When false, trailing action is text-only (form shortcuts like Quét QR).
  final bool actionShowChevron;

  /// Accessible label for the trailing action button. Defaults to
  /// '$actionLabel $title' (e.g. 'Xem thêm Sản phẩm') when not provided, so
  /// every call site gets a screen-reader label distinguishing it from other
  /// sections' generic "Xem thêm"/"Xem tất cả" buttons without requiring an
  /// update everywhere.
  final String? actionSemanticLabel;
  final VitSectionHeaderVariant variant;
  final Color accentColor;
  final VitDensity density;

  /// Space below the header row (title → body). When null, callers or
  /// [VitPageSection] supply padding externally.
  final double? bottomGap;

  /// Overrides the title's text color. Defaults to [AppColors.text1].
  final Color? titleColor;

  /// Overrides the title's font weight. Defaults to [AppTextStyles.bold].
  final FontWeight? titleFontWeight;

  /// Overrides the title's letter spacing. Defaults to the base style's own.
  final double? titleLetterSpacing;

  /// Overrides the title's line height. Defaults to
  /// [SharedSpacingTokens.homeSectionHeaderTitleLineHeight].
  final double? titleHeight;

  bool get _isCompact =>
      density == VitDensity.compact || density == VitDensity.tool;

  @override
  Widget build(BuildContext context) {
    final showAccent = variant == VitSectionHeaderVariant.accentBar;
    final showMarkerTitle = variant == VitSectionHeaderVariant.markerTitle;
    final baseTitleStyle = showMarkerTitle
        ? AppTextStyles.baseMedium
        : (_isCompact ? AppTextStyles.caption : AppTextStyles.sectionTitle);
    final titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: baseTitleStyle.copyWith(
        color: titleColor ?? AppColors.text1,
        fontWeight: titleFontWeight ?? AppTextStyles.bold,
        height:
            titleHeight ?? SharedSpacingTokens.homeSectionHeaderTitleLineHeight,
        letterSpacing: titleLetterSpacing,
      ),
    );
    final header = Row(
      children: [
        if (showAccent) ...[
          SizedBox(
            width: AppSurfaceSpacing.serviceTileAccentBarThickness,
            height: _isCompact
                ? AppSurfaceSpacing.pageSectionAccentHeight
                : AppSurfaceSpacing.serviceTileSectionBarHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSurfaceSpacing.x3),
        ],
        if (showMarkerTitle) ...[
          SizedBox(
            width: AppSurfaceSpacing.pageSectionAccentWidth,
            height: AppSurfaceSpacing.rowPy + AppSurfaceSpacing.x1,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSurfaceSpacing.x3),
        ],
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? accentColor,
            size: iconSize ?? AppSurfaceSpacing.iconMd,
          ),
          const SizedBox(width: SharedSpacingTokens.homeSectionHeaderIconGap),
        ],
        Expanded(
          child: Semantics(
            header: true,
            child: subtitle == null
                ? titleWidget
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      titleWidget,
                      Text(
                        subtitle!,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          Semantics(
            button: true,
            label: actionSemanticLabel ?? '$actionLabel $title',
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                key: actionKey,
                onTap: onAction,
                borderRadius: AppRadii.inputRadius,
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSurfaceSpacing.x3,
                    vertical: AppSurfaceSpacing.x2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!,
                        style: AppTextStyles.caption.copyWith(
                          color: accentColor,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      if (actionShowChevron) ...[
                        SizedBox(width: AppSurfaceSpacing.x1),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: accentColor,
                          size:
                              SharedSpacingTokens.homeSectionHeaderChevronSize,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    if (bottomGap == null) return header;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: bottomGap!),
      child: header,
    );
  }
}
