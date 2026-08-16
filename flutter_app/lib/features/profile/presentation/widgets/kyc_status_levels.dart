part of '../phone/pages/kyc_page.dart';

class _KycStatusCard extends StatelessWidget {
  const _KycStatusCard({required this.snapshot});

  final ProfileKycSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: KYCPage.statusCardKey,
      density: VitDensity.compact,
      borderColor: _kycGreen.withValues(alpha: .45),
      child: VitIconListRow(
        gap: ProfileSpacingTokens.kycStatusGap,
        leading: SizedBox(
          width: ProfileSpacingTokens.kycStatusIconBox,
          height: ProfileSpacingTokens.kycStatusIconBox,
          child: Material(
            color: _kycGreen.withValues(alpha: .2),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _kycGreen,
              size: ProfileSpacingTokens.kycStatusIcon,
            ),
          ),
        ),
        title: Text(
          snapshot.statusTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: Text(
                snapshot.statusDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: _kycGreen,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            const SizedBox(width: ProfileSpacingTokens.kycStatusCheckGap),
            const Icon(
              Icons.check_rounded,
              color: _kycGreen,
              size: ProfileSpacingTokens.kycStatusCheckIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _KycLevelCard extends StatelessWidget {
  const _KycLevelCard({
    required this.level,
    required this.done,
    required this.expanded,
    required this.currentLevel,
    required this.submitting,
    required this.onTap,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final bool expanded;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final accent = Color(level.colorHex);
    final border = done ? accent.withValues(alpha: .44) : AppColors.borderSolid;

    return VitCard(
      borderColor: border,
      clip: true,
      child: Column(
        children: [
          VitCard(
            key: KYCPage.levelKey(level.level),
            onTap: onTap,
            variant: VitCardVariant.ghost,
            borderColor: AppColors.transparent,
            child: VitIconListRow(
              minHeight: VitDensity.compact.controlHeight + AppSpacing.x5,
              padding: ProfileSpacingTokens.kycLevelRowPadding,
              gap: ProfileSpacingTokens.kycLevelRowGap,
              leading: _LevelIcon(
                level: level.level,
                done: done,
                accent: accent,
              ),
              title: Text(
                level.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: done ? AppColors.text1 : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              subtitle: done
                  ? Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: _kycMuted,
                          size: ProfileSpacingTokens.kycDetailIcon,
                        ),
                        const SizedBox(
                          width:
                              AppSpacing.dividerHairline +
                              AppSpacing.hairlineStroke,
                        ),
                        Text(
                          '\u0110\u00E3 ho\u00E0n th\u00E0nh',
                          style: AppTextStyles.badge.copyWith(color: _kycMuted),
                        ),
                      ],
                    )
                  : Text(
                      'Ch\u01B0a x\u00E1c minh',
                      style: AppTextStyles.badge.copyWith(color: _kycMuted),
                    ),
              trailing: AnimatedRotation(
                turns: expanded ? .25 : 0,
                duration: const Duration(milliseconds: 180),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: ProfileSpacingTokens.kycLevelChevron,
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            Padding(
              padding: ProfileSpacingTokens.kycLevelDetailsPadding,
              child: _ExpandedLevelDetails(
                level: level,
                done: done,
                currentLevel: currentLevel,
                submitting: submitting,
                onStart: onStart,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelIcon extends StatelessWidget {
  const _LevelIcon({
    required this.level,
    required this.done,
    required this.accent,
  });

  final int level;
  final bool done;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ProfileSpacingTokens.kycLevelIconBox,
      height: ProfileSpacingTokens.kycLevelIconBox,
      child: Material(
        color: done ? accent.withValues(alpha: .13) : AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
          side: BorderSide(
            color: done ? accent : AppColors.borderSolid,
            width: ProfileSpacingTokens.kycLevelIconBorder,
          ),
        ),
        child: Center(
          child: done
              ? Icon(
                  Icons.check_circle_outline_rounded,
                  color: accent,
                  size: ProfileSpacingTokens.kycLevelDoneIcon,
                )
              : Text(
                  '$level',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ExpandedLevelDetails extends StatelessWidget {
  const _ExpandedLevelDetails({
    required this.level,
    required this.done,
    required this.currentLevel,
    required this.submitting,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final canStart = !done && level.level == currentLevel + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DetailsBlock(
          title: 'Gi\u1EDBi h\u1EA1n giao d\u1ECBch:',
          lines: level.limits,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _DetailsBlock(
          title: 'T\u00EDnh n\u0103ng m\u1EDF kh\u00F3a:',
          lines: level.features,
          done: done,
        ),
        if (canStart) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: KYCPage.startKey(level.level),
            onPressed: submitting ? null : onStart,
            loading: submitting,
            density: VitDensity.compact,
            child: Text(
              submitting
                  ? '\u0110ang g\u1EEDi...'
                  : 'B\u1EAFt \u0111\u1EA7u x\u00E1c minh ${level.title}',
            ),
          ),
        ],
      ],
    );
  }
}
