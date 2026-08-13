part of 'profile_page.dart';

class _VipCard extends StatelessWidget {
  const _VipCard({required this.vip, required this.onTap});

  final ProfileVipProgress vip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: _profileBorder,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Ti\u1EBFn \u0111\u1ED9 VIP',
                style: AppTextStyles.control.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Flexible(
                child: Text(
                  '${vip.label} \u2192 ${vip.nextLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.badge.copyWith(color: _profileAmber),
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
              backgroundColor: _profilePanel2,
            ),
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              vip.volumeLabel,
              style: AppTextStyles.numericMicro.copyWith(color: _profileMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.prediction, required this.onTap});

  final ProfilePredictionBlock prediction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfilePage.predictionCardKey,
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: _profilePurple.withValues(alpha: .38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.adjust_rounded,
                color: _profilePurple,
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
                accentColor: _profilePurple,
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: _ModuleStat(
                  label: 'V\u1ECB th\u1EBF',
                  value: '${prediction.positions}',
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'L\u1EC7nh m\u1EDF',
                  value: '${prediction.openOrders}',
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'P/L',
                  value: prediction.pnlLabel,
                  valueColor: _profileGreen,
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
                  style: AppTextStyles.badge.copyWith(color: _profilePurple),
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _profilePurple,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleEndGap),
              const Icon(
                Icons.emoji_events_outlined,
                color: _profileMuted,
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
                    color: _profileMuted,
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
