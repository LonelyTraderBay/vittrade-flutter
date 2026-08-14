part of '../../phone/pages/address_book_page.dart';

class _WhitelistModeCard extends StatelessWidget {
  const _WhitelistModeCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: enabled,
      label: 'Bật/tắt chế độ danh sách trắng địa chỉ',
      child: VitCard(
        key: AddressBookPage.whitelistModeKey,
        onTap: onTap,
        density: VitDensity.compact,
        borderColor: AppColors.overlayStroke,
        child: Row(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: enabled
                    ? AppColors.buy.withValues(alpha: .12)
                    : AppColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                  side: BorderSide(
                    color: enabled ? AppColors.buy20 : AppColors.borderSolid,
                  ),
                ),
              ),
              child: SizedBox(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: enabled ? AppColors.buy : AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ),
            ),
            const SizedBox(width: WalletSpacingTokens.walletAddressActionGap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chế độ danh sách trắng',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    height: WalletSpacingTokens.walletAddressCompactGap,
                  ),
                  Text(
                    enabled
                        ? 'Chỉ rút tới địa chỉ danh sách trắng'
                        : 'Cho phép rút tới mọi địa chỉ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            VitTogglePill(enabled: enabled, activeColor: AppColors.buy),
          ],
        ),
      ),
    );
  }
}

class _SecurityTip extends StatelessWidget {
  const _SecurityTip();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.primary15,
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.45,
          ),
          children: [
            TextSpan(
              text: 'Bảo mật: ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const TextSpan(
              text:
                  'Địa chỉ danh sách trắng được bảo vệ bởi 2FA. Chỉ có thể rút tới địa chỉ đã được xác minh.',
            ),
          ],
        ),
      ),
    );
  }
}
