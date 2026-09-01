part of 'wallet_transfer_sections.dart';

class TransferConfirmSheet extends StatelessWidget {
  const TransferConfirmSheet({
    super.key,
    required this.fromWallet,
    required this.toWallet,
    required this.asset,
    required this.amount,
    required this.usdValue,
    required this.onConfirm,
  });

  final WalletTransferWallet fromWallet;
  final WalletTransferWallet toWallet;
  final WalletTransferAsset asset;
  final double amount;
  final double usdValue;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    // Confirm sheets prefer calmer density than the compact form (craft #6).
    const confirmDensity = VitDensity.standard;
    final amountLabel = '${formatTransferAssetAmount(amount)} ${asset.symbol}';

    return VitSheetPanel(
      title: 'Xác nhận chuyển nội bộ',
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSurfaceSpacing.x4,
              vertical: AppSurfaceSpacing.x3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Số lượng',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
                Flexible(
                  child: Semantics(
                    label: 'Số tiền chuyển $amountLabel',
                    child: Text(
                      amountLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.amountSm.copyWith(
                        color: _transferPrimary,
                        fontFeatures: AppTextStyles.tabularFigures,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: AppSurfaceSpacing.dividerHairline,
            thickness: AppSurfaceSpacing.dividerHairline,
            color: AppColors.border,
          ),
          VitInfoRow(
            label: 'Từ',
            value: fromWallet.name,
            density: confirmDensity,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Đến',
            value: toWallet.name,
            density: confirmDensity,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Tài sản',
            value: asset.symbol,
            density: confirmDensity,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Giá trị',
            value: formatTransferUsd(usdValue),
            density: confirmDensity,
            showDivider: true,
          ),
          const VitInfoRow(
            label: 'Phí',
            value: 'Miễn phí',
            valueColor: _transferGreen,
            density: confirmDensity,
          ),
          SizedBox(height: AppSurfaceSpacing.pageRhythmFormInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            density: confirmDensity,
            borderColor: _transferPrimary.withValues(alpha: .20),
            child: Text(
              'Không hoàn tác sau khi xác nhận. Bước tiếp theo: hệ thống ghi nhận lệnh chuyển nội bộ giữa các ví VitTrade.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          SizedBox(height: AppSurfaceSpacing.pageRhythmFormInnerGap),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Hủy xác nhận chuyển nội bộ',
                  child: VitCtaButton(
                    onPressed: () => Navigator.of(context).pop(),
                    variant: VitCtaButtonVariant.secondary,
                    height: AppSurfaceSpacing.ctaHeight,
                    child: const Text('Hủy'),
                  ),
                ),
              ),
              SizedBox(width: _transferInlineGap),
              Expanded(
                child: Semantics(
                  key: const Key('sc146_transfer_confirm'),
                  button: true,
                  enabled: true,
                  label: 'Xác nhận chuyển nội bộ',
                  child: VitCtaButton(
                    onPressed: onConfirm,
                    variant: VitCtaButtonVariant.primary,
                    height: AppSurfaceSpacing.ctaHeight,
                    child: const Text('Xác nhận'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
