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

/// Full-width account-identity banner spanning both dashboard columns
/// (SC-156 tablet, banner slot of `VitTwoColumnTabletDashboard`). Compresses
/// what the phone page spreads across a hero card, a KYC upgrade banner and
/// a VIP progress card into one horizontal strip — identity, UID, referral
/// copy, KYC state (with the verify CTA when action is needed) and VIP
/// progress — so the primary column below starts directly at the account
/// menu. Same KPI-strip idiom as the Home/Markets tablet banners; email is
/// masked through [VitFormat.email] per the sensitive-data policy.
class ProfileAccountStrip extends StatelessWidget {
  const ProfileAccountStrip({
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

  /// Below this width (the dashboard's single-column fallback territory)
  /// the strip reflows into two rows — identity/UID/referral first, KYC and
  /// VIP below — mirroring `HomeTabletKpiStrip`'s own compact reflow.
  static const double _compactBreakpoint = 760;

  @override
  Widget build(BuildContext context) {
    final user = snapshot.user;
    final vip = snapshot.vip;

    final identityBlock = Expanded(
      flex: 4,
      child: Row(
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
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  VitFormat.email(user.email),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text2,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tham gia từ ${user.joinDate}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          VitIconButton(
            key: ProfileTabletKeys.editProfile,
            icon: Icons.person_outline_rounded,
            tooltip: 'Chỉnh sửa hồ sơ',
            onPressed: onEdit,
            size: VitIconButtonSize.md,
          ),
        ],
      ),
    );
    final uidBlock = Expanded(
      flex: 2,
      child: _StripValueBlock(
        label: 'UID',
        value: user.id,
        valueStyle: AppTextStyles.control,
      ),
    );
    final referralBlock = Expanded(
      flex: 2,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          key: ProfileTabletKeys.copyReferral,
          onTap: onCopyReferral,
          borderRadius: AppRadii.cardRadius,
          child: _StripValueBlock(
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
    );
    final kycBlock = Expanded(
      flex: 2,
      child: _KycBlock(
        kycLevel: user.kycLevel,
        kycStatus: user.kycStatus,
        needsAction: user.kycNeedsAction,
        onVerify: onVerifyKyc,
      ),
    );
    final vipBlock = Expanded(
      flex: 3,
      child: _VipBlock(vip: vip, onTap: onVip),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _compactBreakpoint;
        final card = VitCard(
          key: ProfileTabletKeys.accountStrip,
          radius: VitCardRadius.large,
          clip: true,
          padding: ProfileSpacingTokens.profileHeroInfoPadding,
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          identityBlock,
                          const _StripDivider(),
                          uidBlock,
                          const _StripDivider(),
                          referralBlock,
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [kycBlock, const _StripDivider(), vipBlock],
                      ),
                    ),
                  ],
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      identityBlock,
                      const _StripDivider(),
                      uidBlock,
                      const _StripDivider(),
                      referralBlock,
                      const _StripDivider(),
                      kycBlock,
                      const _StripDivider(),
                      vipBlock,
                    ],
                  ),
                ),
        );
        return card;
      },
    );
  }
}

class _StripValueBlock extends StatelessWidget {
  const _StripValueBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.valueStyle,
    this.trailing,
  });

  final String label;
  final String value;
  final Color valueColor;
  final TextStyle? valueStyle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
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
                style: (valueStyle ?? AppTextStyles.base).copyWith(
                  color: valueColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.x1),
              trailing!,
            ],
          ],
        ),
      ],
    );
  }
}

/// KYC level pill plus, when verification is pending, the inline «Xác minh»
/// CTA (same key the old `ProfileKycBannerPanel` CTA carried).
class _KycBlock extends StatelessWidget {
  const _KycBlock({
    required this.kycLevel,
    required this.kycStatus,
    required this.needsAction,
    required this.onVerify,
  });

  final String kycLevel;
  final String kycStatus;
  final bool needsAction;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Trạng thái KYC',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            VitAccentPill(
              label: 'KYC $kycLevel',
              accentColor: needsAction ? AppColors.riskWarning : AppColors.buy,
            ),
            if (needsAction)
              VitCtaButton(
                key: ProfileTabletKeys.kycBanner,
                onPressed: onVerify,
                variant: VitCtaButtonVariant.primary,
                density: VitDensity.compact,
                height: AppSpacing.buttonCompact,
                fullWidth: false,
                child: const Text('Xác minh'),
              ),
          ],
        ),
        if (needsAction) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Nâng hạn mức giao dịch và rút tiền',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

/// VIP tier progress — the old secondary-column VIP card compressed into a
/// strip block (tier labels, progress bar, volume line).
class _VipBlock extends StatelessWidget {
  const _VipBlock({required this.vip, required this.onTap});

  final ProfileVipProgress vip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tiến độ VIP',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${vip.label} → ${vip.nextLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.badge.copyWith(color: AppColors.warn),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: LinearProgressIndicator(
                minHeight: ProfileSpacingTokens.profileVipProgressHeight,
                value: vip.progress,
                color: AppColors.primary,
                backgroundColor: AppColors.surface2,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              vip.volumeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _StripDivider extends StatelessWidget {
  const _StripDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      thickness: AppSpacing.dividerHairline,
      width: AppSpacing.x3 * 2 + AppSpacing.dividerHairline,
      color: AppColors.divider,
    );
  }
}
