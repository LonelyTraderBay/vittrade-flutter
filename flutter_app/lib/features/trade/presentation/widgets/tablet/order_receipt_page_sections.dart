part of '../../tablet/pages/trade_tablet_order_receipt_page.dart';

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == TradeOrderSide.buy;
    final sideColor = isBuy ? AppColors.buy : AppColors.sell;

    return VitTradeSection(
      title: 'Tóm tắt khớp lệnh',
      headerTrailing: _StatusBadge(
        key: TradeTabletOrderReceiptPage.openOrdersKey,
        status: receipt.status,
        onTap: () => context.go(AppRoutePaths.tradeOrdersHistory),
      ),
      child: VitCard(
        clip: true,
        radius: VitCardRadius.tight,
        density: VitDensity.tool,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: VitDensity.tool.cardPadding,
              child: Row(
                children: [
                  _TradeTabletSideBadge(
                    label: isBuy ? 'MUA' : 'BÁN',
                    color: sideColor,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      receipt.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            VitInfoRow(
              label: 'Mã lệnh',
              value: receipt.orderId,
              trailing: _CopyOrderIdButton(orderId: receipt.orderId),
              density: VitDensity.tool,
              valueColor: AppColors.receiptTextMuted,
            ),
            VitInfoRow(
              label: 'Loại lệnh',
              value: receipt.orderType,
              density: VitDensity.tool,
              valueColor: AppColors.receiptTextMuted,
            ),
            VitInfoRow(
              label: 'Giá',
              value: '\$${formatTradeMoney(receipt.price)}',
              density: VitDensity.tool,
              valueColor: AppColors.receiptTextMuted,
            ),
            VitInfoRow(
              label: 'Khối lượng',
              value:
                  '${receipt.amount.toStringAsFixed(6)} ${receipt.baseAsset}',
              density: VitDensity.tool,
              valueColor: AppColors.receiptTextMuted,
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            VitInfoRow(
              label: 'Thành tiền',
              value: '\$${formatTradeMoney(receipt.total)}',
              density: VitDensity.tool,
              valueColor: AppColors.text1,
            ),
            VitInfoRow(
              label: 'Phí giao dịch',
              value: '\$${receipt.fee.toStringAsFixed(4)} (${receipt.feeRate})',
              density: VitDensity.tool,
              valueColor: AppColors.receiptTextMuted,
            ),
            if (receipt.estimatedFill != null)
              VitInfoRow(
                label: 'Thời gian ước tính',
                value: receipt.estimatedFill!,
                density: VitDensity.tool,
                valueColor: AppColors.receiptTextMuted,
              ),
            VitInfoRow(
              label: 'Thời gian đặt',
              value: receipt.timestamp,
              density: VitDensity.tool,
              valueColor: AppColors.receiptTextMuted,
            ),
            if (receipt.tpPrice != null || receipt.slPrice != null) ...[
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
              Padding(
                padding: VitDensity.tool.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Kiểm soát rủi ro',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMutedLight,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        if (receipt.tpPrice != null)
                          Expanded(
                            child: _RiskBox(
                              label: 'Chốt lời',
                              value: formatTradePrice(receipt.tpPrice!),
                              color: AppColors.buy,
                            ),
                          ),
                        if (receipt.tpPrice != null && receipt.slPrice != null)
                          const SizedBox(width: AppSpacing.x2),
                        if (receipt.slPrice != null)
                          Expanded(
                            child: _RiskBox(
                              label: 'Cắt lỗ',
                              value: formatTradePrice(receipt.slPrice!),
                              color: AppColors.sell,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TradeTabletSideBadge extends StatelessWidget {
  const _TradeTabletSideBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({super.key, required this.status, required this.onTap});

  final TradeReceiptStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      TradeReceiptStatus.submitted => 'Đã gửi',
      TradeReceiptStatus.pending => 'Đang xử lý',
      TradeReceiptStatus.partiallyFilled => 'Khớp 1 phần',
    };

    return VitStatusPill(
      label: label,
      status: VitStatusPillStatus.info,
      size: VitStatusPillSize.sm,
      onTap: onTap,
    );
  }
}

class _CopyOrderIdButton extends StatelessWidget {
  const _CopyOrderIdButton({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _receiptCopyActionExtent,
      height: _receiptCopyActionExtent,
      child: VitInlineIconAction(
        key: TradeTabletOrderReceiptPage.copyOrderIdKey,
        icon: Icons.copy_rounded,
        tooltip: 'Sao chép mã lệnh',
        color: AppColors.text3,
        size: AppSpacing.iconSm,
        padding: 0,
        onPressed: () => Clipboard.setData(ClipboardData(text: orderId)),
      ),
    );
  }
}
