part of 'wallet_transfer_sections.dart';

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.asset, required this.size});

  final WalletTransferAsset asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return VitAssetAvatar(
      label: asset.symbol,
      accentColor: color,
      size: size,
      radius: AppRadii.avatarRadius,
    );
  }
}

class TransferAmountCard extends StatelessWidget {
  const TransferAmountCard({
    super.key,
    required this.controller,
    required this.asset,
    this.errorText,
    required this.onAssetTap,
    required this.onChanged,
    required this.onMax,
  });

  final TextEditingController controller;
  final WalletTransferAsset asset;
  final String? errorText;
  final VoidCallback onAssetTap;
  final VoidCallback onChanged;
  final VoidCallback onMax;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitInfoRow(
            key: const Key('sc146_transfer_asset'),
            label:
                '${asset.symbol} \u00b7 ${formatTransferAssetAmount(asset.available)} ${asset.symbol} kh\u1ea3 d\u1ee5ng',
            value: 'Ch\u1ecdn',
            density: VitDensity.compact,
            leading: _AssetLogo(asset: asset, size: _transferIconBox),
            trailing: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
              size: _transferActionIcon,
            ),
            onTap: onAssetTap,
          ),
          SizedBox(height: AppSurfaceSpacing.pageRhythmFormInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'S\u1ed1 l\u01b0\u1ee3ng',
                  style: AppTextStyles.badge.copyWith(color: AppColors.text3),
                ),
              ),
              VitChoicePill(
                key: const Key('sc146_transfer_max'),
                label: 'T\u1edbi \u0111a',
                selected: false,
                onTap: onMax,
                height: AppSurfaceSpacing.buttonCompact,
                accentColor: _transferPrimary,
              ),
            ],
          ),
          SizedBox(height: AppSurfaceSpacing.pageRhythmFormInnerGap),
          VitInput(
            fieldKey: const Key('sc146_transfer_amount'),
            controller: controller,
            semanticLabel: 'Số tiền chuyển nội bộ',
            hintText: '0.00',
            errorText: errorText,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: (_) => onChanged(),
            textStyle: AppTextStyles.amountSm,
            suffix: Text(
              asset.symbol,
              style: AppTextStyles.control.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferAmountEstimate extends StatelessWidget {
  const TransferAmountEstimate({super.key, required this.usdValue});

  final double usdValue;

  @override
  Widget build(BuildContext context) {
    return VitInfoRow(
      label: 'Gi\u00e1 tr\u1ecb \u01b0\u1edbc t\u00ednh',
      value: formatTransferUsd(usdValue),
      density: VitDensity.compact,
      leading: const Icon(Icons.payments_outlined),
    );
  }
}

class TransferInfoNotice extends StatelessWidget {
  const TransferInfoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      constraints: BoxConstraints(minHeight: AppSurfaceSpacing.inputHeight),
      density: VitDensity.compact,
      borderColor: _transferPrimary.withValues(alpha: .20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _transferPrimary,
            size: _transferActionIcon,
          ),
          SizedBox(width: _transferInlineGap),
          Expanded(
            child: Text(
              'Chuy\u1ec3n gi\u1eefa v\u00ed VitTrade x\u1eed l\u00fd n\u1ed9i b\u1ed9. Xem l\u1ea1i v\u00ed ngu\u1ed3n, v\u00ed nh\u1eadn, s\u1ed1 l\u01b0\u1ee3ng v\u00e0 ph\u00ed tr\u01b0\u1edbc khi x\u00e1c nh\u1eadn.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferValidationNotice extends StatelessWidget {
  const TransferValidationNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: AppColors.sell.withValues(alpha: .26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.sell,
            size: _transferActionIcon,
          ),
          SizedBox(width: _transferInlineGap),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.sell,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferButton extends StatelessWidget {
  const TransferButton({
    super.key,
    required this.enabled,
    required this.onTap,
    this.disabledReason,
  });

  final bool enabled;
  final VoidCallback? onTap;
  final String? disabledReason;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: enabled
          ? 'Xem trước chuyển khoản nội bộ'
          : 'Chuyển khoản nội bộ đã tắt. $disabledReason',
      child: Tooltip(
        message: disabledReason ?? 'Xem trước chuyển khoản nội bộ',
        child: VitCtaButton(
          onPressed: enabled ? onTap : null,
          height: AppSurfaceSpacing.inputHeight,
          child: Text(
            'X\u00e1c nh\u1eadn chuy\u1ec3n',
            style: AppTextStyles.control.copyWith(
              color: enabled ? AppColors.onAccent : AppColors.text3,
            ),
          ),
        ),
      ),
    );
  }
}
