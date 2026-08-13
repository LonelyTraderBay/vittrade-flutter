part of 'profile_page.dart';

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.user,
    required this.copiedReferral,
    required this.onEdit,
    required this.onCopyReferral,
  });

  final ProfileUser user;
  final bool copiedReferral;
  final VoidCallback onEdit;
  final VoidCallback onCopyReferral;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      variant: VitCardVariant.hero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: user.fullName,
                accentColor: AppColors.primary,
                size: ProfileSpacingTokens.profileHeroAvatar,
                radius: AppRadii.cardRadius,
                border: true,
              ),
              const SizedBox(width: ProfileSpacingTokens.profileMenuGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      VitFormat.email(user.email),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        VitAccentPill(
                          label: user.vipLevel,
                          accentColor: _profileAmber,
                        ),
                        VitAccentPill(
                          label: 'KYC ${user.kycLevel}',
                          accentColor: _profileGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VitIconButton(
                key: ProfilePage.editProfileKey,
                icon: Icons.person_outline_rounded,
                tooltip: 'Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1',
                onPressed: onEdit,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          Row(
            children: [
              Expanded(
                child: _HeroInfoBox(label: 'UID', value: user.id),
              ),
              const SizedBox(width: ProfileSpacingTokens.profileHeroInfoGap),
              Expanded(
                child: Material(
                  color: AppColors.transparent,
                  child: InkWell(
                    key: ProfilePage.copyReferralKey,
                    onTap: onCopyReferral,
                    borderRadius: AppRadii.cardRadius,
                    child: _HeroInfoBox(
                      label: 'M\u00E3 gi\u1EDBi thi\u1EC7u',
                      value: user.referralCode,
                      valueColor: AppColors.primarySoft,
                      trailing: Icon(
                        copiedReferral
                            ? Icons.check_circle_outline_rounded
                            : Icons.copy_rounded,
                        color: copiedReferral
                            ? _profileGreen
                            : AppColors.primarySoft,
                        size: ProfileSpacingTokens.profileModuleIcon,
                      ),
                    ),
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

class _HeroInfoBox extends StatelessWidget {
  const _HeroInfoBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: VitDensity.compact.controlHeight),
      child: Material(
        color: AppColors.onAccent.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.onAccent.withValues(alpha: .08)),
        ),
        child: Padding(
          padding: ProfileSpacingTokens.profileHeroInfoPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.badge.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.control.copyWith(
                        color: valueColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(
                      width: ProfileSpacingTokens.profileHeroInfoTrailingGap,
                    ),
                    trailing!,
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
