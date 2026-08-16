part of '../../phone/pages/orders/p2p_escrow_detail_page.dart';

class _MultiSigCard extends StatelessWidget {
  const _MultiSigCard({required this.snapshot});

  final P2PEscrowDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.multisigKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pEscrowDetailCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_2_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Multi-Signature (${snapshot.signedCount}/${snapshot.signerCount})',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SignatureRing(
                signed: snapshot.signedCount,
                total: snapshot.signerCount,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Escrow yêu cầu tối thiểu 2/3 chữ ký để giải phóng coin. Platform luôn ký khi tạo escrow (1/3).',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _p2pEscrowSectionGap),
          for (final signer in snapshot.signers) ...[
            _SignerRow(signer: signer),
            if (signer != snapshot.signers.last)
              const SizedBox(height: _p2pEscrowTightGap),
          ],
        ],
      ),
    );
  }
}

class _SignatureRing extends StatelessWidget {
  const _SignatureRing({required this.signed, required this.total});

  final int signed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : signed / total;
    return SizedBox(
      width: _p2pEscrowRingSize,
      height: _p2pEscrowRingSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: P2PSpacingTokens.p2pEscrowDetailSignatureStroke,
            color: AppColors.buy,
            backgroundColor: AppColors.surface3,
          ),
          Text(
            '$signed/$total',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final P2PEscrowSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    final status = signer.hasSigned
        ? VitStatusPillStatus.success
        : VitStatusPillStatus.neutral;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: signer.hasSigned ? AppColors.buy20 : AppColors.borderSolid,
      padding: P2PSpacingTokens.p2pEscrowDetailInnerPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.buttonCompact,
            child: Material(
              color: signer.hasSigned ? AppColors.buy15 : AppColors.surface3,
              shape: const CircleBorder(),
              child: Icon(
                signer.hasSigned
                    ? Icons.check_circle_outline_rounded
                    : Icons.schedule_rounded,
                color: signer.hasSigned ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signer.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: signer.hasSigned ? AppColors.text1 : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  signer.maskedAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VitStatusPill(
                label: signer.hasSigned ? 'Đã ký' : 'Chờ ký',
                status: status,
                size: VitStatusPillSize.sm,
              ),
              if (signer.signedAt != null)
                Text(
                  signer.signedAt!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Mã đơn', order.orderNumber, false),
      ('Loại', '${order.typeLabel} ${order.asset}', false),
      (
        'Số lượng',
        '${_formatAmount4(order.escrowAmount)} ${order.asset}',
        false,
      ),
      ('Giá', '${_formatVnd(order.priceVnd)} VND/${order.asset}', false),
      ('Tổng', '${_formatVnd(order.totalVnd)} ${order.currency}', true),
      ('Merchant', order.merchant, false),
      ('Phương thức TT', order.paymentMethod, false),
    ];

    return VitCard(
      key: P2PEscrowDetailPage.orderInfoKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pEscrowDetailCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thông tin đơn hàng',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _p2pEscrowTightGap),
          for (final row in rows) ...[
            _InfoRow(label: row.$1, value: row.$2, emphasis: row.$3),
            if (row != rows.last)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.emphasis,
  });

  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pEscrowDetailInfoRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: emphasis
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
