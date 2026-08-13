import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet dashboard equivalent of Profile's private `_VipCard`
/// (`profile_home_vip_prediction.dart`, phone-only — not importable outside
/// `profile_page.dart`'s `part` family). Same VIP-tier progress card, built
/// as its own public widget so a future `ProfileTabletPage` (SC-156) can
/// place it without touching the pinned phone reference.
class ProfileVipCardPanel extends StatelessWidget {
  const ProfileVipCardPanel({
    super.key,
    required this.vip,
    required this.onTap,
  });

  final ProfileVipProgress vip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Tiến độ VIP',
                style: AppTextStyles.control.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Flexible(
                child: Text(
                  '${vip.label} → ${vip.nextLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.badge.copyWith(color: AppColors.warn),
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: ProfileSpacingTokens.profileVipProgressHeight,
              value: vip.progress,
              color: AppColors.primary,
              backgroundColor: AppColors.surface2,
            ),
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              vip.volumeLabel,
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
