part of '../../phone/pages/tools/launchpad_address_book_page.dart';

class _AddAddressSheet extends StatelessWidget {
  const _AddAddressSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadAddressBookPage.addSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LaunchpadSpacingTokens.launchpadSheetMaxWidth,
          ),
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.sheetTopLargeRadius,
              ),
            ),
            child: Padding(
              padding: LaunchpadSpacingTokens.launchpadPaddingX5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: SizedBox(
                      width: LaunchpadSpacingTokens.launchpadBox44,
                      height: AppSpacing.x1,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: AppColors.borderSolid,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.xlRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
                  Text(
                    'Them dia chi moi',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    'Address mutation se can KYC submission-step va preview confirm truoc khi ghi len backend.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    key: LaunchpadAddressBookPage.addSheetCloseKey,
                    onPressed: onClose,
                    leading: const Icon(
                      Icons.close_rounded,
                      color: AppColors.onAccent,
                    ),
                    child: const Text('Dong'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCardStat(
        padding: LaunchpadSpacingTokens.launchpadInlinePillPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: LaunchpadSpacingTokens.launchpadIconMd,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.heavy,
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainIcon extends StatelessWidget {
  const _ChainIcon({required this.address});

  final LaunchpadWalletAddressDraft address;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: LaunchpadSpacingTokens.launchpadBox44,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: address.accent.resolve().withValues(alpha: .16),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.lgRadius,
            side: BorderSide(
              color: address.accent.resolve().withValues(alpha: .28),
            ),
          ),
        ),
        child: Center(
          child: Icon(
            _chainIcon(address.iconKey),
            color: address.accent.resolve(),
            size: LaunchpadSpacingTokens.launchpadIcon3xl,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadLiveBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
      ),
    );
  }
}

Color _chainColor(String chain) {
  return switch (chain) {
    'BSC' => AppColors.warn,
    'Polygon' => AppColors.accent,
    'Arbitrum' => AppColors.primary,
    _ => AppModuleAccents.launchpad,
  };
}

IconData _chainIcon(String iconKey) {
  return switch (iconKey) {
    'bsc' => Icons.hexagon_outlined,
    'polygon' => Icons.hive_outlined,
    'arbitrum' => Icons.change_circle_outlined,
    _ => Icons.account_balance_wallet_outlined,
  };
}
