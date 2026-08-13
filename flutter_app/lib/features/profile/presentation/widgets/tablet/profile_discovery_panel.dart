import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet dashboard equivalents of Profile's private `_PredictionCard` and
/// `_ArenaCard` (`profile_home_vip_prediction.dart` /
/// `profile_home_arena_stats.dart`, phone-only — not importable outside
/// `profile_page.dart`'s `part` family). Bundled in one file because they
/// render adjacently as one "Dự đoán & Thách đấu" section on the phone
/// page, but kept as two separate public cards (not merged into one panel
/// widget) so a future `ProfileTabletPage` (SC-156) can compose them freely
/// across its two dashboard columns without touching the pinned phone
/// reference.
class ProfilePredictionCard extends StatelessWidget {
  const ProfilePredictionCard({
    super.key,
    required this.prediction,
    required this.onTap,
  });

  final ProfilePredictionBlock prediction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.predictionCard,
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: AppColors.accent.withValues(alpha: .38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.adjust_rounded,
                color: AppColors.accent,
                size: ProfileSpacingTokens.profileModuleIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleGap),
              Expanded(
                child: Text(
                  'Prediction Portfolio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleGap),
              const VitAccentPill(
                label: 'Prediction Market',
                accentColor: AppColors.accent,
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: _ModuleStat(
                  label: 'Vị thế',
                  value: '${prediction.positions}',
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'Lệnh mở',
                  value: '${prediction.openOrders}',
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'P/L',
                  value: prediction.pnlLabel,
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Xem portfolio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: AppColors.accent),
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.accent,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleEndGap),
              const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.text3,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              Flexible(
                child: Text(
                  'Leaderboard',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileArenaCard extends StatelessWidget {
  const ProfileArenaCard({super.key, required this.arena, required this.onTap});

  final ProfileArenaBlock arena;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.arenaCard,
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: AppColors.warn.withValues(alpha: .34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_esports_outlined,
                color: AppColors.warn,
                size: ProfileSpacingTokens.profileModuleIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleGap),
              Expanded(
                child: Text(
                  'Open Arena',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleGap),
              const VitAccentPill(
                label: 'Points only',
                accentColor: AppColors.warn,
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: _ModuleStat(
                  label: 'Arena Points',
                  value: arena.pointsLabel,
                  valueColor: AppColors.warn,
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(label: 'Phòng', value: '${arena.rooms}'),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'Creator',
                  value: arena.creatorScoreLabel,
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vào sân chơi của tôi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: AppColors.warn),
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.warn,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleEndGap),
              const Icon(
                Icons.shield_outlined,
                color: AppColors.text3,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              Flexible(
                child: Text(
                  'An toàn & Báo cáo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleStat extends StatelessWidget {
  const _ModuleStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.control.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
