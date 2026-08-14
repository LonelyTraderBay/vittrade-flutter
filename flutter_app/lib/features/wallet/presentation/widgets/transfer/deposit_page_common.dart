part of '../../phone/pages/deposit_page.dart';

class _DepositInfoCard extends StatelessWidget {
  const _DepositInfoCard({required this.asset, required this.network});

  final String asset;
  final WalletDepositNetwork network;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Thời gian xử lý', network.arrivalTime),
      ('Xác nhận cần thiết', '${network.confirmations} blocks'),
      ('Phí nạp', network.fee),
      ('Nạp tối thiểu', '${_formatDeposit(network.minDeposit)} $asset'),
      ('Nạp nhỏ hơn tối thiểu', 'Không được ghi nhận'),
    ];

    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thông tin nạp tiền',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: _depositGap),
          for (var i = 0; i < rows.length; i++) ...[
            VitInfoRow(
              label: rows[i].$1,
              value: rows[i].$2,
              density: VitDensity.compact,
              showDivider: i != rows.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Làm mới địa chỉ nạp',
      child: VitChoicePill(
        key: DepositPage.refreshKey,
        onTap: onTap,
        label: 'Làm mới địa chỉ nạp',
        selected: false,
        fullWidth: true,
        accentColor: _depositPrimary,
        leading: const Icon(Icons.refresh_rounded),
        semanticLabel: 'Làm mới địa chỉ nạp',
      ),
    );
  }
}

class _NetworkOption extends StatelessWidget {
  const _NetworkOption({
    required this.network,
    required this.selected,
    required this.onTap,
  });

  final WalletDepositNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: network.name,
      child: VitCard(
        key: DepositPage.networkKey(network.id),
        onTap: onTap,
        variant: VitCardVariant.inner,
        density: VitDensity.compact,
        borderColor: selected ? _depositPrimary : AppColors.border,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    network.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: _depositTinyGap),
                  Text(
                    'Phí: ${network.fee} · ${network.arrivalTime} · ${network.confirmations} xác nhận',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: _depositPrimary,
                size: AppSpacing.iconSm,
              ),
          ],
        ),
      ),
    );
  }
}

String _formatDeposit(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}

String _maskDepositAddress(String address) => maskAddress(address);
