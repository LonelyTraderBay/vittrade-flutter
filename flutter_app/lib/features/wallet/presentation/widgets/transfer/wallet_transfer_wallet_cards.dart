part of 'wallet_transfer_sections.dart';

class TransferDirectionCard extends StatelessWidget {
  const TransferDirectionCard({
    super.key,
    required this.fromKey,
    required this.toKey,
    required this.fromWallet,
    required this.toWallet,
    required this.onFromTap,
    required this.onToTap,
    required this.onSwap,
  });

  final Key fromKey;
  final Key toKey;
  final WalletTransferWallet fromWallet;
  final WalletTransferWallet toWallet;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _TransferEndpointTile(
            key: fromKey,
            label: 'Từ',
            wallet: fromWallet,
            color: _transferPrimary,
            onTap: onFromTap,
          ),
        ),
        SizedBox(width: AppSurfaceSpacing.x2),
        TransferSwapButton(onTap: onSwap),
        SizedBox(width: AppSurfaceSpacing.x2),
        Expanded(
          child: _TransferEndpointTile(
            key: toKey,
            label: 'Đến',
            wallet: toWallet,
            color: _transferGreen,
            onTap: onToTap,
          ),
        ),
      ],
    );
  }
}

class _TransferEndpointTile extends StatelessWidget {
  const _TransferEndpointTile({
    super.key,
    required this.label,
    required this.wallet,
    required this.color,
    required this.onTap,
  });

  final String label;
  final WalletTransferWallet wallet;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.standard,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.badge.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: _transferActionIcon,
              ),
            ],
          ),
          SizedBox(height: AppSurfaceSpacing.x1),
          Row(
            children: [
              _WalletIcon(wallet: wallet, color: color),
              SizedBox(width: AppSurfaceSpacing.x2),
              Expanded(
                child: Text(
                  wallet.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSurfaceSpacing.x1),
          Text(
            formatTransferUsd(wallet.balanceUsd),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _WalletIcon extends StatelessWidget {
  const _WalletIcon({required this.wallet, required this.color});

  final WalletTransferWallet wallet;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (wallet.iconKey) {
      'funding' => Icons.account_balance_wallet_outlined,
      'futures' => Icons.account_balance_outlined,
      _ => Icons.bar_chart_rounded,
    };
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: _transferIconBox,
      height: _transferIconBox,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      background: ColoredBox(color: color.withValues(alpha: .13)),
      alignment: Alignment.center,
      clip: true,
      child: Icon(icon, color: color, size: _transferActionIcon),
    );
  }
}

class TransferSwapButton extends StatelessWidget {
  const TransferSwapButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VitIconButton(
        key: const Key('sc146_transfer_swap'),
        icon: Icons.swap_vert_rounded,
        tooltip: 'Swap transfer wallets',
        onPressed: onTap,
        variant: VitIconButtonVariant.primary,
        size: VitIconButtonSize.md,
      ),
    );
  }
}
