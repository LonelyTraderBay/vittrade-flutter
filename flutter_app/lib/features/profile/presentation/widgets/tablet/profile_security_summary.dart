import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Account-security status block leading the Profile tablet sidebar —
/// surfaces the security checklist score (same `{label} ({score}/4)` semantic
/// as the phone Security page's score card) plus a shortcut into
/// Bảo mật & 2FA, so account health is glanceable from the profile itself.
class ProfileSecuritySummary extends StatelessWidget {
  const ProfileSecuritySummary({
    super.key,
    required this.snapshot,
    required this.onUpgrade,
  });

  final ProfileSecuritySnapshot snapshot;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final scoreColor = Color(snapshot.scoreColorHex);

    return VitCard(
      key: ProfileTabletKeys.securityScore,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm bảo mật',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${snapshot.scoreLabel} (${snapshot.score}/4)',
                style: AppTextStyles.control.copyWith(
                  color: scoreColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSegmentedProgressBar(
            segmentCount: 4,
            filledCount: snapshot.score,
            filledColor: scoreColor,
            unfilledColor: AppColors.surface3,
            height: ProfileSpacingTokens.securityScoreBarHeight,
            gap: ProfileSpacingTokens.securityScoreBarGap,
            borderRadius: AppRadii.pillRadius,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: onUpgrade,
            variant: VitCtaButtonVariant.secondary,
            density: VitDensity.compact,
            height: AppSpacing.buttonCompact,
            child: const Text('Nâng cấp bảo mật'),
          ),
        ],
      ),
    );
  }
}
