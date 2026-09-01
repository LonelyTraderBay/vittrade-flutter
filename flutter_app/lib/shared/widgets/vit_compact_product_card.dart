import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Compact fixed-height tile pairing an accent icon, title, subtitle, and
/// optional badge — used for recent/quick-access product entries.
class VitCompactProductCard extends StatelessWidget {
  const VitCompactProductCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.badgeLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String? badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      height: SharedSpacingTokens.homeRecentProductHeight,
      contentAlign: VitCardContentAlign.center,
      padding: AppSurfaceSpacing.cardTilePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: SharedSpacingTokens.homeRecentProductIcon,
                height: SharedSpacingTokens.homeRecentProductIcon,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: accentColor.withValues(alpha: .14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: SharedSpacingTokens.homeRecentProductIconText,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (badgeLabel != null)
                VitAccentPill(label: badgeLabel!, accentColor: accentColor),
            ],
          ),
          SizedBox(height: AppSurfaceSpacing.cardTileInnerGap),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          SizedBox(height: AppSurfaceSpacing.cardTileInnerGap),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
