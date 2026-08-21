import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Identity-hero card opening the Profile tablet dashboard's primary column
/// as its first *scrolling* card (SC-156 tablet — the Home tablet pattern
/// for tall hero cards like `HomePortfolioCard`; a locked banner-slot hero
/// would eat a third of an 800dp-tall landscape screen). Profile is an
/// identity surface, not a market monitor — so instead of the flat KPI-strip
/// idiom the other root tabs use, it takes the app's hero vocabulary
/// ([VitCardVariant.hero] portfolio gradient + [VitHeroGlow]): avatar and
/// the member's name as the page's real title, tier pills (VIP/KYC with the
/// verify CTA when action is needed), UID/referral ghost fact boxes, and the
/// VIP progress as a runway bar across the hero's foot. Email stays masked
/// through [VitFormat.email] per the sensitive-data policy.
class ProfileAccountHero extends StatelessWidget {
  const ProfileAccountHero({
    super.key,
    required this.snapshot,
    required this.copiedReferral,
    required this.onEdit,
    required this.onCopyReferral,
    required this.onVerifyKyc,
    required this.onVip,
  });

  final ProfileSnapshot snapshot;
  final bool copiedReferral;
  final VoidCallback onEdit;
  final VoidCallback onCopyReferral;
  final VoidCallback onVerifyKyc;
  final VoidCallback onVip;

  /// Below this width (the dashboard's single-column fallback territory) the
  /// hero reflows vertically — identity and pills first, fact boxes second,
  /// runway last.
  static const double _compactBreakpoint = 760;

  @override
  Widget build(BuildContext context) {
    final user = snapshot.user;
    final vip = snapshot.vip;
    final needsAction = user.kycNeedsAction;

    final identityBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.onAccent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    VitFormat.email(user.email),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Tham gia từ ${user.joinDate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
            VitIconButton(
              key: ProfileTabletKeys.editProfile,
              icon: Icons.person_outline_rounded,
              tooltip: 'Chỉnh sửa hồ sơ',
              onPressed: onEdit,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        SizedBox(height: VitDensity.compact.verticalSpace),
        Wrap(
          key: ProfileTabletKeys.heroPills,
          spacing: ProfileSpacingTokens.profileHeroPillGap,
          runSpacing: ProfileSpacingTokens.profileHeroPillRunGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            VitAccentPill(
              label: user.vipLevel,
              accentColor: AppColors.medalGold,
            ),
            VitAccentPill(
              label: 'KYC ${user.kycLevel}',
              accentColor: needsAction ? AppColors.riskWarning : AppColors.buy,
            ),
            if (needsAction)
              VitCtaButton(
                key: ProfileTabletKeys.kycBanner,
                onPressed: onVerifyKyc,
                variant: VitCtaButtonVariant.primary,
                density: VitDensity.compact,
                height: AppSpacing.buttonCompact,
                fullWidth: false,
                child: const Text('Xác minh'),
              ),
          ],
        ),
      ],
    );

    final factBoxes = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeroFactBox(label: 'UID', value: user.id),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Material(
          color: AppColors.transparent,
          child: InkWell(
            key: ProfileTabletKeys.copyReferral,
            onTap: onCopyReferral,
            borderRadius: AppRadii.cardRadius,
            child: _HeroFactBox(
              label: 'Mã giới thiệu',
              value: user.referralCode,
              valueColor: AppColors.primarySoft,
              trailing: Icon(
                copiedReferral
                    ? Icons.check_circle_outline_rounded
                    : Icons.copy_rounded,
                color: copiedReferral ? AppColors.buy : AppColors.primarySoft,
                size: ProfileSpacingTokens.profileModuleIcon,
              ),
            ),
          ),
        ),
      ],
    );

    // VIP runway — the tier progress bar spanning the hero's foot.
    final runway = Material(
      color: AppColors.transparent,
      child: InkWell(
        key: ProfileTabletKeys.vipRunway,
        onTap: onVip,
        borderRadius: AppRadii.cardRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VitProgressBar(
              progress: vip.progress,
              label: 'Tiến độ VIP',
              trailingLabel: '${vip.label} → ${vip.nextLabel}',
              color: AppColors.medalGold,
              trackColor: AppColors.portfolioBtnGhost,
              height: ProfileSpacingTokens.profileVipProgressHeight,
              borderRadius: AppRadii.pillRadius,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              vip.volumeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
              ),
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _compactBreakpoint;
        return VitCard(
          key: ProfileTabletKeys.accountHero,
          variant: VitCardVariant.hero,
          radius: VitCardRadius.large,
          clip: true,
          padding: ProfileSpacingTokens.profileHeroPadding,
          background: const VitHeroGlow(),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    identityBlock,
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    factBoxes,
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    runway,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 5, child: identityBlock),
                          const SizedBox(width: AppSpacing.x4),
                          Expanded(flex: 3, child: factBoxes),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    runway,
                  ],
                ),
        );
      },
    );
  }
}

/// Ghost fact box on the hero surface — translucent [AppColors.onAccent]
/// fill/border (the hero-surface idiom) holding one identity fact.
class _HeroFactBox extends StatelessWidget {
  const _HeroFactBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.onAccent,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
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
