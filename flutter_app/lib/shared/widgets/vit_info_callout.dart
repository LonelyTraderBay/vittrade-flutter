import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Accent-bordered info card (icon + optional title + body).
/// Prefer [VitBanner] when the tone is one of
/// info / warning / error / success. Use this when a module accent color
/// is required (earn, p2p, etc.).
class VitInfoCallout extends StatelessWidget {
  const VitInfoCallout({
    super.key,
    required this.message,
    this.icon = Icons.info_outline_rounded,
    this.title,
    this.accentColor = AppColors.primary,
    this.padding,
    this.radius = VitCardRadius.standard,
    this.messageColor,
    this.messageStyle,
    this.messageWeight,
    this.iconSize,
    this.variant = VitCardVariant.inner,
    this.maxLines,
    this.trailing,
    this.onTap,
  });

  final String message;
  final IconData icon;
  final String? title;
  final Color accentColor;
  final EdgeInsetsGeometry? padding;
  final VitCardRadius radius;

  /// Overrides the message text color. Defaults to [AppColors.text2].
  final Color? messageColor;

  /// Overrides the message text style. Defaults to [AppTextStyles.caption].
  final TextStyle? messageStyle;

  /// Overrides the message font weight without replacing [messageStyle].
  final FontWeight? messageWeight;

  /// Leading icon size. Defaults to [AppSurfaceSpacing.iconMd] (current behavior).
  final double? iconSize;

  /// [VitCard] surface variant. Defaults to [VitCardVariant.inner] (current
  /// behavior).
  final VitCardVariant variant;

  /// Caps the message to this many lines, ellipsizing overflow. Defaults to
  /// unbounded (current behavior).
  final int? maxLines;

  /// Optional widget rendered at the end of the row (e.g. a trailing
  /// chevron for a tappable row). Defaults to none (current behavior).
  final Widget? trailing;

  /// Makes the callout tappable via [VitCard]'s built-in [InkWell] wrapper.
  /// Defaults to null, which keeps the callout non-interactive (current
  /// behavior). Typically paired with [trailing] set to a chevron icon.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedMessageStyle = messageStyle ?? AppTextStyles.caption;
    final resolvedIconSize = iconSize ?? AppSurfaceSpacing.iconMd;
    return VitCard(
      variant: variant,
      radius: radius,
      borderColor: accentColor.withValues(alpha: 0.22),
      padding: padding ?? EdgeInsetsDirectional.all(AppSurfaceSpacing.x4),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: resolvedIconSize),
          SizedBox(width: AppSurfaceSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  SizedBox(height: AppSurfaceSpacing.x1),
                ],
                Text(
                  message,
                  maxLines: maxLines,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  style: resolvedMessageStyle.copyWith(
                    color: messageColor ?? AppColors.text2,
                    fontWeight:
                        messageWeight ?? resolvedMessageStyle.fontWeight,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: AppSurfaceSpacing.x2),
            trailing!,
          ],
        ],
      ),
    );
  }
}
