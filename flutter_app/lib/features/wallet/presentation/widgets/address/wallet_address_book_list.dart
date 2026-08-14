part of '../../phone/pages/address_book_page.dart';

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.copied,
    required this.onCopy,
    required this.onFavorite,
    required this.onEdit,
    required this.onDelete,
  });

  final WalletSavedAddress address;
  final bool copied;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.overlayStroke,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShieldBadge(whitelisted: address.isWhitelisted),
              const SizedBox(width: WalletSpacingTokens.walletAddressActionGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            address.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (address.isWhitelisted) ...[
                          const SizedBox(
                            width: WalletSpacingTokens.walletAddressCompactGap,
                          ),
                          const _WhitelistBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: WalletSpacingTokens.walletAddressCompactGap,
                    ),
                    Wrap(
                      spacing: WalletSpacingTokens.walletAddressCompactGap,
                      runSpacing: WalletSpacingTokens.walletAddressCompactGap,
                      children: [
                        _MiniTag(address.network),
                        _MiniTag(address.asset),
                      ],
                    ),
                    const SizedBox(
                      height: WalletSpacingTokens.walletAddressCompactGap,
                    ),
                    Text(
                      _maskAddress(address.address),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (address.lastUsed != null) ...[
                      const SizedBox(
                        height: WalletSpacingTokens.walletAddressCompactGap,
                      ),
                      Text(
                        'D\u00F9ng g\u1EA7n nh\u1EA5t: ${address.lastUsed}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: WalletSpacingTokens.walletAddressActionGap),
          Row(
            children: [
              Expanded(
                child: _CopyButton(
                  copied: copied,
                  onTap: onCopy,
                  addressId: address.id,
                ),
              ),
              const SizedBox(
                width: WalletSpacingTokens.walletAddressCompactGap,
              ),
              _RoundActionButton(
                key: AddressBookPage.favoriteKey(address.id),
                icon: address.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                tooltip: 'Y\u00EAu th\u00EDch \u0111\u1ECBa ch\u1EC9',
                filled: address.isFavorite,
                onTap: onFavorite,
              ),
              const SizedBox(
                width: WalletSpacingTokens.walletAddressCompactGap,
              ),
              _RoundActionButton(
                key: AddressBookPage.editKey(address.id),
                icon: Icons.edit_rounded,
                tooltip: 'S\u1EEDa \u0111\u1ECBa ch\u1EC9',
                onTap: onEdit,
              ),
              const SizedBox(
                width: WalletSpacingTokens.walletAddressCompactGap,
              ),
              _RoundActionButton(
                key: AddressBookPage.deleteKey(address.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'X\u00F3a \u0111\u1ECBa ch\u1EC9',
                danger: true,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShieldBadge extends StatelessWidget {
  const _ShieldBadge({required this.whitelisted});

  final bool whitelisted;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      alignment: Alignment.center,
      child: Icon(
        Icons.shield_outlined,
        color: whitelisted ? AppColors.buy : AppColors.text3,
        size: AppSpacing.iconSm,
      ),
    );
  }
}

class _WhitelistBadge extends StatelessWidget {
  const _WhitelistBadge();

  @override
  Widget build(BuildContext context) {
    return const VitStatusPill(
      label: 'Danh sách trắng',
      icon: Icons.check_rounded,
      status: VitStatusPillStatus.success,
      size: VitStatusPillSize.sm,
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: VitStatusPillStatus.neutral,
      size: VitStatusPillSize.sm,
      outline: true,
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.copied,
    required this.onTap,
    required this.addressId,
  });

  final bool copied;
  final VoidCallback onTap;
  final String addressId;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: copied ? 'Đã sao chép địa chỉ' : 'Sao chép địa chỉ ví đã ẩn',
      child: VitChoicePill(
        key: AddressBookPage.copyKey(addressId),
        label: copied ? '\u0110\u00E3 copy' : 'Sao ch\u00E9p',
        selected: copied,
        onTap: onTap,
        height: WalletSpacingTokens.walletAddressCopyHeight,
        fullWidth: true,
        accentColor: AppColors.primary,
        leading: Icon(
          copied ? Icons.check_circle_outline_rounded : Icons.copy_rounded,
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.filled = false,
    this.danger = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool filled;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onTap,
      size: VitIconButtonSize.md,
      variant: danger
          ? VitIconButtonVariant.danger
          : filled
          ? VitIconButtonVariant.primary
          : VitIconButtonVariant.ghost,
    );
  }
}

class _EmptyAddressState extends StatelessWidget {
  const _EmptyAddressState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: 'Kh\u00F4ng t\u00ECm th\u1EA5y \u0111\u1ECBa ch\u1EC9',
      message:
          'Th\u00EAm \u0111\u1ECBa ch\u1EC9 \u0111\u00E3 x\u00E1c minh \u0111\u1EC3 r\u00FAt ti\u1EC1n nhanh h\u01A1n.',
      icon: Icons.shield_outlined,
      actionLabel: 'Th\u00EAm \u0111\u1ECBa ch\u1EC9',
      onAction: onAdd,
    );
  }
}
