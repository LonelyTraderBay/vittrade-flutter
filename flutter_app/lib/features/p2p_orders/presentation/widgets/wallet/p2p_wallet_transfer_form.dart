part of '../../phone/pages/wallet/p2p_wallet_transfer_page.dart';

class _TransferForm extends StatelessWidget {
  const _TransferForm({
    required this.snapshot,
    required this.source,
    required this.destination,
    required this.type,
    required this.asset,
    required this.amountController,
    required this.amount,
    required this.canTransfer,
    required this.onSwitch,
    required this.onAssetChanged,
    required this.onMax,
    required this.onPercent,
    required this.onAmountChanged,
    required this.onSubmit,
  });

  final P2PWalletTransferSnapshot snapshot;
  final P2PWalletTransferBalanceDraft source;
  final P2PWalletTransferBalanceDraft destination;
  final String type;
  final String asset;
  final TextEditingController amountController;
  final double amount;
  final bool canTransfer;
  final VoidCallback onSwitch;
  final ValueChanged<String> onAssetChanged;
  final VoidCallback onMax;
  final ValueChanged<int> onPercent;
  final VoidCallback onAmountChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DirectionCard(
          source: source,
          destination: destination,
          onSwitch: onSwitch,
        ),
        _AssetSelection(
          assets: snapshot.assets,
          selectedAsset: asset,
          onChanged: onAssetChanged,
        ),
        _AmountInput(
          controller: amountController,
          asset: asset,
          insufficient: amount > source.available,
          onChanged: onAmountChanged,
          onMax: onMax,
        ),
        VitPresetChipRow.percentBalance(
          onTap: onPercent,
          keyFor: P2PWalletTransferPage.percentKey,
          accentColor: AppModuleAccents.p2p,
          height: AppSpacing.buttonCompact,
          padding: P2PSpacingTokens.p2pWalletTransferPercentPadding,
        ),
        P2PNoticeCard(
          key: P2PWalletTransferPage.feeKey,
          icon: Icons.bolt_rounded,
          title: 'Miễn phí & Tức thì',
          message:
              'Chuyển tiền nội bộ hoàn toàn miễn phí và được xử lý ngay lập tức.',
          iconColor: AppColors.buy,
          titleColor: AppColors.buy,
          borderColor: AppColors.buy.withValues(alpha: .30),
          padding: P2PSpacingTokens.p2pWalletCompactCardPadding,
        ),
        P2PNoticeCard(
          key: P2PWalletTransferPage.escrowNoteKey,
          icon: Icons.info_outline_rounded,
          message: snapshot.escrowNote,
          borderColor: AppModuleAccents.p2p.withValues(alpha: .32),
          padding: P2PSpacingTokens.p2pWalletCompactCardPadding,
        ),
        _SubmitButton(
          enabled: canTransfer,
          label: amount > 0
              ? 'Chuyển ${_formatTransferAmount(amount, asset)} $asset'
              : 'Chuyển $asset',
          onTap: onSubmit,
        ),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Xem lại chuyển tiền P2P',
          message:
              'Nguồn, đích, tài sản, số tiền, phí, ghi chú escrow và trạng thái xử lý được xem lại trước khi chuyển.',
          contractId: 'SC-261',
          density: VitDensity.compact,
        ),
      ],
    );
  }
}

class _DirectionCard extends StatelessWidget {
  const _DirectionCard({
    required this.source,
    required this.destination,
    required this.onSwitch,
  });

  final P2PWalletTransferBalanceDraft source;
  final P2PWalletTransferBalanceDraft destination;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PWalletTransferPage.directionKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pWalletTransferCardPadding,
      child: Row(
        children: [
          Expanded(
            child: _WalletSide(label: 'Từ', balance: source),
          ),
          Padding(
            padding: P2PSpacingTokens.p2pWalletTransferDirectionSwitchPadding,
            child: Material(
              key: P2PWalletTransferPage.switchKey,
              color: AppModuleAccents.p2p.withValues(alpha: .16),
              shape: const CircleBorder(),
              child: SizedBox.square(
                dimension: _p2pTransferSwitchSize,
                child: Center(
                  child: VitInlineIconAction(
                    icon: Icons.swap_horiz_rounded,
                    tooltip: 'Đổi chiều chuyển ví',
                    onPressed: onSwitch,
                    color: AppModuleAccents.p2p,
                    borderRadius: AppRadii.pillRadius,
                    padding: AppSpacing.x2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _WalletSide(label: 'Đến', balance: destination),
          ),
        ],
      ),
    );
  }
}

class _WalletSide extends StatelessWidget {
  const _WalletSide({required this.label, required this.balance});

  final String label;
  final P2PWalletTransferBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    final color = balance.walletKey == 'p2p'
        ? AppColors.warn
        : AppModuleAccents.p2p;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            Icon(_walletIcon(balance.walletKey), color: color, size: 17),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                balance.walletLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.control.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          [
            balance.balanceLabel,
            ': ',
            _formatAvailable(balance.available, balance.asset),
            ' ',
            balance.asset,
          ].join(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AssetSelection extends StatelessWidget {
  const _AssetSelection({
    required this.assets,
    required this.selectedAsset,
    required this.onChanged,
  });

  final List<P2PWalletTransferAssetDraft> assets;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletTransferPage.assetSelectorKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Chọn tài sản',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          icon: Icons.account_balance_wallet_outlined,
          accentColor: AppModuleAccents.p2p,
          density: VitDensity.compact,
        ),
        const SizedBox(height: _p2pTransferTightGap),
        Row(
          children: [
            for (var index = 0; index < assets.length; index++) ...[
              Expanded(
                child: _AssetTile(
                  asset: assets[index],
                  selected: selectedAsset == assets[index].symbol,
                  onTap: () => onChanged(assets[index].symbol),
                ),
              ),
              if (index != assets.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final P2PWalletTransferAssetDraft asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(asset.symbol);
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: P2PWalletTransferPage.assetKey(asset.symbol),
      radius: VitCardRadius.standard,
      variant: VitCardVariant.inner,
      borderColor: selected ? color : AppColors.cardBorder,
      background: ColoredBox(
        color: selected
            ? color.withValues(alpha: .11)
            : AppColors.surface.withValues(alpha: .50),
      ),
      constraints: const BoxConstraints(
        minHeight: _p2pTransferAssetTileMinHeight,
      ),
      padding: P2PSpacingTokens.p2pWalletTransferAssetChipPadding,
      clip: true,
      onTap: onTap,
      child: Column(
        key: selected
            ? P2PWalletTransferPage.activeAssetKey(asset.symbol)
            : null,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AssetMark(symbol: asset.symbol, color: color),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            asset.symbol,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: selected ? color : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (symbol) {
      'BTC' => Icons.currency_bitcoin_rounded,
      'VND' => Icons.money_rounded,
      _ => Icons.attach_money_rounded,
    };
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.smRadius,
      child: SizedBox(
        width: _p2pTransferAssetMarkSize,
        height: _p2pTransferAssetMarkSize,
        child: Icon(icon, color: color, size: _p2pTransferAssetIcon),
      ),
    );
  }
}
