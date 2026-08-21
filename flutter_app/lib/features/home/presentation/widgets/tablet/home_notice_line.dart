import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Static single-announcement notice line for the tablet sidebar. The page
/// passes only the top-priority announcement (its own priority sort plus
/// session dismissals decide which one that is); dismissing it surfaces the
/// next one on the next build. No carousel and no auto-advance timer — a
/// self-rotating banner on a monitoring dashboard violates the
/// "auto-rotating content needs user control" / "1–2 motion elements per
/// view" UX rules this composition follows. Tapping navigates when the
/// announcement carries a route; a routeless announcement is
/// dismiss-only.
class HomeNoticeLine extends StatelessWidget {
  const HomeNoticeLine({
    super.key,
    required this.announcement,
    required this.onDismiss,
    required this.onNavigate,
  });

  final HomeAnnouncement announcement;
  final ValueChanged<HomeAnnouncement> onDismiss;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitAnnouncementBanner(
      key: HomeTabletKeys.announcement,
      message: announcement.text,
      icon: _icon(announcement.type),
      accentColor: _color(announcement.type),
      onTap: announcement.routePath != null
          ? () => onNavigate(announcement.routePath!)
          : null,
      onDismiss: () => onDismiss(announcement),
    );
  }

  IconData _icon(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => Icons.shield_outlined,
      HomeAnnouncementType.risk => Icons.warning_amber_rounded,
      HomeAnnouncementType.campaign => Icons.card_giftcard_rounded,
      HomeAnnouncementType.info => Icons.campaign_rounded,
    };
  }

  Color _color(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => AppColors.info,
      HomeAnnouncementType.risk => AppColors.riskWarning,
      HomeAnnouncementType.campaign => AppColors.primary,
      HomeAnnouncementType.info => AppColors.text2,
    };
  }
}
