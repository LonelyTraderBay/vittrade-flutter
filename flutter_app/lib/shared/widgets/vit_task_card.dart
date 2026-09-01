import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_icon_box.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

/// Progress state of a [VitTaskCard] (Rewards/Arena mission).
enum VitTaskCardStatus { active, completed, claimed }

/// Tier E intrinsic-height task row for Rewards / Arena mission lists.
///
/// Do not set fixed [VitCard.height] or legacy `buttonHero + x7 + x5` minHeight —
/// content defines card height. See Task-Card-Standard.md.
class VitTaskCard extends StatelessWidget {
  const VitTaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.rewardLabel,
    required this.status,
    required this.accentColor,
    required this.icon,
    this.claimedRewardColor = AppColors.buy,
    this.pendingRewardColor = AppColors.warn,
  });

  final String title;
  final String subtitle;
  final double progress;
  final String rewardLabel;
  final VitTaskCardStatus status;
  final Color accentColor;
  final IconData icon;
  final Color claimedRewardColor;
  final Color pendingRewardColor;

  @override
  Widget build(BuildContext context) {
    final rewardColor = status == VitTaskCardStatus.claimed
        ? claimedRewardColor
        : pendingRewardColor;

    return VitCard(
      padding: AppSurfaceSpacing.taskCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentIconBox(icon: icon, color: accentColor),
          SizedBox(width: AppSurfaceSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSurfaceSpacing.x2),
                    _VitTaskCardStatusPill(status: status),
                  ],
                ),
                SizedBox(height: AppSurfaceSpacing.taskCardTitleSubtitleGap),
                Text(
                  subtitle,
                  maxLines: AppSurfaceSpacing.taskCardSubtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                SizedBox(height: AppSurfaceSpacing.taskCardProgressSectionGap),
                _VitTaskCardProgressBar(value: progress, color: accentColor),
                SizedBox(height: AppSurfaceSpacing.taskCardRewardRowGap),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        rewardLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: rewardColor,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${(progress.clamp(0.0, 1.0) * 100).round()}%',
                      style: AppTextStyles.micro.copyWith(
                        color: accentColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VitTaskCardStatusPill extends StatelessWidget {
  const _VitTaskCardStatusPill({required this.status});

  final VitTaskCardStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      VitTaskCardStatus.completed => const VitStatusPill(
        label: 'Nhận',
        status: VitStatusPillStatus.orange,
        size: VitStatusPillSize.sm,
      ),
      VitTaskCardStatus.claimed => const VitStatusPill(
        label: 'Đã nhận',
        status: VitStatusPillStatus.success,
        size: VitStatusPillSize.sm,
      ),
      VitTaskCardStatus.active => const VitStatusPill(
        label: 'Đang làm',
        status: VitStatusPillStatus.neutral,
        size: VitStatusPillSize.sm,
      ),
    };
  }
}

class _VitTaskCardProgressBar extends StatelessWidget {
  const _VitTaskCardProgressBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: SizedBox(
        height: AppSurfaceSpacing.taskCardProgressHeight,
        child: ColoredBox(
          color: AppColors.surface3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: safeValue,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
