// Phone-specific wallet overview section.
part of 'wallet_page_sections.dart';

const double _walletAssetSectionGap = AppSpacing.x2;
const double _walletAssetHeaderButtonHeight =
    AppSpacing.searchBarCompactHeight - AppSpacing.x2;
const double _walletAssetAvatarCompactSize = AppSpacing.x6 - AppSpacing.x1;
const double _walletAssetRowGap = AppSpacing.x3;
const double _walletAssetTextGap = AppSpacing.x1;
const double _walletAssetChevronGap = AppSpacing.x2;
const double _walletAssetChevronSize = AppSpacing.iconMd - AppSpacing.x1;

class WalletSegmentedTabs extends StatelessWidget {
  const WalletSegmentedTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      VitTabItem(key: 'assets', label: 'Danh s\u00E1ch'),
      VitTabItem(key: 'chart', label: 'Ph\u00E2n b\u1ED5'),
    ];

    return Stack(
      children: [
        VitTabBar(
          tabs: tabs,
          activeKey: active,
          onChanged: onChanged,
          variant: VitTabBarVariant.segment,
        ),
        Positioned.fill(
          child: Row(
            children: [
              for (final tab in tabs)
                Expanded(
                  child: VitCard(
                    key: Key('sc135_wallet_tab_${tab.key}'),
                    variant: VitCardVariant.ghost,
                    borderColor: AppColors.transparent,
                    onTap: () => onChanged(tab.key),
                    child: const SizedBox.expand(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class WalletAssetSection extends StatelessWidget {
  const WalletAssetSection({
    super.key,
    required this.controller,
    required this.filterActive,
    required this.count,
    required this.assets,
    required this.hidden,
    required this.onChanged,
    required this.onFilter,
    required this.onNavigate,
  });

  final TextEditingController controller;
  final bool filterActive;
  final int count;
  final List<WalletAsset> assets;
  final bool hidden;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WalletSearchAndFilter(
          controller: controller,
          filterActive: filterActive,
          onChanged: onChanged,
          onFilter: onFilter,
        ),
        const SizedBox(height: _walletAssetSectionGap),
        WalletAssetHeader(count: count, onNavigate: onNavigate),
        const SizedBox(height: _walletAssetSectionGap),
        WalletAssetList(assets: assets, hidden: hidden, onNavigate: onNavigate),
      ],
    );
  }
}

class WalletSearchAndFilter extends StatelessWidget {
  const WalletSearchAndFilter({
    super.key,
    required this.controller,
    required this.filterActive,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final bool filterActive;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      fieldKey: const Key('sc135_wallet_search'),
      filterKey: const Key('sc135_wallet_filter'),
      controller: controller,
      placeholder: 'T\u00ECm t\u00E0i s\u1EA3n...',
      variant: VitSearchBarVariant.compact,
      filterActive: filterActive,
      onChanged: onChanged,
      onFilterTap: onFilter,
    );
  }
}

class WalletAssetHeader extends StatelessWidget {
  const WalletAssetHeader({
    super.key,
    required this.count,
    required this.onNavigate,
  });

  final int count;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count t\u00E0i s\u1EA3n',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        VitCtaButton(
          height: _walletAssetHeaderButtonHeight,
          density: VitDensity.compact,
          variant: VitCtaButtonVariant.ghost,
          fullWidth: false,
          padding: WalletSpacingTokens.walletAddressFilterPadding,
          onPressed: () => onNavigate('/wallet/address-book'),
          child: const Text('S\u1ED5 \u0111\u1ECBa ch\u1EC9'),
        ),
      ],
    );
  }
}

class WalletAssetList extends StatelessWidget {
  const WalletAssetList({
    super.key,
    required this.assets,
    required this.hidden,
    required this.onNavigate,
  });

  final List<WalletAsset> assets;
  final bool hidden;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return VitCard(
        alignment: Alignment.center,
        variant: VitCardVariant.standard,
        padding: VitDensity.compact.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VitEmptyState(
              title: 'Ch\u01B0a c\u00F3 t\u00E0i s\u1EA3n',
              message:
                  'N\u1EA1p ho\u1EB7c mua crypto \u0111\u1EC3 b\u1EAFt \u0111\u1EA7u qu\u1EA3n l\u00FD danh m\u1EE5c.',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    density: VitDensity.compact,
                    onPressed: () => onNavigate('/wallet/deposit/USDT'),
                    leading: const Icon(Icons.file_download_outlined),
                    child: const Text('N\u1EA1p ti\u1EC1n'),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: VitCtaButton(
                    density: VitDensity.compact,
                    variant: VitCtaButtonVariant.secondary,
                    onPressed: () => onNavigate('/wallet/buy-crypto'),
                    leading: const Icon(Icons.shopping_cart_outlined),
                    child: const Text('Mua crypto'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return VitCard(
      variant: VitCardVariant.standard,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < assets.length; i++)
            _AssetRow(
              asset: assets[i],
              hidden: hidden,
              last: i == assets.length - 1,
              onTap: () => onNavigate('/wallet/asset/${assets[i].id}'),
            ),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.hidden,
    required this.last,
    required this.onTap,
  });

  final WalletAsset asset;
  final bool hidden;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);

    return VitCard(
      key: Key('sc135_wallet_asset_${asset.id}'),
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: VitDensity.compact.cardPadding,
            child: Row(
              children: [
                VitAssetAvatar(
                  label: asset.symbol,
                  accentColor: color,
                  size: _walletAssetAvatarCompactSize,
                  radius: AppRadii.pillRadius,
                  border: true,
                ),
                const SizedBox(width: _walletAssetRowGap),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.symbol,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: _walletAssetTextGap),
                      Text(
                        asset.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hidden
                          ? '\u2022\u2022\u2022\u2022'
                          : _formatAssetAmount(asset.balance),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: _walletAssetTextGap),
                    Text(
                      hidden
                          ? '\u2022\u2022\u2022\u2022'
                          : '\u2248 ${_formatUsd(asset.usdValue)}',
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: _walletAssetChevronGap),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: _walletAssetChevronSize,
                ),
              ],
            ),
          ),
          if (!last)
            const Divider(
              height: WalletSpacingTokens.walletHistoryDividerHeight,
              thickness: WalletSpacingTokens.walletHistoryDividerHeight,
              color: AppColors.cardBorder,
            ),
        ],
      ),
    );
  }
}
