part of '../../phone/pages/ads/p2p_ad_detail_page.dart';

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      padding: P2PSpacingTokens.p2pAdDetailCompactCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giá',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${ad.asset == 'USDT' ? 'VND' : 'VND'}/${ad.asset}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceMeta(
                  label: 'Khả dụng',
                  value:
                      '${_formatAmount(snapshot.availableAmount)} ${ad.asset}',
                ),
              ),
              Expanded(
                child: _PriceMeta(
                  label: 'Giới hạn',
                  value:
                      '${_formatVnd(ad.minLimit)} -\n${_formatVnd(ad.maxLimit)}',
                ),
              ),
              Expanded(
                child: _PriceMeta(label: 'Phản hồi', value: ad.avgResponseTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceMeta extends StatelessWidget {
  const _PriceMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.snapshot,
    required this.selectedPercent,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.onPercent,
  });

  final P2PAdDetailSnapshot snapshot;
  final int? selectedPercent;
  final int fiatAmount;
  final double cryptoAmount;
  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      padding: P2PSpacingTokens.p2pAdDetailCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhập số lượng',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Số tiền (VND)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          _InputShell(
            value: fiatAmount == 0
                ? '${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}'
                : _formatVnd(fiatAmount),
            suffix: 'VND',
            muted: fiatAmount == 0,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Số lượng (${ad.asset})',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          _InputShell(
            value: cryptoAmount == 0 ? '0.00' : cryptoAmount.toStringAsFixed(6),
            suffix: ad.asset,
            muted: cryptoAmount == 0,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitPresetChipRow<double>(
            selectedValue: selectedPercent?.toDouble(),
            onTap: (value) => onPercent(value.round()),
            accentColor: AppModuleAccents.p2p,
            height: AppSpacing.buttonCompact,
            padding: P2PSpacingTokens.p2pAdDetailPercentPadding,
            gap: AppSpacing.x3,
            items: [
              for (final percent in const [25, 50, 75, 100])
                VitPresetChipItem(
                  key: P2PAdDetailPage.percentKey(percent),
                  value: percent.toDouble(),
                  label: '$percent%',
                  semanticLabel: 'Chọn $percent% số lượng quảng cáo P2P',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  const _InputShell({
    required this.value,
    required this.suffix,
    required this.muted,
  });

  final String value;
  final String suffix;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonCompact),
      child: Material(
        color: AppColors.surface2,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: AppColors.accent20),
        ),
        child: Padding(
          padding: P2PSpacingTokens.p2pAdDetailInputPadding,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: muted ? AppColors.text3 : AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                suffix,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent08,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: AppColors.accent20),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pAdDetailCompactCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Yêu cầu đối tác',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                VitAccentPill(
                  label: 'KYC cấp ${snapshot.minKycLevel}+',
                  accentColor: AppColors.accent,
                ),
                VitAccentPill(
                  label: '${snapshot.minCompletedTrades}+ giao dịch',
                  accentColor: AppColors.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pAdDetailCardPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Điều kiện giao dịch',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _EscrowCard extends StatelessWidget {
  const _EscrowCard({required this.snapshot, required this.amount});

  final P2PAdDetailSnapshot snapshot;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: AppColors.buy20),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pAdDetailCompactCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Tài sản được bảo vệ bởi hệ thống Escrow VitTrade. ${amount.toStringAsFixed(2)} ${snapshot.ad.asset} sẽ được khóa cho đến khi xác nhận thanh toán thành công.',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: AppColors.warn);
  }
}

String _formatVnd(num value) => formatP2PVnd(value);

String _formatAmount(num value) {
  final parts = value.toStringAsFixed(2).split('.');
  return '${_formatCount(parts.first)}.${parts.last}';
}

String _formatCount(String raw) => VitFormat.thousands(raw);

String _formatCompactUsd(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).round()}K';
  return value.toString();
}

String _fixed(double value) => value.toStringAsFixed(1);
