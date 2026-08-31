import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet-dashboard public ports of Profile's private `_ActivityButton` and
/// `_LogoutButton` (`profile_home_menu_actions.dart`, phone-only — not
/// importable outside `profile_page.dart`'s `part` family). Bundled in one
/// file because they render adjacently as the account list's closing pair
/// on both phone and tablet.
class ProfileActivityButton extends StatelessWidget {
  const ProfileActivityButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: AppColors.cardBorder,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight,
        ),
        child: Center(
          child: Text(
            'Nhật ký hoạt động',
            style: AppTextStyles.control.copyWith(color: AppColors.text2),
          ),
        ),
      ),
    );
  }
}

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.logout,
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: AppColors.sell.withValues(alpha: .22),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: AppColors.sell,
              size: ProfileSpacingTokens.profileLogoutIcon,
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(
              'Đăng xuất',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.sell,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
