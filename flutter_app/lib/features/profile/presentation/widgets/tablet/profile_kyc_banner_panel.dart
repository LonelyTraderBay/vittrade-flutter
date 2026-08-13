import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet-dashboard public port of Profile's private `_KycUpgradeBanner`
/// (`profile_home_menu_actions.dart`, phone-only — not importable outside
/// `profile_page.dart`'s `part` family). Same KYC upgrade prompt banner.
class ProfileKycBannerPanel extends StatelessWidget {
  const ProfileKycBannerPanel({super.key, required this.onVerify});

  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      key: ProfileTabletKeys.kycBanner,
      variant: VitBannerVariant.warning,
      icon: Icons.verified_user_outlined,
      message: 'Hoàn tất KYC để nâng hạn mức giao dịch và rút tiền.',
      action: VitCtaButton(
        onPressed: onVerify,
        fullWidth: false,
        density: VitDensity.compact,
        height: AppSpacing.buttonCompact,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x4,
        ),
        child: const Text('Xác minh'),
      ),
    );
  }
}
