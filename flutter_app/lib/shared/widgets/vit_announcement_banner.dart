import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_carousel_dots.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inline_icon_action.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Padding density of a [VitAnnouncementBanner]: `standard` or `compact`.
enum VitAnnouncementBannerVariant { standard, compact }

/// Dismissible icon + message banner with optional carousel dots, used for
/// promo/announcement callouts (e.g. on the home page).
class VitAnnouncementBanner extends StatelessWidget {
  const VitAnnouncementBanner({
    super.key,
    required this.message,
    this.icon = Icons.card_giftcard_rounded,
    this.accentColor = AppColors.primary,
    this.itemCount = 1,
    this.activeIndex = 0,
    this.variant = VitAnnouncementBannerVariant.standard,
    this.showCompactDots = false,
    this.onTap,
    this.onDismiss,
  });

  final String message;
  final IconData icon;
  final Color accentColor;
  final int itemCount;
  final int activeIndex;
  final VitAnnouncementBannerVariant variant;
  final bool showCompactDots;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  bool get _showDots {
    return itemCount > 1 &&
        (variant == VitAnnouncementBannerVariant.standard || showCompactDots);
  }

  EdgeInsetsGeometry get _padding {
    return switch (variant) {
      VitAnnouncementBannerVariant.standard =>
        AppSurfaceSpacing.homeCardPaddingDefault,
      VitAnnouncementBannerVariant.compact =>
        AppSurfaceSpacing.homeAnnouncementCardPaddingCompact,
    };
  }

  @override
  Widget build(BuildContext context) {
    final banner = Column(
      children: [
        VitCard(
          radius: VitCardRadius.standard,
          borderColor: accentColor.withValues(alpha: .18),
          padding: _padding,
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                icon,
                color: accentColor,
                size: SharedSpacingTokens.homeAnnouncementIcon,
              ),
              SizedBox(width: AppSurfaceSpacing.homeAnnouncementIconGap),
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              SizedBox(width: AppSurfaceSpacing.homeAnnouncementArrowGap),
              if (onDismiss == null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: SharedSpacingTokens.homeAnnouncementChevron,
                )
              else
                VitInlineIconAction(
                  icon: Icons.close_rounded,
                  tooltip: 'Dismiss announcement',
                  color: AppColors.text3,
                  onPressed: onDismiss!,
                ),
            ],
          ),
        ),
        if (_showDots) ...[
          SizedBox(height: AppSurfaceSpacing.x3),
          VitCarouselDots(itemCount: itemCount, activeIndex: activeIndex),
        ],
      ],
    );

    return Semantics(label: 'Announcement: $message', child: banner);
  }
}
