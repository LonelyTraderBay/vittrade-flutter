import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Lightweight "icon + label(s) inside a bordered tappable card" primitive.
///
/// Use this for simple quick-link/quick-action tiles that only need a
/// leading icon and one or two lines of text. For rows that also need a
/// status pill, CTA label, dismiss action, or chevron, use
/// [VitCard]-composed widgets like `VitNextActionCard` or
/// `VitDiscoveryActionCard` instead — this widget intentionally does not
/// carry those.
///
/// With [eyebrow] omitted, the icon and [label] are centered on a single
/// line (quick-action button shape). With [eyebrow] set, the icon is
/// leading-aligned next to a two-line eyebrow/label column (quick-link
/// card shape).
class VitIconLabelCard extends StatelessWidget {
  const VitIconLabelCard({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    this.eyebrow,
    this.onTap,
    this.borderColor,
    this.padding,
    this.iconSize,
    this.labelHeight,
  });

  final IconData icon;
  final String label;
  final String? eyebrow;
  final Color accentColor;
  final VoidCallback? onTap;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final double? labelHeight;

  @override
  Widget build(BuildContext context) {
    final hasEyebrow = eyebrow != null;
    final resolvedPadding = padding ?? AppSurfaceSpacing.cardPadding;
    final resolvedIconSize = iconSize ?? AppSurfaceSpacing.iconMd;
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: borderColor,
      padding: resolvedPadding,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: hasEyebrow
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Icon(icon, color: accentColor, size: resolvedIconSize),
          SizedBox(width: AppSurfaceSpacing.x3),
          if (hasEyebrow)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.navLabel.copyWith(color: accentColor),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: labelHeight,
                    ),
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
