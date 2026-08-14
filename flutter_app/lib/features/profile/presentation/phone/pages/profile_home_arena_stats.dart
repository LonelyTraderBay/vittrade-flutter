part of 'profile_page.dart';

class _ArenaCard extends StatelessWidget {
  const _ArenaCard({required this.arena, required this.onTap});

  final ProfileArenaBlock arena;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfilePage.arenaCardKey,
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: _profileAmber.withValues(alpha: .34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_esports_outlined,
                color: _profileAmber,
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
                accentColor: _profileAmber,
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
                  valueColor: _profileAmber,
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'Ph\u00F2ng',
                  value: '${arena.rooms}',
                ),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleStatGap),
              Expanded(
                child: _ModuleStat(
                  label: 'Creator',
                  value: arena.creatorScoreLabel,
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
                  'V\u00E0o s\u00E2n ch\u01A1i c\u1EE7a t\u00F4i',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: _profileAmber),
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _profileAmber,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileModuleEndGap),
              const Icon(
                Icons.shield_outlined,
                color: _profileMuted,
                size: ProfileSpacingTokens.profileModuleLinkIcon,
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
              ),
              Flexible(
                child: Text(
                  'An to\u00E0n & B\u00E1o c\u00E1o',
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
          style: AppTextStyles.numericMicro.copyWith(color: _profileMuted),
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
