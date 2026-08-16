part of '../../phone/pages/tools/launchpad_address_book_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      key: LaunchpadAddressBookPage.searchKey,
      controller: controller,
      placeholder: 'Tim dia chi, nhan, chain...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
      onClear: onClear,
    );
  }
}

class _ChainFilters extends StatelessWidget {
  const _ChainFilters({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            VitChoicePill(
              key: LaunchpadAddressBookPage.filterKey(filter),
              label: filter == 'all' ? 'Tat ca' : filter,
              selected: activeFilter == filter,
              onTap: () => onChanged(filter),
              accentColor: _chainColor(filter),
              padding: LaunchpadSpacingTokens.launchpadPillPadding,
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _AddressStats extends StatelessWidget {
  const _AddressStats({required this.addresses});

  final List<LaunchpadWalletAddressDraft> addresses;

  @override
  Widget build(BuildContext context) {
    final favorites = addresses.where((address) => address.isFavorite).length;
    final verified = addresses.where((address) => address.verified).length;
    return Row(
      key: LaunchpadAddressBookPage.statsKey,
      children: [
        _StatPill(
          icon: Icons.account_balance_wallet_outlined,
          value: '${addresses.length}',
          label: 'dia chi',
          color: AppModuleAccents.launchpad,
        ),
        const SizedBox(width: AppSpacing.x3),
        _StatPill(
          icon: Icons.star_rounded,
          value: '$favorites',
          label: 'yeu thich',
          color: AppColors.warn,
        ),
        const SizedBox(width: AppSpacing.x3),
        _StatPill(
          icon: Icons.verified_user_outlined,
          value: '$verified',
          label: 'xac minh',
          color: AppColors.buy,
        ),
      ],
    );
  }
}
