part of '../../phone/pages/tools/launchpad_address_book_page.dart';

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.expanded,
    required this.copied,
    required this.onCopy,
    required this.onFavorite,
    required this.onDefault,
    required this.onExpand,
  });

  final LaunchpadWalletAddressDraft address;
  final bool expanded;
  final bool copied;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;
  final VoidCallback onDefault;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadAddressBookPage.cardKey(address.id),
      borderColor: address.isDefault
          ? address.accent.resolve().withValues(alpha: .42)
          : null,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          VitCard(
            key: LaunchpadAddressBookPage.expandKey(address.id),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: LaunchpadSpacingTokens.launchpadPaddingX4,
            onTap: onExpand,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ChainIcon(address: address),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address.label,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.heavy,
                              ),
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: AppSpacing.x2),
                            const _Badge(
                              label: 'MAC DINH',
                              color: AppModuleAccents.launchpad,
                            ),
                          ],
                          if (address.verified) ...[
                            const SizedBox(width: AppSpacing.x1),
                            const Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.buy,
                              size: LaunchpadSpacingTokens.launchpadIconMd,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        address.maskedAddress,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Wrap(
                        spacing: AppSpacing.x1,
                        runSpacing: AppSpacing.x1,
                        children: [
                          _Badge(
                            label: address.chain,
                            color: address.accent.resolve(),
                          ),
                          for (final tag in address.tags.take(2))
                            _Badge(label: tag, color: AppColors.text3),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    VitIconButton(
                      key: LaunchpadAddressBookPage.favoriteKey(address.id),
                      icon: address.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      tooltip: 'Favorite address',
                      onPressed: onFavorite,
                      variant: address.isFavorite
                          ? VitIconButtonVariant.defaultAction
                          : VitIconButtonVariant.transparent,
                      size: VitIconButtonSize.sm,
                    ),
                    VitIconButton(
                      key: LaunchpadAddressBookPage.copyKey(address.id),
                      icon: copied ? Icons.check_rounded : Icons.copy_rounded,
                      tooltip: 'Copy address',
                      onPressed: onCopy,
                      variant: copied
                          ? VitIconButtonVariant.success
                          : VitIconButtonVariant.transparent,
                      size: VitIconButtonSize.sm,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (expanded)
            _ExpandedAddress(address: address, onDefault: onDefault),
        ],
      ),
    );
  }
}

class _ExpandedAddress extends StatelessWidget {
  const _ExpandedAddress({required this.address, required this.onDefault});

  final LaunchpadWalletAddressDraft address;
  final VoidCallback onDefault;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: LaunchpadSpacingTokens.launchpadDividerWidth,
            thickness: LaunchpadSpacingTokens.launchpadDividerWidth,
            color: AppColors.divider,
          ),
          Padding(
            padding: LaunchpadSpacingTokens.launchpadPaddingX4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                  child: Padding(
                    padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                    child: Text(
                      address.address,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text1,
                        height: LaunchpadSpacingTokens.launchpadLineHeightShort,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitKeyValueRow(
                  label: 'Chain',
                  value: address.chain,
                  padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
                  labelStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                  valueStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                if (address.lastUsed != null)
                  VitKeyValueRow(
                    label: 'Lan dung gan nhat',
                    value: address.lastUsed!,
                    padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
                    labelStyle: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                    ),
                    valueStyle: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                VitKeyValueRow(
                  label: 'So lan su dung',
                  value: '${address.usageCount} lan',
                  padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
                  labelStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                  valueStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                VitKeyValueRow(
                  label: 'Ngay them',
                  value: address.createdAt,
                  padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
                  labelStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                  valueStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                VitKeyValueRow(
                  label: 'Trang thai',
                  value: address.verified ? 'Da xac minh' : 'Chua xac minh',
                  padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
                  labelStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                  valueStyle: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                if (address.notes != null) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    address.notes!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: LaunchpadSpacingTokens.launchpadLineHeightMicro,
                    ),
                  ),
                ],
                if (!address.isDefault) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitCtaButton(
                    key: LaunchpadAddressBookPage.defaultKey(address.id),
                    onPressed: onDefault,
                    variant: VitCtaButtonVariant.secondary,
                    height: LaunchpadSpacingTokens.launchpadBox42,
                    leading: const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.text1,
                      size: LaunchpadSpacingTokens.launchpadIconXl,
                    ),
                    child: const Text('Dat lam mac dinh'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
