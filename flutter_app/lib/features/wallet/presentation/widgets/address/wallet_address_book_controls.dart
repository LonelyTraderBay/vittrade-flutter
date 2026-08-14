part of '../../phone/pages/address_book_page.dart';

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      fieldKey: AddressBookPage.searchKey,
      controller: controller,
      placeholder: 'Tìm địa chỉ hoặc tên...',
      variant: VitSearchBarVariant.compact,
      onChanged: (_) => onChanged(),
    );
  }
}

class _NetworkFilterBar extends StatelessWidget {
  const _NetworkFilterBar({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<String> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WalletSpacingTokens.walletAddressFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter == active;
          return VitChoicePill(
            key: AddressBookPage.filterKey(filter),
            label: filter,
            selected: selected,
            onTap: () => onChanged(filter),
            height: WalletSpacingTokens.walletAddressFilterHeight,
            padding: WalletSpacingTokens.walletAddressFilterPadding,
            accentColor: AppColors.primary,
          );
        },
        separatorBuilder: (_, _) =>
            const SizedBox(width: WalletSpacingTokens.walletAddressStatsGap),
        itemCount: filters.length,
      ),
    );
  }
}

class _AddressStats extends StatelessWidget {
  const _AddressStats({required this.addresses});

  final List<WalletSavedAddress> addresses;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (addresses.length.toString(), 'Tổng địa chỉ', AppColors.primary),
      (
        addresses.where((address) => address.isFavorite).length.toString(),
        'Yêu thích',
        AppColors.caution,
      ),
      (
        addresses.where((address) => address.isWhitelisted).length.toString(),
        'Danh sách trắng',
        AppColors.buy,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              borderColor: AppColors.overlayStroke,
              density: VitDensity.compact,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: stats[i].$3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(
                    height: WalletSpacingTokens.walletAddressCompactGap,
                  ),
                  Text(
                    stats[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1)
            const SizedBox(width: WalletSpacingTokens.walletAddressStatsGap),
        ],
      ],
    );
  }
}
