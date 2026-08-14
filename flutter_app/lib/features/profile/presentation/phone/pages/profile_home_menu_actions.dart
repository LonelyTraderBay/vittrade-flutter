part of 'profile_page.dart';

List<Widget> _profilePageChildren({
  required BuildContext context,
  required ProfileSnapshot snapshot,
  required bool copiedReferral,
  required VoidCallback onEdit,
  required VoidCallback onCopyReferral,
  required VoidCallback onOpenVip,
  required VoidCallback onOpenPredictions,
  required VoidCallback onOpenArena,
  required VoidCallback onOpenActivity,
  required VoidCallback onLogout,
}) {
  return switch (snapshot.screenState) {
    ProfileScreenState.loading => [
      const VitSkeletonList(key: ProfilePage.loadingKey, rows: 4),
    ],
    ProfileScreenState.error => [
      VitErrorState(
        key: ProfilePage.errorKey,
        title: 'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c h\u1ED3 s\u01A1',
        message: 'Ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
        actionLabel: 'Th\u1EED l\u1EA1i',
        onAction: () => context.go(AppRoutePaths.profile),
      ),
    ],
    ProfileScreenState.empty => [
      const VitEmptyState(
        key: ProfilePage.emptyKey,
        title: 'Ch\u01B0a c\u00F3 d\u1EEF li\u1EC7u t\u00E0i kho\u1EA3n',
        message:
            'H\u1ED3 s\u01A1 s\u1EBD hi\u1EC3n th\u1ECB sau khi \u0111\u0103ng nh\u1EADp v\u00E0 \u0111\u1ED3ng b\u1ED9.',
        icon: Icons.account_circle_outlined,
      ),
    ],
    ProfileScreenState.offline => [
      const VitOfflineBanner(
        key: ProfilePage.offlineKey,
        message: '\u0110ang ngo\u1EA1i tuy\u1EBFn',
        detail:
            'Hi\u1EC3n th\u1ECB d\u1EEF li\u1EC7u t\u00E0i kho\u1EA3n \u0111\u00E3 l\u01B0u g\u1EA7n nh\u1EA5t.',
      ),
      ..._profileReadySections(
        context: context,
        snapshot: snapshot,
        copiedReferral: copiedReferral,
        onEdit: onEdit,
        onCopyReferral: onCopyReferral,
        onOpenVip: onOpenVip,
        onOpenPredictions: onOpenPredictions,
        onOpenArena: onOpenArena,
        onOpenActivity: onOpenActivity,
        onLogout: onLogout,
      ),
    ],
    _ => _profileReadySections(
      context: context,
      snapshot: snapshot,
      copiedReferral: copiedReferral,
      onEdit: onEdit,
      onCopyReferral: onCopyReferral,
      onOpenVip: onOpenVip,
      onOpenPredictions: onOpenPredictions,
      onOpenArena: onOpenArena,
      onOpenActivity: onOpenActivity,
      onLogout: onLogout,
    ),
  };
}

List<Widget> _profileReadySections({
  required BuildContext context,
  required ProfileSnapshot snapshot,
  required bool copiedReferral,
  required VoidCallback onEdit,
  required VoidCallback onCopyReferral,
  required VoidCallback onOpenVip,
  required VoidCallback onOpenPredictions,
  required VoidCallback onOpenArena,
  required VoidCallback onOpenActivity,
  required VoidCallback onLogout,
}) {
  return [
    _ProfileHero(
      user: snapshot.user,
      copiedReferral: copiedReferral,
      onEdit: onEdit,
      onCopyReferral: onCopyReferral,
    ),
    if (snapshot.user.kycNeedsAction)
      _KycUpgradeBanner(onVerify: () => context.go(AppRoutePaths.profileKyc)),
    _VipCard(vip: snapshot.vip, onTap: onOpenVip),
    const VitSectionHeader(
      title: 'D\u1EF1 \u0111o\u00E1n & Th\u00E1ch \u0111\u1EA5u',
      accentColor: _profilePurple,
      variant: VitSectionHeaderVariant.accentBar,
      density: VitDensity.compact,
      bottomGap: AppSpacing.pageRhythmCompactInnerGap,
    ),
    _PredictionCard(prediction: snapshot.prediction, onTap: onOpenPredictions),
    _ArenaCard(arena: snapshot.arena, onTap: onOpenArena),
    const VitSectionHeader(
      title: 'LỐI TẮT SẢN PHẨM',
      accentColor: _profileAmber,
      variant: VitSectionHeaderVariant.accentBar,
      density: VitDensity.compact,
      bottomGap: AppSpacing.pageRhythmCompactInnerGap,
    ),
    if (snapshot.productShortcuts.isEmpty)
      const VitEmptyState(
        title: 'Ch\u01B0a c\u00F3 s\u1EA3n ph\u1EA9m',
        message:
            'C\u00E1c shortcut s\u1EA3n ph\u1EA9m s\u1EBD hi\u1EC3n th\u1ECB khi kh\u1EA3 d\u1EE5ng.',
        icon: Icons.explore_outlined,
      )
    else
      _ProfileProductHub(shortcuts: snapshot.productShortcuts),
    if (snapshot.sections.isEmpty)
      const VitEmptyState(
        title: 'Ch\u01B0a c\u00F3 m\u1EE5c t\u00E0i kho\u1EA3n',
        message:
            'C\u00E1c c\u00E0i \u0111\u1EB7t profile s\u1EBD hi\u1EC3n th\u1ECB sau khi t\u1EA3i xong.',
        icon: Icons.account_circle_outlined,
      )
    else
      for (final section in snapshot.sections) ...[
        VitSectionHeader(
          title: section.label,
          accentColor: Color(section.accentHex),
          variant: VitSectionHeaderVariant.accentBar,
          density: VitDensity.compact,
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        if (section.id == 'legal')
          const _LegalAccordionSection()
        else
          _MenuSection(section: section),
      ],
    _ActivityButton(onTap: onOpenActivity),
    _LogoutButton(onTap: onLogout),
    Text(
      'VitTrade v2.4.1 \u2022 Tham gia t\u1EEB ${snapshot.user.joinDate}',
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(color: _profileMuted),
    ),
  ];
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.section});

  final ProfileMenuSection section;

  @override
  Widget build(BuildContext context) {
    final accent = Color(section.accentHex);
    return VitCard(
      borderColor: _profileBorder,
      clip: true,
      child: Column(
        children: [
          for (final item in section.items) ...[
            _MenuRow(item: item, accent: accent),
            if (item != section.items.last)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

/// D2: KYC upgrade banner above menu sections (row phụ vẫn ở Tài khoản).
class _KycUpgradeBanner extends StatelessWidget {
  const _KycUpgradeBanner({required this.onVerify});

  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      key: ProfilePage.kycBannerKey,
      variant: VitBannerVariant.warning,
      icon: Icons.verified_user_outlined,
      message: 'Hoàn tất KYC để nâng hạn mức giao dịch và rút tiền.',
      action: VitCtaButton(
        onPressed: onVerify,
        fullWidth: false,
        density: VitDensity.compact,
        height: AppSpacing.buttonCompact,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x4,
        ),
        child: const Text('Xác minh'),
      ),
    );
  }
}

class _ProfileProductHub extends StatelessWidget {
  const _ProfileProductHub({required this.shortcuts});

  final List<ProfileProductShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth -
                ProfileSpacingTokens.profileProductGridGap) /
            2;
        return Wrap(
          key: ProfilePage.productHubKey,
          spacing: ProfileSpacingTokens.profileProductGridGap,
          runSpacing: ProfileSpacingTokens.profileProductGridGap,
          children: [
            for (final shortcut in shortcuts)
              SizedBox(
                width: tileWidth,
                child: _ProfileProductTile(shortcut: shortcut),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileProductTile extends StatelessWidget {
  const _ProfileProductTile({required this.shortcut});

  final ProfileProductShortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final accent = Color(shortcut.accentHex);
    return VitCard(
      key: ProfilePage.productShortcutKey(shortcut.id),
      onTap: () => context.go(shortcut.route),
      density: VitDensity.compact,
      borderColor: accent.withValues(alpha: .22),
      child: VitIconListRow(
        gap: ProfileSpacingTokens.profileProductGap,
        leading: SizedBox(
          width: ProfileSpacingTokens.profileProductIconBox,
          height: ProfileSpacingTokens.profileProductIconBox,
          child: Material(
            color: accent.withValues(alpha: .12),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(
              profileIconFor(shortcut.iconKey),
              color: accent,
              size: ProfileSpacingTokens.profileProductIcon,
            ),
          ),
        ),
        title: Text(
          shortcut.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          shortcut.stateLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.badge.copyWith(color: accent),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item, required this.accent});

  final ProfileMenuItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: ProfilePage.menuKey(item.id),
        onTap: () => context.go(item.route),
        child: VitIconListRow(
          minHeight: VitDensity.standard.controlHeight,
          padding: ProfileSpacingTokens.profileMenuRowPadding,
          gap: ProfileSpacingTokens.profileMenuGap,
          subtitleGap: AppSpacing.pageRhythmCompactInnerGap,
          leading: SizedBox(
            width: ProfileSpacingTokens.profileMenuIconBox,
            height: ProfileSpacingTokens.profileMenuIconBox,
            child: Material(
              color: accent.withValues(alpha: .12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
              ),
              child: Icon(
                profileIconFor(item.iconKey),
                color: accent,
                size: ProfileSpacingTokens.profileMenuIcon,
              ),
            ),
          ),
          title: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          subtitle: item.subtitle == null
              ? null
              : Text(
                  item.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: item.subtitleHex == null
                        ? _profileMuted
                        : Color(item.subtitleHex!),
                  ),
                ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: _profileMuted,
            size: ProfileSpacingTokens.profileMenuChevron,
          ),
        ),
      ),
    );
  }
}

class _ActivityButton extends StatelessWidget {
  const _ActivityButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: _profileBorder,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight,
        ),
        child: Center(
          child: Text(
            'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
            style: AppTextStyles.control.copyWith(color: AppColors.text2),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfilePage.logoutKey,
      onTap: onTap,
      density: VitDensity.compact,
      alignment: Alignment.center,
      borderColor: _profileRed.withValues(alpha: .28),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: VitDensity.compact.controlHeight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: _profileRed,
              size: ProfileSpacingTokens.profileLogoutIcon,
            ),
            const SizedBox(width: ProfileSpacingTokens.profileLogoutGap),
            Text(
              '\u0110\u0103ng xu\u1EA5t',
              style: AppTextStyles.baseMedium.copyWith(
                color: _profileRed,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
